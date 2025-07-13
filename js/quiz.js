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
const questionTypeBadge = document.getElementById('questionTypeBadge');
const questionText = document.getElementById('questionText');
const optionsContainer = document.getElementById('optionsContainer');
const feedbackSection = document.getElementById('feedbackSection');
const feedbackIcon = document.getElementById('feedbackIcon');
const feedbackText = document.getElementById('feedbackText');
const explanationText = document.getElementById('explanationText');

// Button elements
const exitQuizBtn = document.getElementById('exitQuizBtn');
const skipBtn = document.getElementById('skipBtn');
const nextBtn = document.getElementById('nextBtn');
const submitBtn = document.getElementById('submitBtn');
const cancelExitBtn = document.getElementById('cancelExitBtn');
const confirmExitBtn = document.getElementById('confirmExitBtn');

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
    skipBtn.addEventListener('click', skipQuestion);
    
    // Exit quiz
    exitQuizBtn.addEventListener('click', showExitModal);
    cancelExitBtn.addEventListener('click', hideExitModal);
    confirmExitBtn.addEventListener('click', exitQuiz);
    
    // Prevent accidental page refresh
    window.addEventListener('beforeunload', function(e) {
        if (quizData.currentQuestionIndex < quizData.questions.length) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
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
        
        // Initialize quiz data
        quizData.questions = data.questions || [];
        quizData.startTime = new Date();
        
        // Update UI
        quizTitle.textContent = data.lesson_name || 'Quiz';
        lessonName.textContent = data.level_name || 'English Learning';
        totalQuestionsEl.textContent = quizData.questions.length;
        
        // Start timer
        startTimer();
        
        // Show first question
        showQuestion();
        
        // Show quiz content
        showQuizContent();
        
    } catch (error) {
        console.error('Error starting quiz:', error);
        alert('Failed to load quiz. Please try again.');
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
    
    // Update question type badge
    const questionType = question.question_type || 'vocabulary';
    questionTypeBadge.textContent = formatQuestionType(questionType);
    questionTypeBadge.className = `inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${getQuestionTypeBadgeClass(questionType)}`;
    
    // Update question text
    questionText.textContent = question.question_text;
    
    // Clear previous feedback
    hideFeedback();
    
    // Reset buttons
    submitBtn.disabled = true;
    submitBtn.classList.remove('hidden');
    nextBtn.classList.add('hidden');
    skipBtn.classList.remove('hidden');
    
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
                selected_option_id: selectedOptionId
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
        
        // Show next button
        submitBtn.classList.add('hidden');
        nextBtn.classList.remove('hidden');
        skipBtn.classList.add('hidden');
        
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
            opt.querySelector('.bg-gray-100').classList.remove('bg-gray-100');
            opt.querySelector('.bg-gray-100, .bg-green-500').classList.add('bg-green-500', 'text-white');
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

// Skip Question
function skipQuestion() {
    // Mark as skipped (no answer)
    quizData.answers[quizData.currentQuestionIndex] = null;
    
    // Move to next question
    nextQuestion();
}

// Complete Quiz
function completeQuiz() {
    quizData.endTime = new Date();
    stopTimer();
    
    // Calculate results
    const totalQuestions = quizData.questions.length;
    const correctAnswers = quizData.score;
    const scorePercentage = Math.round((correctAnswers / totalQuestions) * 100);
    const timeTaken = formatTime(elapsedSeconds);
    
    // Update completion screen
    document.getElementById('finalScore').textContent = `${scorePercentage}%`;
    document.getElementById('correctAnswers').textContent = `${correctAnswers}/${totalQuestions}`;
    document.getElementById('timeTaken').textContent = timeTaken;
    
    // Save results to localStorage for results page
    const quizResults = {
        lessonId: quizData.lessonId,
        lessonName: lessonName.textContent,
        questions: quizData.questions,
        answers: quizData.answers,
        score: correctAnswers,
        totalQuestions: totalQuestions,
        scorePercentage: scorePercentage,
        timeTaken: elapsedSeconds,
        completedAt: new Date().toISOString()
    };
    
    localStorage.setItem('lastQuizResults', JSON.stringify(quizResults));
    
    // Show completion screen
    showQuizComplete();
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

function formatQuestionType(type) {
    const types = {
        'vocabulary': 'Vocabulary',
        'grammar': 'Grammar',
        'sentence_formation': 'Sentence Formation',
        'fill_in_blank': 'Fill in the Blank',
        'error_correction': 'Error Correction'
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