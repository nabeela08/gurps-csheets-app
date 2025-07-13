// WORDIAMO Results Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const loadingState = document.getElementById('loadingState');
const resultsContent = document.getElementById('resultsContent');
const errorState = document.getElementById('errorState');

// Header elements
const lessonName = document.getElementById('lessonName');

// Summary elements
const quizTitle = document.getElementById('quizTitle');
const completionMessage = document.getElementById('completionMessage');
const overallScore = document.getElementById('overallScore');
const correctCount = document.getElementById('correctCount');
const incorrectCount = document.getElementById('incorrectCount');
const timeTaken = document.getElementById('timeTaken');
const performanceLabel = document.getElementById('performanceLabel');
const performanceBar = document.getElementById('performanceBar');

// Button elements
const retakeQuizBtn = document.getElementById('retakeQuizBtn');
const reviewAnswersBtn = document.getElementById('reviewAnswersBtn');
const continuelearningBtn = document.getElementById('continuelearningBtn');

// Review elements
const reviewSection = document.getElementById('reviewSection');
const questionsReview = document.getElementById('questionsReview');
const questionTypesBreakdown = document.getElementById('questionTypesBreakdown');
const improvementAreas = document.getElementById('improvementAreas');

// Global variables
let quizResults = null;

// Initialize results page
document.addEventListener('DOMContentLoaded', function() {
    // Check authentication
    if (!isLoggedIn()) {
        window.location.href = '../pages/login.html';
        return;
    }

    // Set up event listeners
    setupEventListeners();
    
    // Load quiz results
    loadResults();
});

// Event Listeners Setup
function setupEventListeners() {
    // Action buttons
    retakeQuizBtn.addEventListener('click', retakeQuiz);
    reviewAnswersBtn.addEventListener('click', toggleReviewSection);
    continuelearningBtn.addEventListener('click', continueLearning);
}

// Load Quiz Results
function loadResults() {
    try {
        showLoading();
        
        // Get results from localStorage (saved by quiz.js)
        const savedResults = localStorage.getItem('lastQuizResults');
        
        if (!savedResults) {
            showError();
            return;
        }
        
        quizResults = JSON.parse(savedResults);
        
        // Display results
        displayResults();
        showResults();
        
    } catch (error) {
        console.error('Error loading results:', error);
        showError();
    }
}

// Display Quiz Results
function displayResults() {
    if (!quizResults) return;
    
    // Update header
    lessonName.textContent = quizResults.lessonName || 'Quiz Results';
    quizTitle.textContent = `${quizResults.lessonName} - Complete!`;
    
    // Calculate performance metrics
    const totalQuestions = quizResults.totalQuestions;
    const correctAnswers = quizResults.score;
    const incorrectAnswers = totalQuestions - correctAnswers;
    const scorePercentage = quizResults.scorePercentage;
    
    // Update summary metrics
    overallScore.textContent = `${scorePercentage}%`;
    correctCount.textContent = correctAnswers;
    incorrectCount.textContent = incorrectAnswers;
    timeTaken.textContent = formatTime(quizResults.timeTaken);
    
    // Update performance bar and label
    updatePerformanceIndicators(scorePercentage);
    
    // Generate detailed analysis
    generatePerformanceAnalysis();
    
    // Set completion message based on performance
    updateCompletionMessage(scorePercentage);
}

// Update Performance Indicators
function updatePerformanceIndicators(scorePercentage) {
    // Update performance bar
    performanceBar.style.width = `${scorePercentage}%`;
    
    // Update performance label and color
    let label, colorClass;
    
    if (scorePercentage >= 90) {
        label = 'Excellent';
        colorClass = 'from-green-500 to-green-600';
    } else if (scorePercentage >= 80) {
        label = 'Great';
        colorClass = 'from-blue-500 to-blue-600';
    } else if (scorePercentage >= 70) {
        label = 'Good';
        colorClass = 'from-primary to-secondary';
    } else if (scorePercentage >= 60) {
        label = 'Fair';
        colorClass = 'from-yellow-500 to-yellow-600';
    } else {
        label = 'Needs Improvement';
        colorClass = 'from-red-500 to-red-600';
    }
    
    performanceLabel.textContent = label;
    performanceBar.className = `bg-gradient-to-r ${colorClass} h-3 rounded-full transition-all duration-500`;
}

// Update Completion Message
function updateCompletionMessage(scorePercentage) {
    let message;
    
    if (scorePercentage >= 90) {
        message = 'Outstanding performance! You are mastering this material.';
    } else if (scorePercentage >= 80) {
        message = 'Great job! You have a solid understanding of the concepts.';
    } else if (scorePercentage >= 70) {
        message = 'Good work! A few areas to review and you\'ll be excellent.';
    } else if (scorePercentage >= 60) {
        message = 'You\'re on the right track. Keep practicing to improve.';
    } else {
        message = 'Don\'t worry! Review the material and try again.';
    }
    
    completionMessage.textContent = message;
}

// Generate Performance Analysis
function generatePerformanceAnalysis() {
    if (!quizResults.questions) return;
    
    // Analyze question types performance
    const typePerformance = analyzeQuestionTypes();
    renderQuestionTypesBreakdown(typePerformance);
    
    // Generate improvement suggestions
    const improvements = generateImprovementSuggestions(typePerformance);
    renderImprovementAreas(improvements);
}

// Analyze Question Types Performance
function analyzeQuestionTypes() {
    const typeStats = {};
    
    quizResults.questions.forEach((question, index) => {
        const questionType = question.question_type || 'vocabulary';
        const userAnswer = quizResults.answers[index];
        const isCorrect = userAnswer !== null && userAnswer === getCorrectOptionId(question);
        
        if (!typeStats[questionType]) {
            typeStats[questionType] = {
                total: 0,
                correct: 0,
                questions: []
            };
        }
        
        typeStats[questionType].total++;
        if (isCorrect) {
            typeStats[questionType].correct++;
        }
        typeStats[questionType].questions.push({
            question: question,
            isCorrect: isCorrect,
            index: index
        });
    });
    
    return typeStats;
}

// Get Correct Option ID for a question
function getCorrectOptionId(question) {
    if (!question.options) return null;
    
    const correctOption = question.options.find(option => option.is_correct);
    return correctOption ? correctOption.option_id : null;
}

// Render Question Types Breakdown
function renderQuestionTypesBreakdown(typePerformance) {
    const container = questionTypesBreakdown;
    container.innerHTML = '';
    
    Object.entries(typePerformance).forEach(([type, stats]) => {
        const percentage = Math.round((stats.correct / stats.total) * 100);
        const typeLabel = formatQuestionType(type);
        
        const typeElement = document.createElement('div');
        typeElement.className = 'border border-gray-200 rounded-lg p-4';
        
        typeElement.innerHTML = `
            <div class="flex justify-between items-center mb-2">
                <h5 class="font-medium text-gray-900">${typeLabel}</h5>
                <span class="text-sm font-semibold ${percentage >= 70 ? 'text-green-600' : percentage >= 50 ? 'text-yellow-600' : 'text-red-600'}">
                    ${stats.correct}/${stats.total} (${percentage}%)
                </span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
                <div class="h-2 rounded-full transition-all duration-500 ${percentage >= 70 ? 'bg-green-500' : percentage >= 50 ? 'bg-yellow-500' : 'bg-red-500'}" 
                     style="width: ${percentage}%"></div>
            </div>
        `;
        
        container.appendChild(typeElement);
    });
}

// Generate Improvement Suggestions
function generateImprovementSuggestions(typePerformance) {
    const suggestions = [];
    
    Object.entries(typePerformance).forEach(([type, stats]) => {
        const percentage = (stats.correct / stats.total) * 100;
        
        if (percentage < 70) {
            let suggestion = {
                type: type,
                percentage: percentage,
                message: '',
                icon: ''
            };
            
            switch(type) {
                case 'vocabulary':
                    suggestion.message = 'Practice more vocabulary exercises and flashcards';
                    suggestion.icon = '📚';
                    break;
                case 'grammar':
                    suggestion.message = 'Review grammar rules and sentence structures';
                    suggestion.icon = '📝';
                    break;
                case 'sentence_formation':
                    suggestion.message = 'Work on building complete sentences';
                    suggestion.icon = '🔗';
                    break;
                case 'fill_in_blank':
                    suggestion.message = 'Practice context clues and word associations';
                    suggestion.icon = '🔍';
                    break;
                case 'error_correction':
                    suggestion.message = 'Focus on identifying common mistakes';
                    suggestion.icon = '✏️';
                    break;
                default:
                    suggestion.message = 'Review this topic more thoroughly';
                    suggestion.icon = '💡';
            }
            
            suggestions.push(suggestion);
        }
    });
    
    // Add general suggestions if overall performance is low
    if (quizResults.scorePercentage < 60) {
        suggestions.push({
            type: 'general',
            percentage: quizResults.scorePercentage,
            message: 'Consider reviewing the lesson material before retaking',
            icon: '📖'
        });
    }
    
    return suggestions;
}

// Render Improvement Areas
function renderImprovementAreas(suggestions) {
    const container = improvementAreas;
    
    if (suggestions.length === 0) {
        container.innerHTML = `
            <div class="text-center py-4">
                <div class="text-green-600 text-2xl mb-2">🎉</div>
                <p class="text-green-700 font-medium">Excellent work!</p>
                <p class="text-sm text-gray-600">You're performing well in all areas.</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = suggestions.map(suggestion => `
        <div class="flex items-start space-x-3 p-3 bg-yellow-50 rounded-lg border border-yellow-200">
            <span class="text-xl">${suggestion.icon}</span>
            <div class="flex-1">
                <p class="text-sm font-medium text-gray-900">${formatQuestionType(suggestion.type)}</p>
                <p class="text-sm text-gray-600">${suggestion.message}</p>
            </div>
        </div>
    `).join('');
}

// Toggle Review Section
function toggleReviewSection() {
    if (reviewSection.classList.contains('hidden')) {
        generateQuestionReview();
        reviewSection.classList.remove('hidden');
        reviewAnswersBtn.textContent = 'Hide Review';
    } else {
        reviewSection.classList.add('hidden');
        reviewAnswersBtn.textContent = 'Review Answers';
    }
}

// Generate Question Review
function generateQuestionReview() {
    if (!quizResults.questions) return;
    
    const container = questionsReview;
    container.innerHTML = '';
    
    quizResults.questions.forEach((question, index) => {
        const userAnswer = quizResults.answers[index];
        const correctOptionId = getCorrectOptionId(question);
        const isCorrect = userAnswer !== null && userAnswer === correctOptionId;
        const isSkipped = userAnswer === null;
        
        const questionElement = document.createElement('div');
        questionElement.className = `border-2 rounded-lg p-6 ${isCorrect ? 'border-green-200 bg-green-50' : isSkipped ? 'border-yellow-200 bg-yellow-50' : 'border-red-200 bg-red-50'}`;
        
        // Get user selected option
        const userSelectedOption = question.options?.find(opt => opt.option_id === userAnswer);
        const correctOption = question.options?.find(opt => opt.option_id === correctOptionId);
        
        questionElement.innerHTML = `
            <div class="flex items-start justify-between mb-4">
                <div class="flex items-center space-x-3">
                    <span class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold ${isCorrect ? 'bg-green-500 text-white' : isSkipped ? 'bg-yellow-500 text-white' : 'bg-red-500 text-white'}">
                        ${index + 1}
                    </span>
                    <div>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${getQuestionTypeBadgeClass(question.question_type)}">
                            ${formatQuestionType(question.question_type)}
                        </span>
                    </div>
                </div>
                <div class="flex items-center space-x-2">
                    ${isCorrect ? `
                        <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="text-green-700 font-medium">Correct</span>
                    ` : isSkipped ? `
                        <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.732 15.5c-.77.833.192 2.5 1.732 2.5z"></path>
                        </svg>
                        <span class="text-yellow-700 font-medium">Skipped</span>
                    ` : `
                        <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="text-red-700 font-medium">Incorrect</span>
                    `}
                </div>
            </div>
            
            <h4 class="text-lg font-medium text-gray-900 mb-4">${question.question_text}</h4>
            
            <div class="space-y-2 mb-4">
                ${question.options?.map((option, optIndex) => `
                    <div class="p-3 rounded-lg border-2 ${
                        option.option_id === correctOptionId ? 'border-green-500 bg-green-100' :
                        option.option_id === userAnswer && !isCorrect ? 'border-red-500 bg-red-100' :
                        'border-gray-200 bg-white'
                    }">
                        <div class="flex items-center space-x-3">
                            <div class="flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-sm font-semibold ${
                                option.option_id === correctOptionId ? 'bg-green-500 text-white' :
                                option.option_id === userAnswer && !isCorrect ? 'bg-red-500 text-white' :
                                'bg-gray-200 text-gray-600'
                            }">
                                ${String.fromCharCode(65 + optIndex)}
                            </div>
                            <p class="text-gray-900">${option.option_text}</p>
                            ${option.option_id === correctOptionId ? '<span class="ml-auto text-green-600 font-medium">✓ Correct</span>' : ''}
                            ${option.option_id === userAnswer && !isCorrect ? '<span class="ml-auto text-red-600 font-medium">Your answer</span>' : ''}
                        </div>
                    </div>
                `).join('') || '<p class="text-gray-500">No options available</p>'}
            </div>
            
            ${!isSkipped ? `
                <div class="border-t border-gray-200 pt-4">
                    <div class="text-sm">
                        <span class="font-medium text-gray-700">Your Answer:</span>
                        <span class="${isCorrect ? 'text-green-700' : 'text-red-700'}">${userSelectedOption?.option_text || 'No answer selected'}</span>
                    </div>
                    ${!isCorrect ? `
                        <div class="text-sm mt-1">
                            <span class="font-medium text-gray-700">Correct Answer:</span>
                            <span class="text-green-700">${correctOption?.option_text || 'Not available'}</span>
                        </div>
                    ` : ''}
                </div>
            ` : `
                <div class="border-t border-gray-200 pt-4">
                    <div class="text-sm">
                        <span class="font-medium text-gray-700">Correct Answer:</span>
                        <span class="text-green-700">${correctOption?.option_text || 'Not available'}</span>
                    </div>
                </div>
            `}
        `;
        
        container.appendChild(questionElement);
    });
}

// Navigation Functions
function retakeQuiz() {
    if (quizResults && quizResults.lessonId) {
        window.location.href = `../pages/quiz.html?lesson=${quizResults.lessonId}`;
    } else {
        window.location.href = '../pages/dashboard.html';
    }
}

function continueLearning() {
    window.location.href = '../pages/dashboard.html';
}

// Utility Functions
function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

function formatQuestionType(type) {
    const types = {
        'vocabulary': 'Vocabulary',
        'grammar': 'Grammar',
        'sentence_formation': 'Sentence Formation',
        'fill_in_blank': 'Fill in the Blank',
        'error_correction': 'Error Correction',
        'general': 'General'
    };
    return types[type] || 'Question';
}

function getQuestionTypeBadgeClass(type) {
    const classes = {
        'vocabulary': 'bg-blue-100 text-blue-700',
        'grammar': 'bg-green-100 text-green-700',
        'sentence_formation': 'bg-purple-100 text-purple-700',
        'fill_in_blank': 'bg-yellow-100 text-yellow-700',
        'error_correction': 'bg-red-100 text-red-700'
    };
    return classes[type] || 'bg-gray-100 text-gray-700';
}

function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

// UI State Functions
function showLoading() {
    loadingState.classList.remove('hidden');
    resultsContent.classList.add('hidden');
    errorState.classList.add('hidden');
}

function showResults() {
    loadingState.classList.add('hidden');
    resultsContent.classList.remove('hidden');
    errorState.classList.add('hidden');
}

function showError() {
    loadingState.classList.add('hidden');
    resultsContent.classList.add('hidden');
    errorState.classList.remove('hidden');
}