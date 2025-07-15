// WORDIAMO Quiz Interface JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// Quiz State
let quizData = {
    lessonId: null,
    questions: [],
    currentQuestionIndex: 0,
    answers: {},
    score: 0,
    startTime: null,
    endTime: null
};

// DOM Elements
const loadingState = document.getElementById('loadingState');
const quizContent = document.getElementById('quizContent');
const quizComplete = document.getElementById('quizComplete');
const exitModal = document.getElementById('exitModal');

// Header elements
const quizTitle = document.getElementById('quizTitle');
const lessonName = document.getElementById('lessonName');
const timer = document.getElementById('timer');
const progressBar = document.getElementById('progressBar');

// Question elements
const currentQuestionEl = document.getElementById('currentQuestion');
const totalQuestionsEl = document.getElementById('totalQuestions');
const currentScoreEl = document.getElementById('currentScore');
const questionText = document.getElementById('questionText');
const optionsContainer = document.getElementById('optionsContainer');
const feedbackSection = document.getElementById('feedbackSection');
const feedbackIcon = document.getElementById('feedbackIcon');
const feedbackText = document.getElementById('feedbackText');
const explanationText = document.getElementById('explanationText');

// Button elements
const exitQuizBtn = document.getElementById('exitQuizBtn');
const nextBtn = document.getElementById('nextBtn');
const submitBtn = document.getElementById('submitBtn');
const cancelExitBtn = document.getElementById('cancelExitBtn');
const confirmExitBtn = document.getElementById('confirmExitBtn');
const viewResultsBtn = document.getElementById('viewResultsBtn');

// Timer variables
let timerInterval = null;
let elapsedSeconds = 0;

// Initialize quiz
document.addEventListener('DOMContentLoaded', function() {
    // Check authentication
    if (!isLoggedIn()) {
        window.location.href = '../pages/login.html';
        return;
    }

    // Get lesson ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const lessonId = urlParams.get('lesson');
    
    if (!lessonId) {
        alert('No lesson selected. Redirecting to dashboard...');
        window.location.href = '../pages/dashboard.html';
        return;
    }

    quizData.lessonId = parseInt(lessonId);
    
    // Set up event listeners
    setupEventListeners();
    
    // Start quiz
    startQuiz();
});

// Event Listeners Setup
function setupEventListeners() {
    // Quiz navigation
    submitBtn.addEventListener('click', submitAnswer);
    nextBtn.addEventListener('click', nextQuestion);
    
    // Exit quiz
    exitQuizBtn.addEventListener('click', showExitModal);
    cancelExitBtn.addEventListener('click', hideExitModal);
    confirmExitBtn.addEventListener('click', exitQuiz);
    
    // View results (only works when quiz is complete)
    if (viewResultsBtn) {
        viewResultsBtn.addEventListener('click', function() {
            // Use safe navigation to avoid beforeunload warning
            window.safeNavigate('results.html');
        });
    }
    
    // Global navigation control
    window.allowNavigation = false;
    
    // Prevent accidental page refresh (but not during quiz completion or navigation)
    window.addEventListener('beforeunload', function(e) {
        if (!window.allowNavigation && quizData.currentQuestionIndex < quizData.questions.length) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
    
    // Function to safely navigate without warning
    window.safeNavigate = function(url) {
        window.allowNavigation = true;
        window.location.href = url;
    };
}

// Start Quiz
async function startQuiz() {
    try {
        showLoading();
        
        // Start quiz session via API
        const response = await fetch(`${API_BASE_URL}/quiz/start`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${getAuthToken()}`
            },
            body: JSON.stringify({
                lesson_id: quizData.lessonId
            })
        });
        
        if (!response.ok) {
            throw new Error('Failed to start quiz');
        }
        
        const data = await response.json();
        console.log('Quiz start response:', data); // Debug log
        
        // Check if response is successful
        if (!data.success) {
            throw new Error(data.message || 'Failed to start quiz');
        }
        
        // Initialize quiz data from session-based response
        quizData.questions = data.question ? [data.question] : [];
        quizData.currentQuestionIndex = 0;
        quizData.startTime = new Date();
        
        console.log('Questions loaded:', quizData.questions.length); // Debug log
        
        // Update UI with session data
        if (data.session_data) {
            quizTitle.textContent = data.session_data.lesson_name || 'Quiz';
            lessonName.textContent = 'English Learning';
            totalQuestionsEl.textContent = data.session_data.total_questions || 0;
            console.log('Total questions:', data.session_data.total_questions); // Debug log
        }
        
        // Start timer
        startTimer();
        
        // Show first question
        showQuestion();
        
        // Show quiz content
        showQuizContent();
        
    } catch (error) {
        console.error('Error starting quiz:', error);
        console.error('Error stack:', error.stack);
        alert('Failed to load quiz: ' + error.message);
        window.location.href = '../pages/dashboard.html';
    }
}

// Show Current Question
function showQuestion() {
    const question = quizData.questions[quizData.currentQuestionIndex];
    
    if (!question) {
        completeQuiz();
        return;
    }
    
    // Update question counter
    currentQuestionEl.textContent = quizData.currentQuestionIndex + 1;
    
    // Update progress bar
    const progress = ((quizData.currentQuestionIndex) / quizData.questions.length) * 100;
    progressBar.style.width = `${progress}%`;
    
    // Update question text
    questionText.textContent = question.question_text;
    
    // Clear previous feedback
    hideFeedback();
    
    // Reset buttons
    submitBtn.disabled = true;
    submitBtn.classList.remove('hidden');
    nextBtn.classList.add('hidden');
    
    // Render options
    renderOptions(question.options);
}

// Render Answer Options
function renderOptions(options) {
    optionsContainer.innerHTML = '';
    
    options.forEach((option, index) => {
        const optionEl = document.createElement('button');
        optionEl.className = 'w-full text-left p-4 rounded-lg border-2 border-gray-200 hover:border-primary/50 transition-all duration-200 bg-white';
        optionEl.dataset.optionId = option.option_id;
        
        optionEl.innerHTML = `
            <div class="flex items-center space-x-3">
                <div class="flex-shrink-0 w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center text-sm font-semibold text-gray-600">
                    ${String.fromCharCode(65 + index)}
                </div>
                <p class="text-gray-900">${option.option_text}</p>
            </div>
        `;
        
        optionEl.addEventListener('click', () => selectOption(option.option_id, optionEl));
        optionsContainer.appendChild(optionEl);
    });
}

// Select Option
function selectOption(optionId, optionElement) {
    // Remove previous selection
    const allOptions = optionsContainer.querySelectorAll('button');
    allOptions.forEach(opt => {
        opt.classList.remove('border-primary', 'bg-primary/5');
    });
    
    // Mark selected option
    optionElement.classList.add('border-primary', 'bg-primary/5');
    
    // Store selected answer
    quizData.answers[quizData.currentQuestionIndex] = optionId;
    
    // Enable submit button
    submitBtn.disabled = false;
}

// Submit Answer
async function submitAnswer() {
    const selectedOptionId = quizData.answers[quizData.currentQuestionIndex];
    const question = quizData.questions[quizData.currentQuestionIndex];
    
    if (!selectedOptionId) return;
    
    try {
        // Disable all options
        const allOptions = optionsContainer.querySelectorAll('button');
        allOptions.forEach(opt => opt.disabled = true);
        
        // Submit to API
        const response = await fetch(`${API_BASE_URL}/quiz/submit`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${getAuthToken()}`
            },
            body: JSON.stringify({
                question_id: question.question_id,
                option_id: selectedOptionId
            })
        });
        
        const result = await response.json();
        
        // Show feedback
        showFeedback(result.is_correct, result.correct_option_id, result.explanation);
        
        // Update score if correct
        if (result.is_correct) {
            quizData.score++;
            currentScoreEl.textContent = quizData.score;
        }
        
        // Check if quiz is complete
        if (result.quiz_complete) {
            // Store level upgrade info if available
            if (result.level_upgrade) {
                quizData.levelUpgrade = result.level_upgrade;
            }
            
            // Store detailed results from backend
            if (result.results && result.results.detailed_results) {
                quizData.detailedResults = result.results.detailed_results;
            }
            
            // Store backend results
            if (result.results) {
                quizData.backendResults = result.results;
            }
            
            setTimeout(() => {
                completeQuiz();
            }, 2000);
            return;
        }
        
        // Add next question if available
        if (result.question) {
            quizData.questions.push(result.question);
        }
        
        // Show next button
        submitBtn.classList.add('hidden');
        nextBtn.classList.remove('hidden');
        
    } catch (error) {
        console.error('Error submitting answer:', error);
        alert('Failed to submit answer. Please try again.');
    }
}

// Show Feedback
function showFeedback(isCorrect, correctOptionId, explanation) {
    feedbackSection.classList.remove('hidden');
    
    if (isCorrect) {
        feedbackSection.className = 'mt-6 p-4 rounded-lg bg-green-50 border border-green-200';
        feedbackIcon.innerHTML = `
            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
        `;
        feedbackText.textContent = 'Correct!';
        feedbackText.className = 'font-medium text-green-800';
    } else {
        feedbackSection.className = 'mt-6 p-4 rounded-lg bg-red-50 border border-red-200';
        feedbackIcon.innerHTML = `
            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
        `;
        feedbackText.textContent = 'Incorrect';
        feedbackText.className = 'font-medium text-red-800';
    }
    
    // Show explanation if available
    if (explanation) {
        explanationText.textContent = explanation;
        explanationText.classList.remove('hidden');
    } else {
        explanationText.classList.add('hidden');
    }
    
    // Highlight correct answer
    const allOptions = optionsContainer.querySelectorAll('button');
    allOptions.forEach(opt => {
        const optionId = parseInt(opt.dataset.optionId);
        
        if (optionId === correctOptionId) {
            opt.classList.add('border-green-500', 'bg-green-50');
            const circle = opt.querySelector('.bg-gray-100');
            if (circle) {
                circle.classList.remove('bg-gray-100');
                circle.classList.add('bg-green-500', 'text-white');
            }
        } else if (optionId === quizData.answers[quizData.currentQuestionIndex] && !isCorrect) {
            opt.classList.add('border-red-500', 'bg-red-50');
        }
    });
}

// Hide Feedback
function hideFeedback() {
    feedbackSection.classList.add('hidden');
    explanationText.textContent = '';
}

// Next Question
function nextQuestion() {
    quizData.currentQuestionIndex++;
    
    if (quizData.currentQuestionIndex < quizData.questions.length) {
        showQuestion();
    } else {
        completeQuiz();
    }
}


// Complete Quiz
function completeQuiz() {
    quizData.endTime = new Date();
    stopTimer();
    
    // Allow navigation without warning since quiz is complete
    window.allowNavigation = true;
    
    // Calculate results - use backend results if available
    const totalQuestions = quizData.backendResults?.total_questions || quizData.questions.length;
    const correctAnswers = quizData.backendResults?.correct_answers || quizData.score;
    const scorePercentage = quizData.backendResults?.score_percentage || Math.round((correctAnswers / totalQuestions) * 100);
    const timeTaken = formatTime(elapsedSeconds);
    
    // Update completion screen
    document.getElementById('finalScore').textContent = `${scorePercentage}%`;
    document.getElementById('correctAnswers').textContent = `${correctAnswers}/${totalQuestions}`;
    document.getElementById('timeTaken').textContent = timeTaken;
    
    // Save results to localStorage for results page
    const quizResults = {
        lessonId: quizData.lessonId,
        lessonName: lessonName.textContent,
        questions: quizData.detailedResults || quizData.questions, // Use detailed results if available
        answers: quizData.answers,
        score: correctAnswers,
        totalQuestions: totalQuestions,
        scorePercentage: scorePercentage,
        timeTaken: elapsedSeconds,
        completedAt: new Date().toISOString(),
        detailedResults: quizData.detailedResults // Include detailed results
    };
    
    localStorage.setItem('lastQuizResults', JSON.stringify(quizResults));
    
    // Show completion screen
    showQuizComplete();
    
    // Check for level upgrade
    if (quizData.levelUpgrade && quizData.levelUpgrade.upgraded) {
        setTimeout(() => {
            showLevelUpgradeModal(quizData.levelUpgrade);
        }, 1000);
    }
}

// Timer Functions
function startTimer() {
    elapsedSeconds = 0;
    timerInterval = setInterval(() => {
        elapsedSeconds++;
        timer.textContent = formatTime(elapsedSeconds);
    }, 1000);
}

function stopTimer() {
    if (timerInterval) {
        clearInterval(timerInterval);
    }
}

function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

// Exit Quiz Functions
function showExitModal() {
    exitModal.classList.remove('hidden');
}

function hideExitModal() {
    exitModal.classList.add('hidden');
}

function exitQuiz() {
    stopTimer();
    window.location.href = '../pages/dashboard.html';
}

// Utility Functions
function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

function getAuthToken() {
    return localStorage.getItem('authToken');
}


// UI State Functions
function showLoading() {
    loadingState.classList.remove('hidden');
    quizContent.classList.add('hidden');
    quizComplete.classList.add('hidden');
}

function showQuizContent() {
    loadingState.classList.add('hidden');
    quizContent.classList.remove('hidden');
    quizComplete.classList.add('hidden');
}

function showQuizComplete() {
    loadingState.classList.add('hidden');
    quizContent.classList.add('hidden');
    quizComplete.classList.remove('hidden');
}

function showLevelUpgradeModal(upgradeInfo) {
    const modalHTML = `
        <div id="levelUpgradeModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-8 max-w-md mx-4 animate-bounce-in">
                <!-- Success Icon -->
                <div class="flex items-center justify-center w-20 h-20 bg-yellow-100 rounded-full mx-auto mb-4">
                    <svg class="w-10 h-10 text-yellow-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clip-rule="evenodd"></path>
                    </svg>
                </div>
                
                <!-- Content -->
                <div class="text-center">
                    <h2 class="text-2xl font-bold text-gray-900 mb-2">🎉 Level Up!</h2>
                    <p class="text-lg text-gray-700 mb-4">Congratulations! You've unlocked a new level!</p>
                    
                    <!-- Level Info -->
                    <div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg p-4 mb-6">
                        <div class="text-sm text-gray-600 mb-1">You've advanced to:</div>
                        <div class="text-xl font-bold text-purple-600">${upgradeInfo.new_level_name}</div>
                        <div class="text-sm text-gray-500 mt-2">
                            ${upgradeInfo.completion_progress.completed_lessons}/${upgradeInfo.completion_progress.total_lessons} lessons completed in previous level!
                        </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="flex space-x-3">
                        <button onclick="closeLevelUpgradeModal()" class="flex-1 bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300 transition-colors">
                            Continue
                        </button>
                        <button onclick="goToNewLevel()" class="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:from-blue-700 hover:to-purple-700 transition-colors">
                            Explore New Lessons
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Add modal to page
    document.body.insertAdjacentHTML('beforeend', modalHTML);
}

function closeLevelUpgradeModal() {
    const modal = document.getElementById('levelUpgradeModal');
    if (modal) {
        modal.remove();
    }
}

function goToNewLevel() {
    closeLevelUpgradeModal();
    // Go to dashboard to see new lessons
    window.location.href = '../pages/dashboard.html';
}