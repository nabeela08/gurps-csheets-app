// WORDIAMO Lessons Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const loadingState = document.getElementById('loadingState');
const lessonsContent = document.getElementById('lessonsContent');
const errorState = document.getElementById('errorState');
const emptyState = document.getElementById('emptyState');

// Header elements
const pageTitle = document.getElementById('pageTitle');
const levelDescription = document.getElementById('levelDescription');
const levelName = document.getElementById('levelName');
const levelDesc = document.getElementById('levelDesc');
const lessonCount = document.getElementById('lessonCount');
const completedCount = document.getElementById('completedCount');
const progressPercentage = document.getElementById('progressPercentage');

// Filter and search elements
const searchInput = document.getElementById('searchInput');
const statusFilter = document.getElementById('statusFilter');
const difficultyFilter = document.getElementById('difficultyFilter');
const sortBy = document.getElementById('sortBy');

// Content elements
const lessonsGrid = document.getElementById('lessonsGrid');
const emptyMessage = document.getElementById('emptyMessage');

// Modal elements
const lessonModal = document.getElementById('lessonModal');
const modalLessonTitle = document.getElementById('modalLessonTitle');
const modalContent = document.getElementById('modalContent');
const closeModal = document.getElementById('closeModal');
const modalBackBtn = document.getElementById('modalBackBtn');
const previewLessonBtn = document.getElementById('previewLessonBtn');
const startLessonBtn = document.getElementById('startLessonBtn');

// Global variables
let currentLevelId = null;
let allLessons = [];
let filteredLessons = [];
let userProgress = {};
let selectedLesson = null;

// Initialize lessons page
document.addEventListener('DOMContentLoaded', function() {
    // Check authentication
    if (!isLoggedIn()) {
        window.location.href = '../pages/login.html';
        return;
    }

    // Get level ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    currentLevelId = urlParams.get('level');
    
    if (!currentLevelId) {
        // Redirect to dashboard if no level specified
        window.location.href = '../pages/dashboard.html';
        return;
    }

    // Set up event listeners
    setupEventListeners();
    
    // Load lessons data
    loadLessons();
});

// Event Listeners Setup
function setupEventListeners() {
    // Search functionality
    searchInput.addEventListener('input', debounce(filterLessons, 300));
    
    // Filter changes
    statusFilter.addEventListener('change', filterLessons);
    difficultyFilter.addEventListener('change', filterLessons);
    sortBy.addEventListener('change', filterLessons);
    
    // Modal controls
    closeModal.addEventListener('click', closeLessonModal);
    modalBackBtn.addEventListener('click', closeLessonModal);
    startLessonBtn.addEventListener('click', startSelectedLesson);
    previewLessonBtn.addEventListener('click', previewSelectedLesson);
    
    // Close modal on outside click
    lessonModal.addEventListener('click', function(e) {
        if (e.target === lessonModal) {
            closeLessonModal();
        }
    });
    
    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && !lessonModal.classList.contains('hidden')) {
            closeLessonModal();
        }
    });
}

// Load Lessons Data
async function loadLessons() {
    try {
        showLoading();
        
        // Load data in parallel
        const [levelData, lessonsData, progressData] = await Promise.all([
            fetchLevelInfo(),
            fetchLessons(),
            fetchUserProgress()
        ]);
        
        // Store data
        allLessons = lessonsData;
        userProgress = progressData;
        
        // Update UI
        updateLevelHeader(levelData);
        filterLessons(); // This will render the lessons
        showLessons();
        
    } catch (error) {
        console.error('Error loading lessons:', error);
        showError();
    }
}

// Fetch Level Information
async function fetchLevelInfo() {
    const response = await fetch(`${API_BASE_URL}/levels/${currentLevelId}`, {
        headers: {
            'Authorization': `Bearer ${getAuthToken()}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch level info');
    }
    
    return await response.json();
}

// Fetch Lessons
async function fetchLessons() {
    const response = await fetch(`${API_BASE_URL}/levels/${currentLevelId}/lessons`, {
        headers: {
            'Authorization': `Bearer ${getAuthToken()}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch lessons');
    }
    
    const data = await response.json();
    return data.lessons || [];
}

// Fetch User Progress
async function fetchUserProgress() {
    const response = await fetch(`${API_BASE_URL}/user/progress`, {
        headers: {
            'Authorization': `Bearer ${getAuthToken()}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch progress');
    }
    
    return await response.json();
}

// Update Level Header
function updateLevelHeader(levelData) {
    if (levelData) {
        pageTitle.textContent = `${levelData.level_name} Lessons`;
        levelDescription.textContent = `Learn with ${levelData.level_name} level content`;
        levelName.textContent = levelData.level_name;
        levelDesc.textContent = levelData.level_description || 'Enhance your English skills';
        
        // Calculate stats
        const totalLessons = allLessons.length;
        const completedLessons = calculateCompletedLessons();
        const progress = totalLessons > 0 ? Math.round((completedLessons / totalLessons) * 100) : 0;
        
        lessonCount.textContent = `${totalLessons} lesson${totalLessons !== 1 ? 's' : ''}`;
        completedCount.textContent = `${completedLessons} completed`;
        progressPercentage.textContent = `${progress}%`;
    }
}

// Calculate Completed Lessons
function calculateCompletedLessons() {
    return allLessons.filter(lesson => {
        const lessonProgress = userProgress.lessons && userProgress.lessons[lesson.lesson_id];
        return lessonProgress && lessonProgress.completed;
    }).length;
}

// Filter and Sort Lessons
function filterLessons() {
    const searchTerm = searchInput.value.toLowerCase().trim();
    const statusValue = statusFilter.value;
    const difficultyValue = difficultyFilter.value;
    const sortValue = sortBy.value;
    
    // Filter lessons
    filteredLessons = allLessons.filter(lesson => {
        // Search filter
        const matchesSearch = !searchTerm || 
            lesson.lesson_name.toLowerCase().includes(searchTerm) ||
            lesson.lesson_description.toLowerCase().includes(searchTerm);
        
        // Status filter
        const lessonProgress = userProgress.lessons && userProgress.lessons[lesson.lesson_id];
        let matchesStatus = true;
        
        if (statusValue === 'completed') {
            matchesStatus = lessonProgress && lessonProgress.completed;
        } else if (statusValue === 'in_progress') {
            matchesStatus = lessonProgress && lessonProgress.started && !lessonProgress.completed;
        } else if (statusValue === 'not_started') {
            matchesStatus = !lessonProgress || !lessonProgress.started;
        }
        
        // Difficulty filter
        const matchesDifficulty = difficultyValue === 'all' || 
            lesson.difficulty_level === difficultyValue;
        
        return matchesSearch && matchesStatus && matchesDifficulty;
    });
    
    // Sort lessons
    filteredLessons.sort((a, b) => {
        switch (sortValue) {
            case 'name':
                return a.lesson_name.localeCompare(b.lesson_name);
            case 'difficulty':
                const difficultyOrder = { 'easy': 1, 'medium': 2, 'hard': 3 };
                return (difficultyOrder[a.difficulty_level] || 2) - (difficultyOrder[b.difficulty_level] || 2);
            case 'progress':
                const aProgress = getLessonProgress(a.lesson_id);
                const bProgress = getLessonProgress(b.lesson_id);
                return bProgress - aProgress;
            case 'order':
            default:
                return (a.lesson_order || 0) - (b.lesson_order || 0);
        }
    });
    
    // Render lessons
    renderLessons();
}

// Get Lesson Progress Percentage
function getLessonProgress(lessonId) {
    const progress = userProgress.lessons && userProgress.lessons[lessonId];
    if (!progress) return 0;
    if (progress.completed) return 100;
    return progress.progress_percentage || 0;
}

// Render Lessons Grid
function renderLessons() {
    if (filteredLessons.length === 0) {
        showEmptyState();
        return;
    }
    
    hideEmptyState();
    
    lessonsGrid.innerHTML = filteredLessons.map(lesson => {
        const progress = getLessonProgress(lesson.lesson_id);
        const lessonProgress = userProgress.lessons && userProgress.lessons[lesson.lesson_id];
        const isCompleted = lessonProgress && lessonProgress.completed;
        const isStarted = lessonProgress && lessonProgress.started;
        
        return `
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow cursor-pointer lesson-card" 
                 data-lesson-id="${lesson.lesson_id}" onclick="openLessonModal(${lesson.lesson_id})">
                <!-- Lesson Header -->
                <div class="p-6 border-b border-gray-100">
                    <div class="flex items-start justify-between mb-3">
                        <div class="flex-1">
                            <h3 class="text-lg font-semibold text-gray-900 mb-2">${lesson.lesson_name}</h3>
                            <p class="text-sm text-gray-600 line-clamp-2">${lesson.lesson_description || 'Learn new concepts and practice your skills'}</p>
                        </div>
                        <div class="ml-4 flex-shrink-0">
                            ${isCompleted ? `
                                <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                </div>
                            ` : `
                                <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                                    <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                                    </svg>
                                </div>
                            `}
                        </div>
                    </div>
                    
                    <!-- Lesson Meta -->
                    <div class="flex items-center space-x-4 text-xs text-gray-500">
                        <span class="flex items-center">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            ${lesson.estimated_duration || '30'} min
                        </span>
                        <span class="flex items-center">
                            <div class="w-2 h-2 rounded-full mr-2 ${getDifficultyColor(lesson.difficulty_level)}"></div>
                            ${formatDifficulty(lesson.difficulty_level)}
                        </span>
                        <span class="flex items-center">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path>
                            </svg>
                            ${lesson.question_count || 10} questions
                        </span>
                    </div>
                </div>
                
                <!-- Progress Section -->
                <div class="p-6">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm font-medium text-gray-700">Progress</span>
                        <span class="text-sm font-semibold ${progress === 100 ? 'text-green-600' : 'text-primary'}">${progress}%</span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2 mb-4">
                        <div class="h-2 rounded-full transition-all duration-300 ${progress === 100 ? 'bg-green-500' : 'bg-gradient-to-r from-primary to-secondary'}" 
                             style="width: ${progress}%"></div>
                    </div>
                    
                    <!-- Action Button -->
                    <button class="w-full py-2 px-4 rounded-lg font-medium text-sm transition-colors ${
                        isCompleted ? 'bg-green-100 text-green-700 hover:bg-green-200' :
                        isStarted ? 'bg-primary text-white hover:bg-primary/90' :
                        'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }" onclick="event.stopPropagation(); ${isCompleted ? 'reviewLesson' : 'startLesson'}(${lesson.lesson_id})">
                        ${isCompleted ? 'Review Lesson' : isStarted ? 'Continue' : 'Start Lesson'}
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

// Utility Functions for Rendering
function getDifficultyColor(difficulty) {
    const colors = {
        'easy': 'bg-green-400',
        'medium': 'bg-yellow-400',
        'hard': 'bg-red-400'
    };
    return colors[difficulty] || 'bg-gray-400';
}

function formatDifficulty(difficulty) {
    return difficulty ? difficulty.charAt(0).toUpperCase() + difficulty.slice(1) : 'Medium';
}

// Modal Functions
function openLessonModal(lessonId) {
    const lesson = allLessons.find(l => l.lesson_id === lessonId);
    if (!lesson) return;
    
    selectedLesson = lesson;
    const progress = getLessonProgress(lessonId);
    const lessonProgress = userProgress.lessons && userProgress.lessons[lessonId];
    const isCompleted = lessonProgress && lessonProgress.completed;
    const isStarted = lessonProgress && lessonProgress.started;
    
    // Update modal content
    modalLessonTitle.textContent = lesson.lesson_name;
    
    modalContent.innerHTML = `
        <div class="space-y-6">
            <!-- Lesson Overview -->
            <div>
                <h4 class="text-lg font-semibold text-gray-900 mb-3">Lesson Overview</h4>
                <p class="text-gray-600">${lesson.lesson_description || 'This lesson will help you improve your English skills with practical exercises and examples.'}</p>
            </div>
            
            <!-- Lesson Details -->
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="flex items-center space-x-2 mb-2">
                        <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span class="text-sm font-medium text-gray-700">Duration</span>
                    </div>
                    <p class="text-lg font-semibold text-gray-900">${lesson.estimated_duration || 30} minutes</p>
                </div>
                
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="flex items-center space-x-2 mb-2">
                        <div class="w-3 h-3 rounded-full ${getDifficultyColor(lesson.difficulty_level)}"></div>
                        <span class="text-sm font-medium text-gray-700">Difficulty</span>
                    </div>
                    <p class="text-lg font-semibold text-gray-900">${formatDifficulty(lesson.difficulty_level)}</p>
                </div>
                
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="flex items-center space-x-2 mb-2">
                        <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path>
                        </svg>
                        <span class="text-sm font-medium text-gray-700">Questions</span>
                    </div>
                    <p class="text-lg font-semibold text-gray-900">${lesson.question_count || 10}</p>
                </div>
                
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="flex items-center space-x-2 mb-2">
                        <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                        <span class="text-sm font-medium text-gray-700">Progress</span>
                    </div>
                    <p class="text-lg font-semibold ${progress === 100 ? 'text-green-600' : 'text-primary'}">${progress}%</p>
                </div>
            </div>
            
            <!-- Learning Objectives -->
            <div>
                <h4 class="text-lg font-semibold text-gray-900 mb-3">What You'll Learn</h4>
                <ul class="space-y-2">
                    ${(lesson.learning_objectives || [
                        'Improve vocabulary and comprehension',
                        'Practice grammar rules and usage',
                        'Develop reading and writing skills',
                        'Build confidence in English communication'
                    ]).map(objective => `
                        <li class="flex items-start space-x-2">
                            <svg class="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                            </svg>
                            <span class="text-gray-600">${objective}</span>
                        </li>
                    `).join('')}
                </ul>
            </div>
            
            ${isStarted ? `
                <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <div class="flex items-start space-x-3">
                        <svg class="w-6 h-6 text-blue-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <div>
                            <h5 class="font-medium text-blue-900 mb-1">${isCompleted ? 'Lesson Completed!' : 'Lesson In Progress'}</h5>
                            <p class="text-sm text-blue-700">
                                ${isCompleted ? 
                                    'You have successfully completed this lesson. You can review it anytime.' : 
                                    'You have started this lesson. Continue where you left off.'
                                }
                            </p>
                        </div>
                    </div>
                </div>
            ` : ''}
        </div>
    `;
    
    // Update button text
    startLessonBtn.textContent = isCompleted ? 'Review Lesson' : isStarted ? 'Continue Lesson' : 'Start Lesson';
    
    // Show modal
    lessonModal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function closeLessonModal() {
    lessonModal.classList.add('hidden');
    document.body.style.overflow = '';
    selectedLesson = null;
}

// Lesson Actions
function startSelectedLesson() {
    if (selectedLesson) {
        startLesson(selectedLesson.lesson_id);
    }
}

function previewSelectedLesson() {
    if (selectedLesson) {
        // For now, just start the lesson - preview functionality can be added later
        startLesson(selectedLesson.lesson_id);
    }
}

function startLesson(lessonId) {
    window.location.href = `../pages/quiz.html?lesson=${lessonId}`;
}

function reviewLesson(lessonId) {
    // Could redirect to a review page or start lesson again
    startLesson(lessonId);
}

// Clear Filters
function clearFilters() {
    searchInput.value = '';
    statusFilter.value = 'all';
    difficultyFilter.value = 'all';
    sortBy.value = 'order';
    filterLessons();
}

// Show/Hide States
function showEmptyState() {
    lessonsGrid.classList.add('hidden');
    emptyState.classList.remove('hidden');
    
    // Update empty message based on filters
    const hasFilters = searchInput.value || statusFilter.value !== 'all' || difficultyFilter.value !== 'all';
    emptyMessage.textContent = hasFilters ? 
        'No lessons match your current filters.' : 
        'No lessons available for this level yet.';
}

function hideEmptyState() {
    lessonsGrid.classList.remove('hidden');
    emptyState.classList.add('hidden');
}

// Utility Functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

function getAuthToken() {
    return localStorage.getItem('authToken');
}

// UI State Functions
function showLoading() {
    loadingState.classList.remove('hidden');
    lessonsContent.classList.add('hidden');
    errorState.classList.add('hidden');
}

function showLessons() {
    loadingState.classList.add('hidden');
    lessonsContent.classList.remove('hidden');
    errorState.classList.add('hidden');
}

function showError() {
    loadingState.classList.add('hidden');
    lessonsContent.classList.add('hidden');
    errorState.classList.remove('hidden');
}