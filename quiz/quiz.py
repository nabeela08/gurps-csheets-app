"""
Quiz engine for WORDIAMO English Learning Platform
Handles quiz sessions, scoring, validation, and attempt tracking
"""

import time
from datetime import datetime
from typing import Dict, List, Any, Optional, Tuple
from src.main.models import User, Lesson, Question, Option, StudentAttempt
from src.main.database import query, insert

# Global storage for active quiz sessions
active_sessions = {}  # user_id: session_data

class QuizSession:
    """Represents an active quiz session"""
    
    def __init__(self, user_id: int, lesson_id: int):
        self.user_id = user_id
        self.lesson_id = lesson_id
        self.start_time = datetime.now()
        self.questions = []
        self.answers = {}
        self.current_question_index = 0
        self.completed = False
        
        # Load questions for the lesson
        self._load_questions()
    
    def _load_questions(self):
        """Load all questions for the lesson with their options"""
        lesson = Lesson.by_id(self.lesson_id)
        if not lesson:
            raise ValueError(f"Lesson {self.lesson_id} not found")
        
        questions = Question.by_lesson(self.lesson_id)
        for question in questions:
            options = Option.by_question(question.question_id)
            self.questions.append({
                'question': question,
                'options': options
            })
    
    def question_count(self) -> int:
        """Get total number of questions in quiz"""
        return len(self.questions)
    
    def current_question(self) -> Optional[Dict[str, Any]]:
        """Get current question with options"""
        if self.current_question_index < len(self.questions):
            return self.questions[self.current_question_index]
        return None
    
    def submit_answer(self, question_id: int, option_id: int) -> bool:
        """Submit answer for a question"""
        if question_id in self.answers:
            return False  # Question already answered
        
        self.answers[question_id] = option_id
        return True
    
    def next_question(self) -> bool:
        """Move to next question"""
        if self.current_question_index < len(self.questions) - 1:
            self.current_question_index += 1
            return True
        return False
    
    def is_complete(self) -> bool:
        """Check if all questions have been answered"""
        return len(self.answers) == len(self.questions)
    
    def calculate_score(self) -> Tuple[int, int, int]:
        """Calculate score and return (score_percentage, correct_answers, total_questions)"""
        if not self.is_complete():
            raise ValueError("Quiz is not complete")
        
        correct_answers = 0
        total_questions = len(self.questions)
        
        for question_data in self.questions:
            question = question_data['question']
            question_id = question.question_id
            
            if question_id in self.answers:
                submitted_option_id = self.answers[question_id]
                if question.validate_answer(submitted_option_id):
                    correct_answers += 1
        
        score_percentage = int((correct_answers / total_questions) * 100) if total_questions > 0 else 0
        return score_percentage, correct_answers, total_questions
    
    def completion_time(self) -> int:
        """Get completion time in minutes"""
        completion_time = datetime.now() - self.start_time
        return int(completion_time.total_seconds() / 60)

def start_quiz(user_id: int, lesson_id: int) -> Dict[str, Any]:
    """Start a new quiz session"""
    try:
        # Validate user and lesson
        user = User.by_id(user_id)
        if not user:
            return {'success': False, 'message': 'User not found'}
        
        lesson = Lesson.by_id(lesson_id)
        if not lesson:
            return {'success': False, 'message': 'Lesson not found'}
        
        # Check if user has permission to access this lesson
        if not can_access_lesson(user, lesson):
            return {'success': False, 'message': 'Access denied to this lesson'}
        
        # End any existing session for this user
        if user_id in active_sessions:
            del active_sessions[user_id]
        
        # Create new quiz session
        session = QuizSession(user_id, lesson_id)
        active_sessions[user_id] = session
        
        # Get first question
        first_question = session.current_question()
        
        return {
            'success': True,
            'message': 'Quiz started successfully',
            'session_data': {
                'lesson_id': lesson_id,
                'lesson_name': lesson.lesson_name,
                'total_questions': session.question_count(),
                'current_question_index': 0,
                'estimated_time': lesson.estimated_time_minutes
            },
            'question': format_question(first_question) if first_question else None
        }
        
    except Exception as e:
        return {'success': False, 'message': f'Failed to start quiz: {str(e)}'}

def submit_answer(user_id: int, question_id: int, option_id: int) -> Dict[str, Any]:
    """Submit answer for current question"""
    try:
        if user_id not in active_sessions:
            return {'success': False, 'message': 'No active quiz session'}
        
        session = active_sessions[user_id]
        
        # Submit answer
        if not session.submit_answer(question_id, option_id):
            return {'success': False, 'message': 'Question already answered'}
        
        # Get the question to check if answer is correct
        question = Question.by_id(question_id)
        is_correct = question.validate_answer(option_id) if question else False
        
        # Get correct option for feedback
        correct_option_id = None
        if question:
            options = Option.by_question(question_id)
            correct_option = next((opt for opt in options if opt.is_correct), None)
            correct_option_id = correct_option.option_id if correct_option else None
        
        # Check if quiz is complete
        if session.is_complete():
            return complete_quiz(user_id)
        
        # Move to next question
        session.next_question()
        next_question = session.current_question()
        
        return {
            'success': True,
            'message': 'Answer submitted successfully',
            'quiz_complete': False,
            'is_correct': is_correct,
            'correct_option_id': correct_option_id,
            'current_question_index': session.current_question_index,
            'question': format_question(next_question) if next_question else None
        }
        
    except Exception as e:
        return {'success': False, 'message': f'Failed to submit answer: {str(e)}'}

def quiz_progress(user_id: int) -> Dict[str, Any]:
    """Get current quiz progress"""
    if user_id not in active_sessions:
        return {'success': False, 'message': 'No active quiz session'}
    
    session = active_sessions[user_id]
    current_question = session.current_question()
    
    return {
        'success': True,
        'progress': {
            'lesson_id': session.lesson_id,
            'current_question_index': session.current_question_index,
            'total_questions': session.question_count(),
            'answered_questions': len(session.answers),
            'quiz_complete': session.is_complete()
        },
        'question': format_question(current_question) if current_question else None
    }

def complete_quiz(user_id: int) -> Dict[str, Any]:
    """Complete quiz and save results"""
    session = active_sessions[user_id]
    
    # Calculate score
    score_percentage, correct_answers, total_questions = session.calculate_score()
    completion_time = session.completion_time()
    
    # Determine if lesson is completed (passing score >= 70%)
    is_completed = score_percentage >= 70
    
    # Save attempt to database
    attempt = StudentAttempt.create(
        user_id=session.user_id,
        lesson_id=session.lesson_id,
        score=score_percentage,
        total_questions=total_questions,
        correct_answers=correct_answers,
        completion_time_minutes=completion_time,
        is_completed=is_completed
    )
    
    # Check for level progression if lesson completed
    level_upgrade_info = None
    if is_completed:
        user = User.by_id(user_id)
        if user:
            upgrade_check = user.check_level_upgrade()
            if upgrade_check['can_upgrade']:
                # Upgrade user to next level
                if user.upgrade_level():
                    level_upgrade_info = {
                        'upgraded': True,
                        'new_level_id': upgrade_check['next_level_id'],
                        'new_level_name': upgrade_check['next_level_name'],
                        'completion_progress': upgrade_check['current_progress']
                    }
    
    # Get detailed results
    results = detailed_results(session)
    
    # Clean up session
    del active_sessions[user_id]
    
    response = {
        'success': True,
        'message': 'Quiz completed successfully',
        'quiz_complete': True,
        'results': {
            'attempt_id': attempt.attempt_id,
            'score_percentage': score_percentage,
            'correct_answers': correct_answers,
            'total_questions': total_questions,
            'completion_time_minutes': completion_time,
            'passing_score': attempt.is_passing_score(),
            'lesson_completed': is_completed,
            'detailed_results': results
        }
    }
    
    # Add level upgrade info if applicable
    if level_upgrade_info:
        response['level_upgrade'] = level_upgrade_info
    
    return response

def detailed_results(session: QuizSession) -> List[Dict[str, Any]]:
    """Get detailed results for each question"""
    results = []
    
    for question_data in session.questions:
        question = question_data['question']
        options = question_data['options']
        
        submitted_option_id = session.answers.get(question.question_id)
        submitted_option = next((opt for opt in options if opt.option_id == submitted_option_id), None)
        correct_options = [opt for opt in options if opt.is_correct]
        
        results.append({
            'question_id': question.question_id,
            'question_text': question.question_text,
            'question_type': question.question_type,
            'submitted_answer': {
                'option_id': submitted_option.option_id if submitted_option else None,
                'option_text': submitted_option.option_text if submitted_option else None
            },
            'correct_answer': {
                'option_id': correct_options[0].option_id if correct_options else None,
                'option_text': correct_options[0].option_text if correct_options else None
            },
            'is_correct': question.validate_answer(submitted_option_id) if submitted_option_id else False
        })
    
    return results

def can_access_lesson(user: User, lesson: Lesson) -> bool:
    """Check if user can access the lesson based on their current level"""
    # For now, allow access to lessons in current level and below
    # In future, implement prerequisite checking
    return lesson.level_id <= user.current_level_id

def format_question(question_data: Dict[str, Any]) -> Dict[str, Any]:
    """Format question data for API response"""
    if not question_data:
        return None
    
    question = question_data['question']
    options = question_data['options']
    
    return {
        'question_id': question.question_id,
        'question_text': question.question_text,
        'question_type': question.question_type,
        'difficulty_level': question.difficulty_level,
        'options': [
            {
                'option_id': option.option_id,
                'option_text': option.option_text,
                'option_order': option.option_order
            }
            for option in sorted(options, key=lambda x: x.option_order)
        ]
    }

def end_quiz_session(user_id: int) -> bool:
    """End quiz session without saving results"""
    if user_id in active_sessions:
        del active_sessions[user_id]
        return True
    return False

def quiz_history(user_id: int, limit: int = 10) -> List[Dict[str, Any]]:
    """Get user's quiz attempt history"""
    attempts = StudentAttempt.by_user(user_id)
    
    history = []
    for attempt in attempts[:limit]:
        lesson = Lesson.by_id(attempt.lesson_id)
        history.append({
            'attempt_id': attempt.attempt_id,
            'lesson_id': attempt.lesson_id,
            'lesson_name': lesson.lesson_name if lesson else 'Unknown',
            'score_percentage': attempt.score,
            'correct_answers': attempt.correct_answers,
            'total_questions': attempt.total_questions,
            'completion_time_minutes': attempt.completion_time_minutes,
            'attempt_date': attempt.attempt_date.isoformat() if attempt.attempt_date else None,
            'passing_score': attempt.is_passing_score()
        })
    
    return history