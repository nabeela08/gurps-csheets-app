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
const totalQuizzes = document.getElementById('totalQuizzes');
const averageScore = document.getElementById('averageScore');
const currentStreak = document.getElementById('currentStreak');

// Tab elements
const tabButtons = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-content');

// Form elements
const personalInfoForm = document.getElementById('personalInfoForm');
const preferencesForm = document.getElementById('preferencesForm');
const securityForm = document.getElementById('securityForm');
const changePasswordBtn = document.getElementById('changePasswordBtn');
const deleteAccountBtn = document.getElementById('deleteAccountBtn');

// Progress elements
const vocabProgress = document.getElementById('vocabProgress');
const vocabBar = document.getElementById('vocabBar');
const grammarProgress = document.getElementById('grammarProgress');
const grammarBar = document.getElementById('grammarBar');
const speakingProgress = document.getElementById('speakingProgress');
const speakingBar = document.getElementById('speakingBar');
const recentActivities = document.getElementById('recentActivities');
const achievementsGrid = document.getElementById('achievementsGrid');

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
    [personalInfoForm, preferencesForm].forEach(form => {
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
    deleteAccountBtn.addEventListener('click', confirmDeleteAccount);
    
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
        populatePreferences(profileData.preferences || {});
        updateProgressStats(progressData);
        renderRecentActivities(activityData);
        renderAchievements(progressData.achievements || []);
        
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
    if (profileData && profileData.user) {
        const user = profileData.user;
        
        // Update avatar
        userAvatar.textContent = user.username ? user.username.charAt(0).toUpperCase() : 'U';
        
        // Update user info
        userName.textContent = user.username || 'User';
        userEmail.textContent = user.email || '';
        
        // Update quick stats (mock data for now)
        totalQuizzes.textContent = profileData.stats?.total_quizzes || '0';
        averageScore.textContent = `${profileData.stats?.average_score || 0}%`;
        currentStreak.textContent = profileData.stats?.current_streak || '0';
    }
}

// Populate Personal Information Form
function populatePersonalInfo(profileData) {
    if (profileData && profileData.user) {
        const user = profileData.user;
        
        document.getElementById('username').value = user.username || '';
        document.getElementById('email').value = user.email || '';
        document.getElementById('currentLevel').value = user.current_level || 'beginner';
        document.getElementById('bio').value = user.bio || '';
    }
}

// Populate Preferences Form
function populatePreferences(preferences) {
    // Learning goals
    const goals = preferences.learning_goals || [];
    document.querySelectorAll('input[name="goals"]').forEach(checkbox => {
        checkbox.checked = goals.includes(checkbox.value);
    });
    
    // Study preferences
    document.getElementById('studyTime').value = preferences.study_time || 'morning';
    document.getElementById('dailyGoal').value = preferences.daily_goal || '30';
    
    // Notifications
    const notifications = preferences.notifications || [];
    document.querySelectorAll('input[name="notifications"]').forEach(checkbox => {
        checkbox.checked = notifications.includes(checkbox.value);
    });
}

// Update Progress Statistics
function updateProgressStats(progressData) {
    // Mock progress data for demonstration
    const progress = progressData.progress || {};
    
    // Vocabulary progress
    const vocabPercent = progress.vocabulary_progress || 0;
    vocabProgress.textContent = `${vocabPercent}%`;
    vocabBar.style.width = `${vocabPercent}%`;
    
    // Grammar progress
    const grammarPercent = progress.grammar_progress || 0;
    grammarProgress.textContent = `${grammarPercent}%`;
    grammarBar.style.width = `${grammarPercent}%`;
    
    // Speaking progress
    const speakingPercent = progress.speaking_progress || 0;
    speakingProgress.textContent = `${speakingPercent}%`;
    speakingBar.style.width = `${speakingPercent}%`;
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

// Render Achievements
function renderAchievements(achievements) {
    const defaultAchievements = [
        { id: 'first_quiz', name: 'First Quiz', description: 'Complete your first quiz', icon: '🎯', earned: false },
        { id: 'perfect_score', name: 'Perfect Score', description: 'Score 100% on a quiz', icon: '⭐', earned: false },
        { id: 'week_streak', name: 'Week Streak', description: 'Study for 7 days in a row', icon: '🔥', earned: false },
        { id: 'grammar_master', name: 'Grammar Master', description: 'Ace 10 grammar quizzes', icon: '📚', earned: false },
        { id: 'vocabulary_expert', name: 'Vocabulary Expert', description: 'Learn 100 new words', icon: '💡', earned: false },
        { id: 'quick_learner', name: 'Quick Learner', description: 'Complete a quiz in under 5 minutes', icon: '⚡', earned: false },
        { id: 'dedicated_student', name: 'Dedicated Student', description: 'Study for 30 days', icon: '🏆', earned: false },
        { id: 'night_owl', name: 'Night Owl', description: 'Study after midnight', icon: '🦉', earned: false }
    ];
    
    achievementsGrid.innerHTML = defaultAchievements.map(achievement => `
        <div class="text-center p-4 rounded-lg border-2 ${achievement.earned ? 'border-yellow-300 bg-yellow-50' : 'border-gray-200 bg-gray-50'}">
            <div class="text-2xl mb-2 ${achievement.earned ? '' : 'grayscale opacity-50'}">${achievement.icon}</div>
            <h4 class="font-medium text-sm text-gray-900 mb-1">${achievement.name}</h4>
            <p class="text-xs text-gray-600">${achievement.description}</p>
            ${achievement.earned ? '<span class="inline-block mt-2 px-2 py-1 bg-yellow-200 text-yellow-800 text-xs rounded-full">Earned</span>' : ''}
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
        const preferencesData = new FormData(preferencesForm);
        
        // Convert FormData to objects
        const personalInfo = Object.fromEntries(personalData);
        
        // Handle preferences with multiple values
        const preferences = {
            learning_goals: Array.from(preferencesForm.querySelectorAll('input[name="goals"]:checked')).map(cb => cb.value),
            study_time: preferencesData.get('studyTime'),
            daily_goal: preferencesData.get('dailyGoal'),
            notifications: Array.from(preferencesForm.querySelectorAll('input[name="notifications"]:checked')).map(cb => cb.value)
        };
        
        // Combine data
        const profileUpdate = {
            ...personalInfo,
            preferences: preferences
        };
        
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

// Confirm Delete Account
function confirmDeleteAccount() {
    if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
        if (confirm('This will permanently delete all your progress and data. Are you absolutely sure?')) {
            deleteAccount();
        }
    }
}

// Delete Account
async function deleteAccount() {
    try {
        const response = await fetch(`${API_BASE_URL}/user/account`, {
            method: 'DELETE',
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        
        if (!response.ok) {
            throw new Error('Failed to delete account');
        }
        
        // Clear local storage
        localStorage.clear();
        
        // Redirect to login with message
        alert('Your account has been deleted successfully.');
        window.location.href = '../pages/login.html';
        
    } catch (error) {
        console.error('Error deleting account:', error);
        showMessage('Failed to delete account. Please try again.', 'error');
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