// WORDIAMO Login Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const loginForm = document.getElementById('loginForm');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const togglePasswordBtn = document.getElementById('togglePassword');
const loginBtn = document.getElementById('loginBtn');
const loginLoading = document.getElementById('loginLoading');
const btnText = document.querySelector('.btn-text');
const formError = document.getElementById('formError');
const formSuccess = document.getElementById('formSuccess');

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is already logged in
    if (isLoggedIn()) {
        window.location.href = '../pages/dashboard.html';
        return;
    }

    // Set up event listeners
    setupEventListeners();
    
    // Focus on email input
    emailInput.focus();
});

// Event Listeners Setup
function setupEventListeners() {
    // Form submission
    loginForm.addEventListener('submit', handleLogin);
    
    // Password toggle
    togglePasswordBtn.addEventListener('click', togglePasswordVisibility);
    
    // Real-time validation
    emailInput.addEventListener('blur', validateEmail);
    passwordInput.addEventListener('blur', validatePassword);
    
    // Clear errors on input
    emailInput.addEventListener('input', clearFieldError);
    passwordInput.addEventListener('input', clearFieldError);
}

// Handle Login Form Submission
async function handleLogin(event) {
    event.preventDefault();
    
    // Get form data
    const formData = new FormData(loginForm);
    const email = formData.get('email').trim();
    const password = formData.get('password');
    
    // Validate form
    if (!validateForm(email, password)) {
        return;
    }
    
    // Show loading state
    setLoadingState(true);
    hideMessages();
    
    try {
        // Make API call to backend
        const response = await fetch(`${API_BASE_URL}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: email,
                password: password
            })
        });
        
        const data = await response.json();
        
        if (response.ok && data.success) {
            // Login successful
            handleLoginSuccess(data);
        } else {
            // Login failed
            handleLoginError(data.error || 'Login failed. Please try again.');
        }
        
    } catch (error) {
        console.error('Login error:', error);
        handleLoginError('Network error. Please check your connection and try again.');
    } finally {
        setLoadingState(false);
    }
}

// Handle successful login
function handleLoginSuccess(data) {
    // Store 
    //  data and token
    if (data.token) {
        localStorage.setItem('authToken', data.token);
    }
    
    if (data.user) {
        localStorage.setItem('userData', JSON.stringify(data.user));
    }
    
    // Show success message
    showSuccessMessage('Login successful! Redirecting...');
    
    // Redirect to dashboard after short delay
    setTimeout(() => {
        window.location.href = '../pages/dashboard.html';
    }, 1500);
}

// Handle login error
function handleLoginError(errorMessage) {
    showErrorMessage(errorMessage);
}

// Form Validation
function validateForm(email, password) {
    let isValid = true;
    
    // Validate email
    if (!validateEmail()) {
        isValid = false;
    }
    
    // Validate password
    if (!validatePassword()) {
        isValid = false;
    }
    
    return isValid;
}

// Email validation
function validateEmail() {
    const email = emailInput.value.trim();
    const emailError = document.getElementById('emailError');
    
    if (!email) {
        showFieldError('emailError', 'Email is required');
        return false;
    }
    
    if (!isValidEmail(email)) {
        showFieldError('emailError', 'Please enter a valid email address');
        return false;
    }
    
    hideFieldError('emailError');
    return true;
}

// Password validation
function validatePassword() {
    const password = passwordInput.value;
    const passwordError = document.getElementById('passwordError');
    
    if (!password) {
        showFieldError('passwordError', 'Password is required');
        return false;
    }
    
    if (password.length < 6) {
        showFieldError('passwordError', 'Password must be at least 6 characters');
        return false;
    }
    
    hideFieldError('passwordError');
    return true;
}

// Utility Functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

function togglePasswordVisibility() {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    
    // Toggle icon
    togglePasswordBtn.textContent = type === 'password' ? '👁️' : '🙈';
}

function setLoadingState(loading) {
    if (loading) {
        loginBtn.disabled = true;
        btnText.classList.add('hidden');
        loginLoading.classList.remove('hidden');
        loginLoading.classList.add('flex');
    } else {
        loginBtn.disabled = false;
        btnText.classList.remove('hidden');
        loginLoading.classList.add('hidden');
        loginLoading.classList.remove('flex');
    }
}

// Message Functions
function showErrorMessage(message) {
    formError.textContent = message;
    formError.classList.remove('hidden');
    formSuccess.classList.add('hidden');
}

function showSuccessMessage(message) {
    formSuccess.textContent = message;
    formSuccess.classList.remove('hidden');
    formError.classList.add('hidden');
}

function hideMessages() {
    formError.classList.add('hidden');
    formSuccess.classList.add('hidden');
}

function showFieldError(fieldId, message) {
    const errorElement = document.getElementById(fieldId);
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
        errorElement.classList.add('block');
    }
}

function hideFieldError(fieldId) {
    const errorElement = document.getElementById(fieldId);
    if (errorElement) {
        errorElement.classList.add('hidden');
        errorElement.classList.remove('block');
    }
}

function clearFieldError(event) {
    const fieldName = event.target.name;
    const errorId = fieldName + 'Error';
    hideFieldError(errorId);
    hideMessages();
}