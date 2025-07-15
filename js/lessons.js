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

// Content elements
const lessonsGrid = document.getElementById('lessonsGrid');
const emptyMessage = document.getElementById('emptyMessage');


// Global variables
let currentLevelId = null;
let allLessons = [];
let filteredLessons = [];
let userProgress = {};

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
    try {
        const response = await fetch(`${API_BASE_URL}/levels/${currentLevelId}`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch level info');
        }
        
        const data = await response.json();
        // Return the level object from the response
        return data.level || data;
    } catch (error) {
        console.error('Error fetching level info:', error);
        // Return fallback data
        return {
            level_name: 'Level',
            level_description: 'Learn English with this level',
            level_id: currentLevelId
        };
    }
}

// Fetch Lessons
async function fetchLessons() {
    try {
        const response = await fetch(`${API_BASE_URL}/levels/${currentLevelId}/lessons`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch lessons');
        }
        
        const data = await response.json();
        const lessons = data.lessons || [];
        
        // Add level_id to each lesson since the API doesn't include it
        lessons.forEach(lesson => {
            lesson.level_id = currentLevelId;
        });
        
        return lessons;
    } catch (error) {
        console.error('Error fetching lessons:', error);
        return [];
    }
}

// Fetch User Progress
async function fetchUserProgress() {
    try {
        const authToken = getAuthToken();
        if (!authToken) {
            // User not logged in, return empty progress
            return {
                success: true,
                progress: { completed_lessons: 0, total_quizzes: 0, average_score: 0 },
                recent_activity: []
            };
        }

        const response = await fetch(`${API_BASE_URL}/user/progress`, {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        
        if (!response.ok) {
            // If auth fails, return empty progress instead of throwing error
            return {
                success: true,
                progress: { completed_lessons: 0, total_quizzes: 0, average_score: 0 },
                recent_activity: []
            };
        }
        
        return await response.json();
    } catch (error) {
        // Return fallback data instead of throwing error
        return {
            success: true,
            progress: { completed_lessons: 0, total_quizzes: 0, average_score: 0 },
            recent_activity: []
        };
    }
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

// Calculate Completed Lessons for Current Level
function calculateCompletedLessons() {
    if (!userProgress || !userProgress.level_progress || !currentLevelId) return 0;
    
    // Get level-specific progress
    const levelProgress = userProgress.level_progress[currentLevelId];
    return levelProgress ? levelProgress.completed_lessons : 0;
}

// Helper Functions for Lesson Status
function getStatusBadge(isCompleted, canAccess) {
    if (isCompleted) {
        return `<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                    </svg>
                    Completed
                </span>`;
    }
    
    if (!canAccess) {
        return `<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-600">
                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path>
                    </svg>
                    Locked
                </span>`;
    }
    
    return `<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                </svg>
                Available
            </span>`;
}

function getCardClass(isCompleted, canAccess) {
    if (isCompleted) {
        return 'border-green-200 bg-green-50';
    }
    
    if (!canAccess) {
        return 'border-gray-200 bg-gray-50 opacity-75';
    }
    
    return 'border-blue-200 hover:border-blue-300';
}

// Filter and Sort Lessons
function filterLessons() {
    const searchTerm = searchInput.value.toLowerCase().trim();
    
    // Filter lessons
    filteredLessons = allLessons.filter(lesson => {
        // Search filter
        const matchesSearch = !searchTerm || 
            lesson.lesson_name.toLowerCase().includes(searchTerm) ||
            lesson.lesson_description.toLowerCase().includes(searchTerm);
        
        return matchesSearch;
    });
    
    // Sort lessons by order
    filteredLessons.sort((a, b) => {
        return (a.lesson_order || 0) - (b.lesson_order || 0);
    });
    
    // Render lessons
    renderLessons();
}


// Render Lessons Grid
function renderLessons() {
    if (filteredLessons.length === 0) {
        showEmptyState();
        return;
    }
    
    hideEmptyState();
    
    lessonsGrid.innerHTML = filteredLessons.map(lesson => {
        // Check if lesson is completed
        const isCompleted = userProgress?.completed_lessons?.includes(lesson.lesson_id) || false;
        
        // Check if user can access this lesson
        const currentUserLevel = userProgress?.user?.current_level_id || 16; // Default to Beginner level
        const canAccess = lesson.level_id <= currentUserLevel;
        
        // Debug logging
        if (lesson.lesson_name === 'Basic Greetings') {
            console.log('Debug - User Progress:', userProgress);
            console.log('Debug - Current User Level:', currentUserLevel);
            console.log('Debug - Lesson Level:', lesson.level_id);
            console.log('Debug - Can Access:', canAccess);
        }
        
        // Get status indicators
        const statusBadge = getStatusBadge(isCompleted, canAccess);
        const cardClass = getCardClass(isCompleted, canAccess);
        
        return `
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow lesson-card ${cardClass}" 
                 data-lesson-id="${lesson.lesson_id}"
                 data-can-access="${canAccess}"
                 data-is-completed="${isCompleted}">
                <!-- Lesson Header -->
                <div class="p-6 border-b border-gray-100">
                    <div class="flex items-start justify-between mb-3">
                        <div class="flex-1">
                            <div class="flex items-center space-x-2 mb-2">
                                <h3 class="text-lg font-semibold text-gray-900">${lesson.lesson_name}</h3>
                                ${statusBadge}
                            </div>
                            <p class="text-sm text-gray-600 line-clamp-2">${lesson.lesson_description || 'Learn new concepts and practice your skills'}</p>
                        </div>
                    </div>
                    
                    <!-- Lesson Meta -->
                    <div class="flex items-center space-x-4 text-xs text-gray-500">
                        <span class="flex items-center">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path>
                            </svg>
                            ${lesson.question_count || 10} questions
                        </span>
                    </div>
                </div>
                
                <!-- Action Section -->
                <div class="p-6">
                    <!-- Action Button -->
                    <button class="w-full py-2 px-4 rounded-lg font-medium text-sm transition-colors bg-primary text-white hover:bg-primary/90" onclick="startLesson(${lesson.lesson_id})">
                        Start Lesson
                    </button>
                </div>
            </div>
        `;
    }).join('');
}



async function startLesson(lessonId) {
    try {
        // Check lesson access before starting
        const accessCheck = await checkLessonAccess(lessonId);
        
        if (!accessCheck.access.can_access) {
            // Show access denied popup
            showAccessDeniedModal(accessCheck);
            return;
        }
        
        // If accessible, proceed to quiz
        window.location.href = `../pages/quiz.html?lesson=${lessonId}`;
        
    } catch (error) {
        console.error('Error checking lesson access:', error);
        // If check fails, still allow access (fallback)
        window.location.href = `../pages/quiz.html?lesson=${lessonId}`;
    }
}

async function checkLessonAccess(lessonId) {
    const response = await fetch(`${API_BASE_URL}/lesson/access-check/${lessonId}`, {
        headers: {
            'Authorization': `Bearer ${getAuthToken()}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to check lesson access');
    }
    
    return await response.json();
}

function showAccessDeniedModal(accessInfo) {
    // Create modal HTML
    const modalHTML = `
        <div id="accessDeniedModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-6 max-w-md mx-4 animate-scale-in">
                <!-- Lock Icon -->
                <div class="flex items-center justify-center w-16 h-16 bg-red-100 rounded-full mx-auto mb-4">
                    <svg class="w-8 h-8 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path>
                    </svg>
                </div>
                
                <!-- Content -->
                <div class="text-center">
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Lesson Locked</h3>
                    <p class="text-gray-600 mb-4">You need to complete lessons of your current level to unlock this content.</p>
                    
                    <!-- Actions -->
                    <div class="flex space-x-3">
                        <button onclick="goToCurrentLevel()" class="flex-1 bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary/90 transition-colors">
                            View Available Lessons
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Add modal to page
    document.body.insertAdjacentHTML('beforeend', modalHTML);
}

function closeAccessDeniedModal() {
    const modal = document.getElementById('accessDeniedModal');
    if (modal) {
        modal.remove();
    }
}

function goToCurrentLevel() {
    closeAccessDeniedModal();
    // Go to user's current level
    const currentUserLevel = userProgress?.user?.current_level_id || 16;
    window.location.href = `../pages/lessons.html?level=${currentUserLevel}`;
}



// Clear Filters
function clearFilters() {
    searchInput.value = '';
    filterLessons();
}

// Show/Hide States
function showEmptyState() {
    lessonsGrid.classList.add('hidden');
    emptyState.classList.remove('hidden');
    
    // Update empty message based on filters
    const hasFilters = searchInput.value;
    emptyMessage.textContent = hasFilters ? 
        'No lessons match your search.' : 
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