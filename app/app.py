"""
Flask application setup for WORDIAMO
Main application with routing and middleware configuration
"""

from flask import Flask, request, jsonify, session, send_from_directory
from flask_cors import CORS
import os
from datetime import timedelta
import logging

# Import modules
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from auth import (
    register_user, login_user, logout_user, token_required, 
    session_required, current_user, verify_token
)
from src.main.models import User, Level, Lesson, Question, Option, StudentAttempt
from quiz import start_quiz, submit_answer, quiz_progress, quiz_history
from src.main.database import db_manager_instance
from src.main.content_categorization import ContentCategorization

def create_app(config=None):
    """Create and configure Flask application"""
    
    app = Flask(__name__)
    
    # Configuration
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'wordiamo_secret_key_2024')
    app.config['SESSION_PERMANENT'] = False
    app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=24)
    app.config['JSON_SORT_KEYS'] = False
    
    if config:
        app.config.update(config)
    
    # Enable CORS
    CORS(app, supports_credentials=True)
    
    # Configure logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Endpoint not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error'}), 500
    
    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({'error': 'Bad request'}), 400
    
    # Middleware
    @app.before_request
    def before_request():
        """Log incoming requests"""
        logger.info(f"{request.method} {request.path} - {request.remote_addr}")
    
    @app.after_request
    def after_request(response):
        """Add security headers"""
        response.headers['X-Content-Type-Options'] = 'nosniff'
        response.headers['X-Frame-Options'] = 'DENY'
        response.headers['X-XSS-Protection'] = '1; mode=block'
        return response
    
    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health_check():
        """Health check endpoint"""
        try:
            # Test database connection
            db_manager = db_manager_instance()
            db_status = db_manager.test_connection()
            
            return jsonify({
                'status': 'healthy' if db_status else 'unhealthy',
                'database': 'connected' if db_status else 'disconnected',
                'service': 'WORDIAMO English Learning Platform'
            }), 200 if db_status else 503
        except Exception as e:
            return jsonify({
                'status': 'unhealthy',
                'error': str(e)
            }), 503
    
    # Authentication endpoints
    @app.route('/auth/register', methods=['POST'])
    def auth_register():
        """User registration endpoint"""
        try:
            data = request.get_json()
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            username = data.get('username')
            email = data.get('email')
            password = data.get('password')
            
            result = register_user(username, email, password)
            
            if result['success']:
                return jsonify(result), 201
            else:
                return jsonify(result), 400
                
        except Exception as e:
            return jsonify({'error': f'Registration failed: {str(e)}'}), 500
    
    @app.route('/auth/login', methods=['POST'])
    def auth_login():
        """User login endpoint"""
        try:
            data = request.get_json()
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            identifier = data.get('email') or data.get('username')
            password = data.get('password')
            
            result = login_user(identifier, password)
            
            if result['success']:
                # Set session for web interface
                session['user_id'] = result['user']['user_id']
                session['username'] = result['user']['username']
                return jsonify(result), 200
            else:
                return jsonify(result), 401
                
        except Exception as e:
            return jsonify({'error': f'Login failed: {str(e)}'}), 500
    
    @app.route('/auth/logout', methods=['POST'])
    def auth_logout():
        """User logout endpoint"""
        try:
            # Clear session
            session.clear()
            
            # Handle token-based logout
            auth_header = request.headers.get('Authorization')
            if auth_header:
                try:
                    token = auth_header.split(" ")[1]
                    result = logout_user(token)
                    return jsonify(result), 200
                except IndexError:
                    pass
            
            return jsonify({'success': True, 'message': 'Logout successful'}), 200
            
        except Exception as e:
            return jsonify({'error': f'Logout failed: {str(e)}'}), 500
    
    # Content access endpoints
    @app.route('/levels', methods=['GET'])
    def levels():
        """Get all available learning levels"""
        try:
            levels = Level.all()
            levels_data = []
            
            for level in levels:
                lesson_count = level.lesson_count()
                levels_data.append({
                    'level_id': level.level_id,
                    'level_name': level.level_name,
                    'level_description': level.level_description,
                    'level_order': level.level_order,
                    'lesson_count': lesson_count
                })
            
            return jsonify({
                'success': True,
                'levels': levels_data
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch levels: {str(e)}'}), 500
    
    @app.route('/levels/<int:level_id>', methods=['GET'])
    def level_by_id(level_id):
        """Get single level information"""
        try:
            level = Level.by_id(level_id)
            if not level:
                return jsonify({'error': 'Level not found'}), 404
            
            lesson_count = level.lesson_count()
            
            return jsonify({
                'success': True,
                'level': {
                    'level_id': level.level_id,
                    'level_name': level.level_name,
                    'level_description': level.level_description,
                    'level_order': level.level_order,
                    'lesson_count': lesson_count
                }
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch level: {str(e)}'}), 500
    
    @app.route('/levels/<int:level_id>/lessons', methods=['GET'])
    def lessons_by_level(level_id):
        """Get lessons for a specific level"""
        try:
            level = Level.by_id(level_id)
            if not level:
                return jsonify({'error': 'Level not found'}), 404
            
            lessons = Lesson.by_level(level_id)
            lessons_data = []
            
            for lesson in lessons:
                question_count = lesson.question_count()
                avg_score = lesson.average_score()
                
                lessons_data.append({
                    'lesson_id': lesson.lesson_id,
                    'lesson_name': lesson.lesson_name,
                    'lesson_description': lesson.lesson_description,
                    'lesson_order': lesson.lesson_order,
                    'estimated_time_minutes': lesson.estimated_time_minutes,
                    'question_count': question_count,
                    'average_score': round(avg_score, 1)
                })
            
            return jsonify({
                'success': True,
                'level': {
                    'level_id': level.level_id,
                    'level_name': level.level_name,
                    'level_description': level.level_description
                },
                'lessons': lessons_data
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch lessons: {str(e)}'}), 500
    
    @app.route('/lessons/<int:lesson_id>/questions', methods=['GET'])
    @token_required
    def questions_by_lesson(current_user, lesson_id):
        """Get questions for a specific lesson (requires authentication)"""
        try:
            lesson = Lesson.by_id(lesson_id)
            if not lesson:
                return jsonify({'error': 'Lesson not found'}), 404
            
            # Check if user can access this lesson
            if lesson.level_id > current_user.current_level_id:
                return jsonify({'error': 'Access denied to this lesson'}), 403
            
            questions = Question.by_lesson(lesson_id)
            questions_data = []
            
            for question in questions:
                options = Option.by_question(question.question_id)
                options_data = [
                    {
                        'option_id': option.option_id,
                        'option_text': option.option_text,
                        'option_order': option.option_order
                    }
                    for option in sorted(options, key=lambda x: x.option_order)
                ]
                
                questions_data.append({
                    'question_id': question.question_id,
                    'question_text': question.question_text,
                    'question_type': question.question_type,
                    'difficulty_level': question.difficulty_level,
                    'options': options_data
                })
            
            return jsonify({
                'success': True,
                'lesson': {
                    'lesson_id': lesson.lesson_id,
                    'lesson_name': lesson.lesson_name,
                    'lesson_description': lesson.lesson_description
                },
                'questions': questions_data
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch questions: {str(e)}'}), 500
    
    # Quiz functionality endpoints
    @app.route('/quiz/start', methods=['POST'])
    @token_required
    def quiz_start(current_user):
        """Start a new quiz session"""
        try:
            logger.info(f"Quiz start request from user {current_user.user_id}")
            data = request.get_json()
            logger.info(f"Request data: {data}")
            
            if not data:
                logger.error("No data provided in request")
                return jsonify({'error': 'No data provided'}), 400
            
            lesson_id = data.get('lesson_id')
            if not lesson_id:
                logger.error("No lesson_id provided")
                return jsonify({'error': 'Lesson ID required'}), 400
            
            logger.info(f"Starting quiz for user {current_user.user_id}, lesson {lesson_id}")
            result = start_quiz(current_user.user_id, lesson_id)
            logger.info(f"Quiz start result: {result}")
            
            if result['success']:
                return jsonify(result), 200
            else:
                logger.error(f"Quiz start failed: {result}")
                return jsonify(result), 400
                
        except Exception as e:
            logger.error(f"Exception in quiz_start: {str(e)}")
            return jsonify({'error': f'Failed to start quiz: {str(e)}'}), 500
    
    @app.route('/quiz/check-answer', methods=['POST'])
    @token_required
    def quiz_check_answer(current_user):
        """Check if an answer is correct (without session management)"""
        try:
            data = request.get_json()
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            question_id = data.get('question_id')
            option_id = data.get('option_id')
            
            if not question_id or not option_id:
                return jsonify({'error': 'Question ID and Option ID required'}), 400
            
            # Get the question
            question = Question.by_id(question_id)
            if not question:
                return jsonify({'error': 'Question not found'}), 404
            
            # Get all options for this question
            options = Option.by_question(question_id)
            
            # Find correct option
            correct_option = None
            for option in options:
                if option.is_correct:
                    correct_option = option
                    break
            
            # Check if submitted answer is correct
            is_correct = False
            for option in options:
                if option.option_id == option_id and option.is_correct:
                    is_correct = True
                    break
            
            return jsonify({
                'success': True,
                'is_correct': is_correct,
                'correct_option_id': correct_option.option_id if correct_option else None,
                'explanation': question.explanation if hasattr(question, 'explanation') else None
            }), 200
                
        except Exception as e:
            return jsonify({'error': f'Failed to check answer: {str(e)}'}), 500

    @app.route('/quiz/submit', methods=['POST'])
    @token_required
    def quiz_submit(current_user):
        """Submit quiz answer"""
        try:
            data = request.get_json()
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            question_id = data.get('question_id')
            option_id = data.get('option_id')
            
            if not question_id or not option_id:
                return jsonify({'error': 'Question ID and Option ID required'}), 400
            
            result = submit_answer(current_user.user_id, question_id, option_id)
            
            if result['success']:
                return jsonify(result), 200
            else:
                return jsonify(result), 400
                
        except Exception as e:
            return jsonify({'error': f'Failed to submit answer: {str(e)}'}), 500
    
    @app.route('/user/progress', methods=['GET'])
    @token_required
    def user_progress(current_user):
        """Get user's current progress"""
        try:
            # Get user progress data
            progress_data = current_user.progress()
            
            # Get current quiz progress if any
            active_quiz = quiz_progress(current_user.user_id)
            
            # Get completed lessons
            completed_lessons = current_user.completed_lessons()
            
            # Get level completion progress for all levels
            levels = Level.all()
            level_progress = {}
            for level in levels:
                level_progress[level.level_id] = current_user.level_completion_progress(level.level_id)
            
            # Check for level upgrade possibility
            upgrade_check = current_user.check_level_upgrade()
            
            return jsonify({
                'success': True,
                'user': {
                    'user_id': current_user.user_id,
                    'username': current_user.username,
                    'current_level_id': current_user.current_level_id
                },
                'progress': progress_data,
                'completed_lessons': completed_lessons,
                'level_progress': level_progress,
                'level_upgrade': upgrade_check,
                'active_quiz': active_quiz if active_quiz.get('success') else None
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch progress: {str(e)}'}), 500
    
    @app.route('/user/scores', methods=['GET'])
    @token_required
    def user_scores(current_user):
        """Get user's quiz score history"""
        try:
            limit = request.args.get('limit', 10, type=int)
            history = quiz_history(current_user.user_id, limit)
            
            return jsonify({
                'success': True,
                'quiz_history': history
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch scores: {str(e)}'}), 500
    
    @app.route('/user/profile', methods=['GET'])
    @token_required
    def user_profile(current_user):
        """Get user profile information"""
        try:
            # Get current level name
            from src.main.models.models import Level
            current_level = Level.by_id(current_user.current_level_id)
            
            return jsonify({
                'success': True,
                'profile': {
                    'user_id': current_user.user_id,
                    'username': current_user.username,
                    'email': current_user.email,
                    'current_level_id': current_user.current_level_id,
                    'current_level_name': current_level.level_name if current_level else 'Beginner',
                    'created_at': current_user.created_at.isoformat() if current_user.created_at else None,
                    'updated_at': current_user.updated_at.isoformat() if current_user.updated_at else None
                }
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch profile: {str(e)}'}), 500
    
    @app.route('/user/profile', methods=['PUT'])
    @token_required
    def update_user_profile(current_user):
        """Update user profile information"""
        try:
            data = request.get_json()
            
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            # Only allow username updates
            updated = False
            
            if 'username' in data and data['username'].strip():
                # Check if username is already taken by another user
                from src.main.models.models import User
                existing_user = User.by_username(data['username'].strip())
                if existing_user and existing_user.user_id != current_user.user_id:
                    return jsonify({'error': 'Username already taken'}), 400
                
                # Update username
                new_username = data['username'].strip()
                if current_user.set_profile(username=new_username):
                    current_user.username = new_username
                    updated = True
            
            if updated:
                return jsonify({
                    'success': True,
                    'message': 'Profile updated successfully'
                }), 200
            else:
                return jsonify({
                    'success': False,
                    'message': 'No changes made to profile'
                }), 200
                
        except Exception as e:
            return jsonify({'error': f'Failed to update profile: {str(e)}'}), 500
    
    @app.route('/user/change-password', methods=['POST'])
    @token_required
    def change_password(current_user):
        """Change user password"""
        try:
            data = request.get_json()
            
            if not data or 'current_password' not in data or 'new_password' not in data:
                return jsonify({'error': 'Current password and new password are required'}), 400
            
            # Import bcrypt for password operations
            from bcrypt import checkpw, hashpw, gensalt
            
            # Verify current password
            if not checkpw(data['current_password'].encode('utf-8'), current_user.password_hash.encode('utf-8')):
                return jsonify({'error': 'Current password is incorrect'}), 400
            
            # Hash new password
            new_password_hash = hashpw(data['new_password'].encode('utf-8'), gensalt()).decode('utf-8')
            
            # Update password in database
            from src.main.database.database import update as db_update
            sql = "UPDATE users SET password_hash = %s, updated_at = CURRENT_TIMESTAMP WHERE user_id = %s"
            affected = db_update(sql, (new_password_hash, current_user.user_id))
            
            if affected > 0:
                return jsonify({
                    'success': True,
                    'message': 'Password changed successfully'
                }), 200
            else:
                return jsonify({'error': 'Failed to update password'}), 500
                
        except Exception as e:
            return jsonify({'error': f'Failed to change password: {str(e)}'}), 500
    
    @app.route('/user/account', methods=['DELETE'])
    @token_required
    def delete_user_account(current_user):
        """Delete user account"""
        try:
            data = request.get_json()
            
            if not data or 'password' not in data:
                return jsonify({'error': 'Password confirmation is required'}), 400
            
            # Import bcrypt for password verification
            from bcrypt import checkpw
            
            # Verify password before deletion
            if not checkpw(data['password'].encode('utf-8'), current_user.password_hash.encode('utf-8')):
                return jsonify({'error': 'Password is incorrect'}), 400
            
            # Delete user account (this will cascade delete related records)
            from src.main.database.database import update as db_update
            sql = "DELETE FROM users WHERE user_id = %s"
            affected = db_update(sql, (current_user.user_id,))
            
            if affected > 0:
                return jsonify({
                    'success': True,
                    'message': 'Account deleted successfully'
                }), 200
            else:
                return jsonify({'error': 'Failed to delete account'}), 500
                
        except Exception as e:
            return jsonify({'error': f'Failed to delete account: {str(e)}'}), 500
    
    @app.route('/lesson/access-check/<int:lesson_id>', methods=['GET'])
    @token_required
    def check_lesson_access(current_user, lesson_id):
        """Check if user can access a specific lesson"""
        try:
            lesson = Lesson.by_id(lesson_id)
            if not lesson:
                return jsonify({'error': 'Lesson not found'}), 404
            
            level = Level.by_id(lesson.level_id)
            user_level = Level.by_id(current_user.current_level_id)
            
            # Check if user can access this lesson level
            can_access = lesson.level_id <= current_user.current_level_id
            
            # Check if lesson is completed
            is_completed = current_user.is_lesson_completed(lesson_id)
            
            # Get level progress
            level_progress = current_user.level_completion_progress(lesson.level_id)
            
            response = {
                'success': True,
                'lesson': {
                    'lesson_id': lesson.lesson_id,
                    'lesson_name': lesson.lesson_name,
                    'level_id': lesson.level_id,
                    'level_name': level.level_name if level else 'Unknown'
                },
                'access': {
                    'can_access': can_access,
                    'is_completed': is_completed,
                    'user_level': {
                        'level_id': current_user.current_level_id,
                        'level_name': user_level.level_name if user_level else 'Unknown'
                    },
                    'required_level': {
                        'level_id': lesson.level_id,
                        'level_name': level.level_name if level else 'Unknown'
                    }
                },
                'level_progress': level_progress
            }
            
            if not can_access:
                response['message'] = f"You need to complete {user_level.level_name if user_level else 'previous'} level to access {level.level_name if level else 'this'} lessons"
            
            return jsonify(response), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to check lesson access: {str(e)}'}), 500
    
    # Content Categorization endpoints
    @app.route('/content/categories', methods=['GET'])
    def content_categories():
        """Get all available skill categories"""
        try:
            categories = ContentCategorization.all_categories()
            return jsonify({
                'success': True,
                'categories': categories
            }), 200
        except Exception as e:
            return jsonify({'error': f'Failed to fetch categories: {str(e)}'}), 500
    
    @app.route('/content/overview', methods=['GET'])
    def content_overview():
        """Get overview of all content by categories"""
        try:
            overview = ContentCategorization.content_overview()
            return jsonify({
                'success': True,
                'overview': overview
            }), 200
        except Exception as e:
            return jsonify({'error': f'Failed to fetch content overview: {str(e)}'}), 500
    
    @app.route('/questions/by-type/<string:question_type>', methods=['GET'])
    def questions_by_type(question_type):
        """Get questions by skill type"""
        try:
            questions = Question.by_type(question_type)
            questions_data = []
            
            for question in questions:
                options = question.options()
                questions_data.append({
                    'question_id': question.question_id,
                    'question_text': question.question_text,
                    'lesson_id': question.lesson_id,
                    'question_type': question.question_type,
                    'difficulty_level': question.difficulty_level,
                    'options': [
                        {
                            'option_id': option.option_id,
                            'option_text': option.option_text,
                            'is_correct': option.is_correct,
                            'option_order': option.option_order
                        }
                        for option in sorted(options, key=lambda x: x.option_order)
                    ]
                })
            
            return jsonify({
                'success': True,
                'question_type': question_type,
                'questions': questions_data,
                'total_count': len(questions_data)
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch questions by type: {str(e)}'}), 500
    
    @app.route('/lessons/by-skill/<string:skill_type>', methods=['GET'])
    def lessons_by_skill(skill_type):
        """Get lessons that focus on a specific skill type"""
        try:
            level_id = request.args.get('level_id', type=int)
            lessons = ContentCategorization.lessons_by_skill(skill_type, level_id)
            
            return jsonify({
                'success': True,
                'skill_type': skill_type,
                'level_id': level_id,
                'lessons': lessons,
                'total_count': len(lessons)
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch lessons by skill: {str(e)}'}), 500
    
    @app.route('/user/progress/by-category', methods=['GET'])
    @token_required
    def user_progress_by_category(current_user):
        """Get user performance breakdown by skill category"""
        try:
            analysis = ContentCategorization.user_skill_analysis(current_user.user_id)
            
            return jsonify({
                'success': True,
                'skill_analysis': analysis
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch skill analysis: {str(e)}'}), 500
    
    @app.route('/levels/<int:level_id>/skills', methods=['GET'])
    def level_skill_distribution(level_id):
        """Get skill distribution for a specific level"""
        try:
            distribution = ContentCategorization.level_skill_distribution(level_id)
            
            return jsonify({
                'success': True,
                'distribution': distribution
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch level skill distribution: {str(e)}'}), 500
    
    @app.route('/content/statistics', methods=['GET'])
    def content_statistics():
        """Get question and difficulty statistics"""
        try:
            question_stats = Question.type_statistics()
            difficulty_stats = Question.difficulty_statistics()
            
            return jsonify({
                'success': True,
                'statistics': {
                    'question_types': question_stats,
                    'difficulty_levels': difficulty_stats,
                    'total_questions': sum(question_stats.values())
                }
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch statistics: {str(e)}'}), 500
    
    # Static file serving routes
    @app.route('/')
    def index():
        """Serve main page"""
        return send_from_directory('../', 'index.html')
    
    @app.route('/index.html')
    def index_html():
        """Serve main page"""
        return send_from_directory('../', 'index.html')
    
    @app.route('/pages/<path:filename>')
    def serve_pages(filename):
        """Serve HTML pages"""
        return send_from_directory('../pages', filename)
    
    @app.route('/js/<path:filename>')
    def serve_js(filename):
        """Serve JavaScript files"""
        return send_from_directory('../js', filename)
    
    @app.route('/css/<path:filename>')
    def serve_css(filename):
        """Serve CSS files"""
        return send_from_directory('../css', filename)
    
    @app.route('/assets/<path:filename>')
    def serve_assets(filename):
        """Serve asset files"""
        return send_from_directory('../assets', filename)
    
    return app

# Create the Flask application instance
app = create_app()