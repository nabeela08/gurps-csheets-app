// WORDIAMO Profile Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const loadingState = document.getElementById('loadingState');
const profileContent = document.getElementById('profileContent');
const saveProfileBtn = document.getElementById('saveProfileBtn');
const messageContainer = document.getElementById('messageContainer');

// Profile elements
const userAvatar = document.getElementById('userAvatar');
const userName = document.getElementById('userName');
const userEmail = document.getElementById('userEmail');

// Tab elements
const tabButtons = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-content');

// Form elements
const personalInfoForm = document.getElementById('personalInfoForm');
const securityForm = document.getElementById('securityForm');
const changePasswordBtn = document.getElementById('changePasswordBtn');

// Progress elements
const overallPerformance = document.getElementById('overallPerformance');
const levelProgress = document.getElementById('levelProgress');
const completedLessons = document.getElementById('completedLessons');
const totalLessonsText = document.getElementById('totalLessonsText');
const recentActivities = document.getElementById('recentActivities');

// User data
let userData = null;
let authToken = null;
let hasUnsavedChanges = false;

// Initialize profile page
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
    
    // Load profile data
    loadProfile();
});

// Event Listeners Setup
function setupEventListeners() {
    // Tab navigation
    tabButtons.forEach(button => {
        button.addEventListener('click', () => switchTab(button.dataset.tab));
    });
    
    // Save profile button
    saveProfileBtn.addEventListener('click', saveProfile);
    
    // Form change detection
    [personalInfoForm].forEach(form => {
        form.addEventListener('input', () => {
            hasUnsavedChanges = true;
            showSaveButton();
        });
        form.addEventListener('change', () => {
            hasUnsavedChanges = true;
            showSaveButton();
        });
    });
    
    // Security actions
    changePasswordBtn.addEventListener('click', changePassword);
    
    // Prevent accidental navigation
    window.addEventListener('beforeunload', function(e) {
        if (hasUnsavedChanges) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
}

// Load Profile Data
async function loadProfile() {
    try {
        showLoading();
        
        // Load data in parallel
        const [profileData, progressData, activityData] = await Promise.all([
            fetchUserProfile(),
            fetchUserProgress(),
            fetchRecentActivity()
        ]);
        
        // Update profile display
        updateProfileHeader(profileData);
        populatePersonalInfo(profileData);
        updateProgressStats(progressData);
        renderRecentActivities(activityData);
        
        showProfile();
        
    } catch (error) {
        console.error('Error loading profile:', error);
        showMessage('Failed to load profile data', 'error');
    }
}

// Fetch User Profile
async function fetchUserProfile() {
    const response = await fetch(`${API_BASE_URL}/user/profile`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch profile');
    }
    
    return await response.json();
}

// Fetch User Progress
async function fetchUserProgress() {
    const response = await fetch(`${API_BASE_URL}/user/progress`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch progress');
    }
    
    return await response.json();
}

// Fetch Recent Activity
async function fetchRecentActivity() {
    const response = await fetch(`${API_BASE_URL}/user/scores?limit=5`, {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (!response.ok) {
        throw new Error('Failed to fetch activity');
    }
    
    const data = await response.json();
    return data.quiz_history || [];
}

// Update Profile Header
function updateProfileHeader(profileData) {
    if (profileData && profileData.profile) {
        const user = profileData.profile;
        
        // Update avatar
        userAvatar.textContent = user.username ? user.username.charAt(0).toUpperCase() : 'U';
        
        // Update user info
        userName.textContent = user.username || 'User';
        userEmail.textContent = user.email || '';
        
        // Quick stats will be updated by updateProgressStats function
    }
}

// Populate Personal Information Form
function populatePersonalInfo(profileData) {
    if (profileData && profileData.profile) {
        const user = profileData.profile;
        
        document.getElementById('username').value = user.username || '';
        document.getElementById('email').textContent = user.email || '';
        document.getElementById('currentLevel').textContent = user.current_level_name || 'Beginner';
    }
}


// Update Progress Statistics
function updateProgressStats(progressData) {
    if (progressData) {
        // Get completed lessons data
        const completedLessonsData = progressData.completed_lessons || [];
        const levelProgressData = progressData.level_progress || {};
        
        // 1. Overall Performance (Average Score)
        const progress = progressData.progress || {};
        const averageScoreValue = progress.average_score ? Math.round(progress.average_score) : 0;
        overallPerformance.textContent = `${averageScoreValue}%`;
        
        // 2. Level Progress (Current Level Completion)
        const currentLevelId = progressData.user?.current_level_id || 1;
        const currentLevelProgress = levelProgressData[currentLevelId] || {};
        const levelCompletionPercent = Math.round(currentLevelProgress.completion_percentage || 0);
        levelProgress.textContent = `${levelCompletionPercent}%`;
        
        // 3. Lessons Completed  
        const completedCount = progress.completed_lessons || completedLessonsData.length || 0;
        completedLessons.textContent = completedCount.toString();
        
        // Calculate total lessons (estimate from level progress data)
        let totalLessonsCount = 0;
        Object.values(levelProgressData).forEach(level => {
            totalLessonsCount += level.total_lessons || 0;
        });
        
        if (totalLessonsCount === 0) {
            // Fallback: estimate total lessons (3 levels × ~10 lessons each)
            totalLessonsCount = 30;
        }
        
        totalLessonsText.textContent = `out of ${totalLessonsCount} total`;
        
    } else {
        // Fallback values
        overallPerformance.textContent = '0%';
        levelProgress.textContent = '0%';
        completedLessons.textContent = '0';
        totalLessonsText.textContent = 'out of 0 total';
    }
}

// Render Recent Activities
function renderRecentActivities(activities) {
    if (!activities || activities.length === 0) {
        recentActivities.innerHTML = `
            <div class="text-center py-4">
                <p class="text-gray-500 text-sm">No recent activity</p>
            </div>
        `;
        return;
    }
    
    recentActivities.innerHTML = activities.slice(0, 5).map(activity => `
        <div class="flex items-center justify-between text-sm">
            <div>
                <p class="font-medium text-gray-900">${activity.lesson_name || 'Quiz'}</p>
                <p class="text-gray-500">${formatDate(activity.attempted_at)}</p>
            </div>
            <span class="font-semibold ${activity.score_percentage >= 70 ? 'text-green-600' : 'text-yellow-600'}">
                ${activity.score_percentage}%
            </span>
        </div>
    `).join('');
}


// Tab Management
function switchTab(tabName) {
    // Update tab buttons
    tabButtons.forEach(btn => {
        if (btn.dataset.tab === tabName) {
            btn.classList.add('active', 'border-primary', 'text-primary');
            btn.classList.remove('border-transparent', 'text-gray-500');
        } else {
            btn.classList.remove('active', 'border-primary', 'text-primary');
            btn.classList.add('border-transparent', 'text-gray-500');
        }
    });
    
    // Update tab content
    tabContents.forEach(content => {
        if (content.id === `${tabName}Tab`) {
            content.classList.remove('hidden');
        } else {
            content.classList.add('hidden');
        }
    });
}

// Save Profile
async function saveProfile() {
    try {
        // Collect form data
        const personalData = new FormData(personalInfoForm);
        
        // Convert FormData to objects
        const personalInfo = Object.fromEntries(personalData);
        
        // Profile update data
        const profileUpdate = personalInfo;
        
        // Save to API
        const response = await fetch(`${API_BASE_URL}/user/profile`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify(profileUpdate)
        });
        
        if (!response.ok) {
            throw new Error('Failed to save profile');
        }
        
        // Update local storage
        const updatedUserData = { ...userData, ...personalInfo };
        localStorage.setItem('userData', JSON.stringify(updatedUserData));
        userData = updatedUserData;
        
        // Reset change tracking
        hasUnsavedChanges = false;
        hideSaveButton();
        
        // Show success message
        showMessage('Profile saved successfully!', 'success');
        
    } catch (error) {
        console.error('Error saving profile:', error);
        showMessage('Failed to save profile. Please try again.', 'error');
    }
}

// Change Password
async function changePassword() {
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Validation
    if (!currentPassword || !newPassword || !confirmPassword) {
        showMessage('Please fill in all password fields', 'error');
        return;
    }
    
    if (newPassword !== confirmPassword) {
        showMessage('New passwords do not match', 'error');
        return;
    }
    
    if (newPassword.length < 8) {
        showMessage('New password must be at least 8 characters long', 'error');
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE_URL}/user/change-password`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify({
                current_password: currentPassword,
                new_password: newPassword
            })
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || 'Failed to change password');
        }
        
        // Clear form
        document.getElementById('currentPassword').value = '';
        document.getElementById('newPassword').value = '';
        document.getElementById('confirmPassword').value = '';
        
        showMessage('Password changed successfully!', 'success');
        
    } catch (error) {
        console.error('Error changing password:', error);
        showMessage(error.message || 'Failed to change password', 'error');
    }
}


// Utility Functions
function showSaveButton() {
    saveProfileBtn.classList.remove('hidden');
}

function hideSaveButton() {
    saveProfileBtn.classList.add('hidden');
}

function showMessage(message, type = 'info') {
    const messageEl = document.createElement('div');
    messageEl.className = `p-4 rounded-lg shadow-lg max-w-sm ${
        type === 'success' ? 'bg-green-100 border border-green-200 text-green-700' :
        type === 'error' ? 'bg-red-100 border border-red-200 text-red-700' :
        'bg-blue-100 border border-blue-200 text-blue-700'
    }`;
    
    messageEl.innerHTML = `
        <div class="flex items-center justify-between">
            <span class="text-sm font-medium">${message}</span>
            <button onclick="this.parentElement.parentElement.remove()" class="ml-4 text-current opacity-70 hover:opacity-100">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
    `;
    
    messageContainer.appendChild(messageEl);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (messageEl.parentElement) {
            messageEl.remove();
        }
    }, 5000);
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
    profileContent.classList.add('hidden');
}

function showProfile() {
    loadingState.classList.add('hidden');
    profileContent.classList.remove('hidden');
}