"""
Authentication system for WORDIAMO
Handles user registration, login, password hashing, and session management
"""

import bcrypt
import jwt
import os
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from functools import wraps
from flask import request, jsonify, session
from src.main.models import User

# Configuration
SECRET_KEY = os.getenv('SECRET_KEY', 'wordiamo_secret_key_2024')
TOKEN_EXPIRATION_HOURS = int(os.getenv('TOKEN_EXPIRATION_HOURS', 24))

def hash_password(password: str) -> str:
    """Hash password using bcrypt"""
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')

def verify_password(password: str, hashed_password: str) -> bool:
    """Verify password against hash"""
    return bcrypt.checkpw(password.encode('utf-8'), hashed_password.encode('utf-8'))

def generate_token(user_id: int, username: str) -> str:
    """Generate JWT token for user"""
    payload = {
        'user_id': user_id,
        'username': username,
        'exp': datetime.utcnow() + timedelta(hours=TOKEN_EXPIRATION_HOURS),
        'iat': datetime.utcnow()
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

def verify_token(token: str) -> Optional[Dict[str, Any]]:
    """Verify and decode JWT token"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

def register_user(username: str, email: str, password: str) -> Dict[str, Any]:
    """Register new user with validation"""
    # Validate input
    if not username or len(username) < 3:
        return {'success': False, 'message': 'Username must be at least 3 characters'}
    
    if not email or '@' not in email:
        return {'success': False, 'message': 'Valid email address required'}
    
    if not password or len(password) < 6:
        return {'success': False, 'message': 'Password must be at least 6 characters'}
    
    # Check if user already exists
    if User.by_username(username):
        return {'success': False, 'message': 'Username already exists'}
    
    if User.by_email(email):
        return {'success': False, 'message': 'Email already registered'}
    
    try:
        # Hash password and create user
        hashed_password = hash_password(password)
        user = User.create(username, email, hashed_password)
        
        # Generate token
        token = generate_token(user.user_id, user.username)
        
        return {
            'success': True,
            'message': 'User registered successfully',
            'user': {
                'user_id': user.user_id,
                'username': user.username,
                'email': user.email,
                'current_level_id': user.current_level_id
            },
            'token': token
        }
    except Exception as e:
        return {'success': False, 'message': f'Registration failed: {str(e)}'}

def login_user(identifier: str, password: str) -> Dict[str, Any]:
    """Login user with email/username and password"""
    if not identifier or not password:
        return {'success': False, 'message': 'Email/username and password required'}
    
    # Try to find user by email or username
    user = User.by_email(identifier) or User.by_username(identifier)
    
    if not user:
        return {'success': False, 'message': 'Invalid credentials'}
    
    # Verify password
    if not verify_password(password, user.password_hash):
        return {'success': False, 'message': 'Invalid credentials'}
    
    try:
        # Generate token
        token = generate_token(user.user_id, user.username)
        
        return {
            'success': True,
            'message': 'Login successful',
            'user': {
                'user_id': user.user_id,
                'username': user.username,
                'email': user.email,
                'current_level_id': user.current_level_id
            },
            'token': token
        }
    except Exception as e:
        return {'success': False, 'message': f'Login failed: {str(e)}'}

def logout_user(token: str) -> Dict[str, Any]:
    """Logout user (invalidate token - in production, use token blacklist)"""
    try:
        payload = verify_token(token)
        if payload:
            # In production, add token to blacklist
            return {'success': True, 'message': 'Logout successful'}
        else:
            return {'success': False, 'message': 'Invalid token'}
    except Exception as e:
        return {'success': False, 'message': f'Logout failed: {str(e)}'}

def current_user(token: str) -> Optional[User]:
    """Get current user from token"""
    payload = verify_token(token)
    if payload:
        return User.by_id(payload['user_id'])
    return None

def token_required(f):
    """Decorator to require valid token for API endpoints"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # Get token from header
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(" ")[1]  # Bearer <token>
            except IndexError:
                return jsonify({'message': 'Invalid token format'}), 401
        
        if not token:
            return jsonify({'message': 'Token is missing'}), 401
        
        # Verify token
        payload = verify_token(token)
        if not payload:
            return jsonify({'message': 'Token is invalid or expired'}), 401
        
        # Get current user
        current_user = User.by_id(payload['user_id'])
        if not current_user:
            return jsonify({'message': 'User not found'}), 401
        
        return f(current_user, *args, **kwargs)
    
    return decorated

def session_required(f):
    """Decorator to require valid session for web interface"""
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            return jsonify({'message': 'Login required'}), 401
        
        current_user = User.by_id(session['user_id'])
        if not current_user:
            session.clear()
            return jsonify({'message': 'User not found'}), 401
        
        return f(current_user, *args, **kwargs)
    
    return decorated