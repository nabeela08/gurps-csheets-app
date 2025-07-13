// WORDIAMO Dashboard Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const loadingState = document.getElementById('loadingState');
const dashboardContent = document.getElementById('dashboardContent');
const errorState = document.getElementById('errorState');
const welcomeMessage = document.getElementById('welcomeMessage');
const dashboardTitle = document.getElementById('dashboardTitle');
const userAvatar = document.getElementById('userAvatar');
const userMenuBtn = document.getElementById('userMenuBtn');
const userMenu = document.getElementById('userMenu');
const logoutBtn = document.getElementById('logoutBtn');

// Progress elements
const currentLevel = document.getElementById('currentLevel');
const completedLessons = document.getElementById('completedLessons');
const averageScore = document.getElementById('averageScore');

// Content containers
const levelsContainer = document.getElementById('levelsContainer');
const recentActivity = document.getElementById('recentActivity');

// User data
let userData = null;
let authToken = null;

// Initialize dashboard
document.addEventListener('DOMContentLoaded', function() {
    // Check authentication
    if (!isLoggedIn()) {
        window.location.href = '../pages/login.html';
        return;
    }

    // Get user data
    userData = getUserData();
    authToken = getAuthToken();

    // Set up event listeners
    setupEventListeners();

    // Load dashboard data
    loadDashboard();
});

// Event Listeners Setup
function setupEventListeners() {
    // User menu toggle
    userMenuBtn.addEventListener('click', toggleUserMenu);
    
    // Logout button
    logoutBtn.addEventListener('click', handleLogout);
    
    // Close menu when clicking outside
    document.addEventListener('click', function(event) {
        if (!userMenuBtn.contains(event.target) && !userMenu.contains(event.target)) {
            userMenu.classList.add('hidden');
        }
    });
}

// Load Dashboard Data
async function loadDashboard() {
    try {
        showLoading();
        
        // Initialize user info
        initializeUserInfo();
        
        // Load data in parallel
        const [levelsData, progressData, activityData] = await Promise.all([
            fetchLevels(),
            fetchUserProgress(),
            fetchRecentActivity()
        ]);
        
        // Update dashboard with data
        updateProgressStats(progressData);
        renderLevels(levelsData);
        renderRecentActivity(activityData);
        
        showDashboard();
        
    } catch (error) {
        console.error('Dashboard loading error:', error);
        showError('Failed to load dashboard data. Please try again.');
    }
}

// Initialize User Info
function initializeUserInfo() {
    if (userData) {
        // Update welcome message
        welcomeMessage.textContent = `Welcome, ${userData.username}!`;
        dashboardTitle.textContent = `Welcome back, ${userData.username}!`;
        
        // Update user avatar
        userAvatar.textContent = userData.username.charAt(0).toUpperCase();
    }
}

// Fetch API Data Functions
async function fetchLevels() {
    const response = await fetch(`${API_BASE_URL}/levels`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch levels');
    }
    
    const data = await response.json();
    return data.levels || [];
}

async function fetchUserProgress() {
    const response = await fetch(`${API_BASE_URL}/user/progress`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch user progress');
    }
    
    return await response.json();
}

async function fetchRecentActivity() {
    const response = await fetch(`${API_BASE_URL}/user/scores?limit=5`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch recent activity');
    }
    
    const data = await response.json();
    return data.quiz_history || [];
}

// Update Progress Statistics
function updateProgressStats(progressData) {
    if (progressData && progressData.user) {
        // Current level
        const levelName = progressData.progress?.current_level || 'Beginner';
        currentLevel.textContent = levelName;
        
        // Completed lessons (mock data for now)
        const completed = progressData.progress?.completed_lessons || 0;
        completedLessons.textContent = completed;
        
        // Average score (mock data for now)
        const avgScore = progressData.progress?.average_score || '0%';
        averageScore.textContent = avgScore;
    } else {
        // Default values
        currentLevel.textContent = 'Beginner';
        completedLessons.textContent = '0';
        averageScore.textContent = '0%';
    }
}

// Render Learning Levels
function renderLevels(levels) {
    if (!levels || levels.length === 0) {
        levelsContainer.innerHTML = `
            <div class="col-span-full text-center py-8">
                <p class="text-gray-500">No levels available at the moment.</p>
            </div>
        `;
        return;
    }
    
    levelsContainer.innerHTML = levels.map(level => `
        <div class="bg-gradient-to-br from-primary/5 to-secondary/5 rounded-lg p-6 border border-gray-200 hover:shadow-md transition-shadow cursor-pointer" onclick="viewLevel(${level.level_id})">
            <div class="flex items-center justify-between mb-4">
                <h4 class="text-lg font-semibold text-gray-900">${level.level_name}</h4>
                <span class="bg-primary/10 text-primary px-2 py-1 rounded-full text-xs font-medium">
                    ${level.lesson_count} lessons
                </span>
            </div>
            <p class="text-gray-600 text-sm mb-4">${level.level_description}</p>
            <button class="w-full bg-primary text-white py-2 px-4 rounded-lg hover:bg-primary/90 transition-colors text-sm font-medium">
                ${getUserCurrentLevel() >= level.level_id ? 'Continue Learning' : 'Start Level'}
            </button>
        </div>
    `).join('');
}

// Render Recent Activity
function renderRecentActivity(activities) {
    if (!activities || activities.length === 0) {
        recentActivity.innerHTML = `
            <div class="text-center py-8">
                <p class="text-gray-500">No recent activity yet. Start learning to see your progress here!</p>
                <button onclick="startLearning()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary/90 transition-colors">
                    Start Learning
                </button>
            </div>
        `;
        return;
    }
    
    recentActivity.innerHTML = activities.map(activity => `
        <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                    <svg class="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"></path>
                    </svg>
                </div>
                <div>
                    <p class="font-medium text-gray-900">${activity.lesson_name || 'Quiz Completed'}</p>
                    <p class="text-sm text-gray-500">${activity.level_name || 'Practice'}</p>
                </div>
            </div>
            <div class="text-right">
                <p class="font-semibold text-gray-900">${activity.score_percentage}%</p>
                <p class="text-xs text-gray-500">${formatDate(activity.attempted_at)}</p>
            </div>
        </div>
    `).join('');
}

// Navigation Functions
function viewLevel(levelId) {
    window.location.href = `../pages/lessons.html?level=${levelId}`;
}

function startLearning() {
    window.location.href = `../pages/lessons.html?level=1`;
}

// Utility Functions
function getUserCurrentLevel() {
    return userData?.current_level_id || 1;
}

function formatDate(dateString) {
    if (!dateString) return 'Recently';
    
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 0) return 'Today';
    if (diffDays === 1) return 'Yesterday';
    if (diffDays < 7) return `${diffDays} days ago`;
    
    return date.toLocaleDateString();
}

function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

function getUserData() {
    const userData = localStorage.getItem('userData');
    return userData ? JSON.parse(userData) : null;
}

function getAuthToken() {
    return localStorage.getItem('authToken');
}

// UI State Functions
function showLoading() {
    loadingState.classList.remove('hidden');
    dashboardContent.classList.add('hidden');
    errorState.classList.add('hidden');
}

function showDashboard() {
    loadingState.classList.add('hidden');
    dashboardContent.classList.remove('hidden');
    errorState.classList.add('hidden');
}

function showError(message) {
    loadingState.classList.add('hidden');
    dashboardContent.classList.add('hidden');
    errorState.classList.remove('hidden');
    
    const errorMessage = document.getElementById('errorMessage');
    if (errorMessage) {
        errorMessage.textContent = message;
    }
}

// User Menu Functions
function toggleUserMenu() {
    userMenu.classList.toggle('hidden');
}

async function handleLogout() {
    try {
        // Call logout API
        await fetch(`${API_BASE_URL}/auth/logout`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
    } catch (error) {
        console.error('Logout API error:', error);
        // Continue with logout even if API fails
    }
    
    // Clear local storage
    localStorage.removeItem('authToken');
    localStorage.removeItem('userData');
    
    // Redirect to login
    window.location.href = '../pages/login.html';
}