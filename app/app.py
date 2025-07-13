"""
Flask application setup for WORDIAMO
Main application with routing and middleware configuration
"""

from flask import Flask, request, jsonify, session
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
    session_required, get_current_user, verify_token
)
from src.main.models import User, Level, Lesson, Question, Option, StudentAttempt
from quiz import start_quiz, submit_answer, get_quiz_progress, get_quiz_history
from src.main.database import get_db_manager
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
            db_manager = get_db_manager()
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
    def get_levels():
        """Get all available learning levels"""
        try:
            levels = Level.get_all()
            levels_data = []
            
            for level in levels:
                lesson_count = level.get_lesson_count()
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
    
    @app.route('/levels/<int:level_id>/lessons', methods=['GET'])
    def get_lessons_by_level(level_id):
        """Get lessons for a specific level"""
        try:
            level = Level.get_by_id(level_id)
            if not level:
                return jsonify({'error': 'Level not found'}), 404
            
            lessons = Lesson.get_by_level(level_id)
            lessons_data = []
            
            for lesson in lessons:
                question_count = lesson.get_question_count()
                avg_score = lesson.get_average_score()
                
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
    def get_questions_by_lesson(current_user, lesson_id):
        """Get questions for a specific lesson (requires authentication)"""
        try:
            lesson = Lesson.get_by_id(lesson_id)
            if not lesson:
                return jsonify({'error': 'Lesson not found'}), 404
            
            # Check if user can access this lesson
            if lesson.level_id > current_user.current_level_id:
                return jsonify({'error': 'Access denied to this lesson'}), 403
            
            questions = Question.get_by_lesson(lesson_id)
            questions_data = []
            
            for question in questions:
                options = Option.get_by_question(question.question_id)
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
            data = request.get_json()
            if not data:
                return jsonify({'error': 'No data provided'}), 400
            
            lesson_id = data.get('lesson_id')
            if not lesson_id:
                return jsonify({'error': 'Lesson ID required'}), 400
            
            result = start_quiz(current_user.user_id, lesson_id)
            
            if result['success']:
                return jsonify(result), 200
            else:
                return jsonify(result), 400
                
        except Exception as e:
            return jsonify({'error': f'Failed to start quiz: {str(e)}'}), 500
    
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
            progress_data = current_user.get_progress()
            
            # Get current quiz progress if any
            quiz_progress = get_quiz_progress(current_user.user_id)
            
            return jsonify({
                'success': True,
                'user': {
                    'user_id': current_user.user_id,
                    'username': current_user.username,
                    'current_level_id': current_user.current_level_id
                },
                'progress': progress_data,
                'active_quiz': quiz_progress if quiz_progress.get('success') else None
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch progress: {str(e)}'}), 500
    
    @app.route('/user/scores', methods=['GET'])
    @token_required
    def user_scores(current_user):
        """Get user's quiz score history"""
        try:
            limit = request.args.get('limit', 10, type=int)
            history = get_quiz_history(current_user.user_id, limit)
            
            return jsonify({
                'success': True,
                'quiz_history': history
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch scores: {str(e)}'}), 500
    
    # Content Categorization endpoints
    @app.route('/content/categories', methods=['GET'])
    def get_content_categories():
        """Get all available skill categories"""
        try:
            categories = ContentCategorization.get_all_categories()
            return jsonify({
                'success': True,
                'categories': categories
            }), 200
        except Exception as e:
            return jsonify({'error': f'Failed to fetch categories: {str(e)}'}), 500
    
    @app.route('/content/overview', methods=['GET'])
    def get_content_overview():
        """Get overview of all content by categories"""
        try:
            overview = ContentCategorization.get_content_overview()
            return jsonify({
                'success': True,
                'overview': overview
            }), 200
        except Exception as e:
            return jsonify({'error': f'Failed to fetch content overview: {str(e)}'}), 500
    
    @app.route('/questions/by-type/<string:question_type>', methods=['GET'])
    def get_questions_by_type(question_type):
        """Get questions by skill type"""
        try:
            questions = Question.get_by_type(question_type)
            questions_data = []
            
            for question in questions:
                options = question.get_options()
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
    def get_lessons_by_skill(skill_type):
        """Get lessons that focus on a specific skill type"""
        try:
            level_id = request.args.get('level_id', type=int)
            lessons = ContentCategorization.get_lessons_by_skill(skill_type, level_id)
            
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
            analysis = ContentCategorization.get_user_skill_analysis(current_user.user_id)
            
            return jsonify({
                'success': True,
                'skill_analysis': analysis
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch skill analysis: {str(e)}'}), 500
    
    @app.route('/levels/<int:level_id>/skills', methods=['GET'])
    def get_level_skill_distribution(level_id):
        """Get skill distribution for a specific level"""
        try:
            distribution = ContentCategorization.get_level_skill_distribution(level_id)
            
            return jsonify({
                'success': True,
                'distribution': distribution
            }), 200
            
        except Exception as e:
            return jsonify({'error': f'Failed to fetch level skill distribution: {str(e)}'}), 500
    
    @app.route('/content/statistics', methods=['GET'])
    def get_content_statistics():
        """Get question and difficulty statistics"""
        try:
            question_stats = Question.get_type_statistics()
            difficulty_stats = Question.get_difficulty_statistics()
            
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
    
    return app

# Create the Flask application instance
app = create_app()