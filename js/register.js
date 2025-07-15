// WORDIAMO Registration Page JavaScript

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:5000'; // Backend server URL

// DOM Elements
const registerForm = document.getElementById('registerForm');
const usernameInput = document.getElementById('username');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const confirmPasswordInput = document.getElementById('confirmPassword');
const agreeTermsCheckbox = document.getElementById('agreeTerms');
const togglePasswordBtn = document.getElementById('togglePassword');
const toggleConfirmPasswordBtn = document.getElementById('toggleConfirmPassword');
const registerBtn = document.getElementById('registerBtn');
const registerLoading = document.getElementById('registerLoading');
const btnText = document.querySelector('.btn-text');
const formError = document.getElementById('formError');
const formSuccess = document.getElementById('formSuccess');

// Password strength elements
const strengthBars = [
    document.getElementById('strength1'),
    document.getElementById('strength2'),
    document.getElementById('strength3'),
    document.getElementById('strength4')
];
const strengthText = document.getElementById('strengthText');

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Check if user is already logged in
    if (isLoggedIn()) {
        window.location.href = '../pages/dashboard.html';
        return;
    }

    // Set up event listeners
    setupEventListeners();
    
    // Focus on username input
    usernameInput.focus();
});

// Event Listeners Setup
function setupEventListeners() {
    // Form submission
    registerForm.addEventListener('submit', handleRegistration);
    
    // Password toggles
    togglePasswordBtn.addEventListener('click', () => togglePasswordVisibility('password'));
    toggleConfirmPasswordBtn.addEventListener('click', () => togglePasswordVisibility('confirmPassword'));
    
    // Real-time validation
    usernameInput.addEventListener('blur', validateUsername);
    emailInput.addEventListener('blur', validateEmail);
    passwordInput.addEventListener('input', handlePasswordInput);
    passwordInput.addEventListener('blur', validatePassword);
    confirmPasswordInput.addEventListener('blur', validateConfirmPassword);
    
    // Clear errors on input
    usernameInput.addEventListener('input', clearFieldError);
    emailInput.addEventListener('input', clearFieldError);
    passwordInput.addEventListener('input', clearFieldError);
    confirmPasswordInput.addEventListener('input', clearFieldError);
}

// Handle Registration Form Submission
async function handleRegistration(event) {
    event.preventDefault();
    
    // Get form data
    const formData = new FormData(registerForm);
    const userData = {
        username: formData.get('username').trim(),
        email: formData.get('email').trim(),
        password: formData.get('password'),
        confirmPassword: formData.get('confirmPassword'),
    };
    
    // Validate form
    if (!validateForm(userData)) {
        return;
    }
    
    // Show loading state
    setLoadingState(true);
    hideMessages();
    
    try {
        // Make API call to backend
        const response = await fetch(`${API_BASE_URL}/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                username: userData.username,
                email: userData.email,
                password: userData.password
            })
        });
        
        const data = await response.json();
        
        if (response.ok && data.success) {
            // Registration successful
            handleRegistrationSuccess(data);
        } else {
            // Registration failed
            handleRegistrationError(data.error || 'Registration failed. Please try again.');
        }
        
    } catch (error) {
        console.error('Registration error:', error);
        handleRegistrationError('Network error. Please check your connection and try again.');
    } finally {
        setLoadingState(false);
    }
}

// Handle successful registration
function handleRegistrationSuccess(data) {
    // Show success message
    showSuccessMessage('Account created successfully! Redirecting to login...');
    
    // Reset form
    registerForm.reset();
    resetPasswordStrength();
    
    // Redirect to login after short delay
    setTimeout(() => {
        window.location.href = '../pages/login.html';
    }, 2000);
}

// Handle registration error
function handleRegistrationError(errorMessage) {
    showErrorMessage(errorMessage);
}

// Form Validation
function validateForm(userData) {
    let isValid = true;
    
    // Validate username
    if (!validateUsername()) isValid = false;
    
    // Validate email
    if (!validateEmail()) isValid = false;
    
    // Validate password
    if (!validatePassword()) isValid = false;
    
    // Validate confirm password
    if (!validateConfirmPassword()) isValid = false;
    
    
    return isValid;
}

// Username validation
function validateUsername() {
    const username = usernameInput.value.trim();
    
    if (!username) {
        showFieldError('usernameError', 'Username is required');
        return false;
    }
    
    if (username.length < 3) {
        showFieldError('usernameError', 'Username must be at least 3 characters');
        return false;
    }
    
    if (username.length > 20) {
        showFieldError('usernameError', 'Username must be less than 20 characters');
        return false;
    }
    
    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
        showFieldError('usernameError', 'Username can only contain letters, numbers, and underscores');
        return false;
    }
    
    hideFieldError('usernameError');
    return true;
}

// Email validation
function validateEmail() {
    const email = emailInput.value.trim();
    
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

// Password validation with strength checking
function validatePassword() {
    const password = passwordInput.value;
    
    if (!password) {
        showFieldError('passwordError', 'Password is required');
        return false;
    }
    
    if (password.length < 8) {
        showFieldError('passwordError', 'Password must be at least 8 characters');
        return false;
    }
    
    const strength = calculatePasswordStrength(password);
    if (strength < 3) {
        showFieldError('passwordError', 'Password is too weak. Please use a stronger password.');
        return false;
    }
    
    hideFieldError('passwordError');
    return true;
}

// Confirm password validation
function validateConfirmPassword() {
    const password = passwordInput.value;
    const confirmPassword = confirmPasswordInput.value;
    
    if (!confirmPassword) {
        showFieldError('confirmPasswordError', 'Please confirm your password');
        return false;
    }
    
    if (password !== confirmPassword) {
        showFieldError('confirmPasswordError', 'Passwords do not match');
        return false;
    }
    
    hideFieldError('confirmPasswordError');
    return true;
}


// Password strength calculation
function calculatePasswordStrength(password) {
    let strength = 0;
    
    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    
    // Character variety checks
    if (/[a-z]/.test(password)) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^a-zA-Z0-9]/.test(password)) strength++;
    
    return Math.min(strength, 4);
}

// Update password strength indicator
function updatePasswordStrength(strength) {
    const colors = ['bg-red-400', 'bg-orange-400', 'bg-yellow-400', 'bg-green-400'];
    const texts = ['Very Weak', 'Weak', 'Fair', 'Strong'];
    
    // Reset all bars
    strengthBars.forEach(bar => {
        bar.className = 'h-1 w-1/4 rounded-full bg-gray-200';
    });
    
    // Fill bars based on strength
    for (let i = 0; i < strength; i++) {
        strengthBars[i].className = `h-1 w-1/4 rounded-full ${colors[Math.min(strength - 1, 3)]}`;
    }
    
    // Update text
    if (strength === 0) {
        strengthText.textContent = 'Password strength';
        strengthText.className = 'text-xs text-gray-500 mt-1';
    } else {
        strengthText.textContent = texts[Math.min(strength - 1, 3)];
        strengthText.className = `text-xs mt-1 ${strength <= 2 ? 'text-orange-600' : 'text-green-600'}`;
    }
}

// Reset password strength indicator
function resetPasswordStrength() {
    strengthBars.forEach(bar => {
        bar.className = 'h-1 w-1/4 rounded-full bg-gray-200';
    });
    strengthText.textContent = 'Password strength';
    strengthText.className = 'text-xs text-gray-500 mt-1';
}

// Handle password input
function handlePasswordInput() {
    const password = passwordInput.value;
    const strength = calculatePasswordStrength(password);
    updatePasswordStrength(strength);
    
    // Clear error if password becomes valid
    if (password.length >= 8 && strength >= 3) {
        hideFieldError('passwordError');
    }
}

// Utility Functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

function togglePasswordVisibility(fieldId) {
    const input = document.getElementById(fieldId);
    const button = document.getElementById(`toggle${fieldId.charAt(0).toUpperCase() + fieldId.slice(1)}`);
    
    const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
    input.setAttribute('type', type);
    
    // Toggle icon
    button.textContent = type === 'password' ? '👁️' : '🙈';
}

function setLoadingState(loading) {
    if (loading) {
        registerBtn.disabled = true;
        btnText.classList.add('hidden');
        registerLoading.classList.remove('hidden');
        registerLoading.classList.add('flex');
    } else {
        registerBtn.disabled = false;
        btnText.classList.remove('hidden');
        registerLoading.classList.add('hidden');
        registerLoading.classList.remove('flex');
    }
}

// Message Functions
function showErrorMessage(message) {
    formError.textContent = message;
    formError.classList.remove('hidden');
    formSuccess.classList.add('hidden');
    formError.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function showSuccessMessage(message) {
    formSuccess.textContent = message;
    formSuccess.classList.remove('hidden');
    formError.classList.add('hidden');
    formSuccess.scrollIntoView({ behavior: 'smooth', block: 'center' });
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