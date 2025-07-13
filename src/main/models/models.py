"""
Data models for WORDIAMO English Learning Platform
Contains all entity classes and their methods
"""

from datetime import datetime
from typing import List, Dict, Any, Optional
from ..database import query, insert, update

class User:
    """User model for student accounts"""
    
    def __init__(self, user_id: int = None, username: str = None, email: str = None, 
                 password_hash: str = None, current_level_id: int = 1, 
                 created_at: datetime = None, updated_at: datetime = None):
        self.user_id = user_id
        self.username = username
        self.email = email
        self.password_hash = password_hash
        self.current_level_id = current_level_id
        self.created_at = created_at
        self.updated_at = updated_at
    
    @classmethod
    def create(cls, username: str, email: str, password_hash: str) -> 'User':
        """Create a new user"""
        sql = """
        INSERT INTO users (username, email, password_hash)
        VALUES (%s, %s, %s)
        """
        user_id = insert(sql, (username, email, password_hash))
        return cls.get_by_id(user_id)
    
    @classmethod
    def get_by_id(cls, user_id: int) -> Optional['User']:
        """Get user by ID"""
        sql = "SELECT * FROM users WHERE user_id = %s"
        result = query(sql, (user_id,))
        if result:
            return cls(**result[0])
        return None
    
    @classmethod
    def get_by_email(cls, email: str) -> Optional['User']:
        """Get user by email"""
        sql = "SELECT * FROM users WHERE email = %s"
        result = query(sql, (email,))
        if result:
            return cls(**result[0])
        return None
    
    @classmethod
    def get_by_username(cls, username: str) -> Optional['User']:
        """Get user by username"""
        sql = "SELECT * FROM users WHERE username = %s"
        result = query(sql, (username,))
        if result:
            return cls(**result[0])
        return None
    
    def update_profile(self, **kwargs) -> bool:
        """Update user profile"""
        if not self.user_id:
            return False
        
        allowed_fields = ['current_level_id']
        updates = []
        params = []
        
        for field, value in kwargs.items():
            if field in allowed_fields:
                updates.append(f"{field} = %s")
                params.append(value)
        
        if not updates:
            return False
        
        sql = f"UPDATE users SET {', '.join(updates)}, updated_at = CURRENT_TIMESTAMP WHERE user_id = %s"
        params.append(self.user_id)
        
        affected = update(sql, tuple(params))
        return affected > 0
    
    def get_attempts(self) -> List[Dict[str, Any]]:
        """Get all quiz attempts for this user"""
        sql = """
        SELECT sa.*, l.lesson_name, lv.level_name 
        FROM student_attempts sa
        JOIN lessons l ON sa.lesson_id = l.lesson_id
        JOIN levels lv ON l.level_id = lv.level_id
        WHERE sa.user_id = %s
        ORDER BY sa.attempt_date DESC
        """
        return query(sql, (self.user_id,))
    
    def get_progress(self) -> Dict[str, Any]:
        """Get user's learning progress"""
        sql = """
        SELECT 
            COUNT(DISTINCT sa.lesson_id) as completed_lessons,
            AVG(sa.score) as average_score,
            MAX(sa.attempt_date) as last_activity,
            l.level_name as current_level
        FROM student_attempts sa
        JOIN lessons ls ON sa.lesson_id = ls.lesson_id
        JOIN levels l ON %s = l.level_id
        WHERE sa.user_id = %s
        """
        result = query(sql, (self.current_level_id, self.user_id))
        return result[0] if result else {}

class Level:
    """Level model for learning levels"""
    
    def __init__(self, level_id: int = None, level_name: str = None, 
                 level_description: str = None, level_order: int = None, 
                 created_at: datetime = None):
        self.level_id = level_id
        self.level_name = level_name
        self.level_description = level_description
        self.level_order = level_order
        self.created_at = created_at
    
    @classmethod
    def get_all(cls) -> List['Level']:
        """Get all levels ordered by level_order"""
        sql = "SELECT * FROM levels ORDER BY level_order"
        results = query(sql)
        return [cls(**row) for row in results]
    
    @classmethod
    def get_by_id(cls, level_id: int) -> Optional['Level']:
        """Get level by ID"""
        sql = "SELECT * FROM levels WHERE level_id = %s"
        result = query(sql, (level_id,))
        if result:
            return cls(**result[0])
        return None
    
    def get_lessons(self) -> List['Lesson']:
        """Get all lessons for this level"""
        return Lesson.get_by_level(self.level_id)
    
    def get_lesson_count(self) -> int:
        """Get number of lessons in this level"""
        sql = "SELECT COUNT(*) as count FROM lessons WHERE level_id = %s"
        result = query(sql, (self.level_id,))
        return result[0]['count'] if result else 0

class Lesson:
    """Lesson model for individual lessons"""
    
    def __init__(self, lesson_id: int = None, lesson_name: str = None, 
                 lesson_description: str = None, level_id: int = None, 
                 lesson_order: int = None, estimated_time_minutes: int = 15, 
                 created_at: datetime = None):
        self.lesson_id = lesson_id
        self.lesson_name = lesson_name
        self.lesson_description = lesson_description
        self.level_id = level_id
        self.lesson_order = lesson_order
        self.estimated_time_minutes = estimated_time_minutes
        self.created_at = created_at
    
    @classmethod
    def get_by_level(cls, level_id: int) -> List['Lesson']:
        """Get all lessons for a specific level"""
        sql = "SELECT * FROM lessons WHERE level_id = %s ORDER BY lesson_order"
        results = query(sql, (level_id,))
        return [cls(**row) for row in results]
    
    @classmethod
    def get_all(cls) -> List['Lesson']:
        """Get all lessons"""
        sql = "SELECT * FROM lessons ORDER BY level_id, lesson_order"
        results = query(sql)
        return [cls(**row) for row in results]
    
    @classmethod
    def get_by_id(cls, lesson_id: int) -> Optional['Lesson']:
        """Get lesson by ID"""
        sql = "SELECT * FROM lessons WHERE lesson_id = %s"
        result = query(sql, (lesson_id,))
        if result:
            return cls(**result[0])
        return None
    
    def get_questions(self) -> List['Question']:
        """Get all questions for this lesson"""
        return Question.get_by_lesson(self.lesson_id)
    
    def get_question_count(self) -> int:
        """Get number of questions in this lesson"""
        sql = "SELECT COUNT(*) as count FROM questions WHERE lesson_id = %s"
        result = query(sql, (self.lesson_id,))
        return result[0]['count'] if result else 0
    
    def get_average_score(self) -> float:
        """Get average score for this lesson"""
        sql = "SELECT AVG(score) as avg_score FROM student_attempts WHERE lesson_id = %s"
        result = query(sql, (self.lesson_id,))
        return result[0]['avg_score'] if result and result[0]['avg_score'] else 0.0
    
    def get_skill_categories(self) -> Dict[str, int]:
        """Get count of questions by skill type for this lesson"""
        sql = """
        SELECT question_type, COUNT(*) as count 
        FROM questions 
        WHERE lesson_id = %s 
        GROUP BY question_type
        """
        results = query(sql, (self.lesson_id,))
        return {row['question_type']: row['count'] for row in results}
    
    @classmethod
    def get_by_skill_focus(cls, skill_type: str, level_id: int = None) -> List['Lesson']:
        """Get lessons that focus on a specific skill type"""
        if level_id:
            sql = """
            SELECT DISTINCT l.* FROM lessons l
            JOIN questions q ON l.lesson_id = q.lesson_id
            WHERE q.question_type = %s AND l.level_id = %s
            ORDER BY l.lesson_order
            """
            results = query(sql, (skill_type, level_id))
        else:
            sql = """
            SELECT DISTINCT l.* FROM lessons l
            JOIN questions q ON l.lesson_id = q.lesson_id
            WHERE q.question_type = %s
            ORDER BY l.level_id, l.lesson_order
            """
            results = query(sql, (skill_type,))
        return [cls(**row) for row in results]

class Question:
    """Question model for quiz questions"""
    
    def __init__(self, question_id: int = None, question_text: str = None, 
                 lesson_id: int = None, question_type: str = 'vocabulary', 
                 difficulty_level: str = 'easy', created_at: datetime = None):
        self.question_id = question_id
        self.question_text = question_text
        self.lesson_id = lesson_id
        self.question_type = question_type
        self.difficulty_level = difficulty_level
        self.created_at = created_at
    
    @classmethod
    def get_by_lesson(cls, lesson_id: int) -> List['Question']:
        """Get all questions for a specific lesson"""
        sql = "SELECT * FROM questions WHERE lesson_id = %s ORDER BY question_id"
        results = query(sql, (lesson_id,))
        return [cls(**row) for row in results]
    
    @classmethod
    def get_by_id(cls, question_id: int) -> Optional['Question']:
        """Get question by ID"""
        sql = "SELECT * FROM questions WHERE question_id = %s"
        result = query(sql, (question_id,))
        if result:
            return cls(**result[0])
        return None
    
    def get_options(self) -> List['Option']:
        """Get all options for this question"""
        return Option.get_by_question(self.question_id)
    
    def get_correct_options(self) -> List['Option']:
        """Get correct options for this question"""
        sql = "SELECT * FROM options WHERE question_id = %s AND is_correct = TRUE"
        results = query(sql, (self.question_id,))
        return [Option(**row) for row in results]
    
    def validate_answer(self, option_id: int) -> bool:
        """Check if given option is correct"""
        sql = "SELECT is_correct FROM options WHERE option_id = %s AND question_id = %s"
        result = query(sql, (option_id, self.question_id))
        return result[0]['is_correct'] if result else False
    
    @classmethod
    def get_by_type(cls, question_type: str) -> List['Question']:
        """Get all questions by type"""
        sql = "SELECT * FROM questions WHERE question_type = %s ORDER BY lesson_id, question_id"
        results = query(sql, (question_type,))
        return [cls(**row) for row in results]
    
    @classmethod
    def get_type_statistics(cls) -> Dict[str, int]:
        """Get count of questions by type"""
        sql = """
        SELECT question_type, COUNT(*) as count 
        FROM questions 
        GROUP BY question_type 
        ORDER BY count DESC
        """
        results = query(sql)
        return {row['question_type']: row['count'] for row in results}
    
    @classmethod
    def get_difficulty_statistics(cls) -> Dict[str, int]:
        """Get count of questions by difficulty"""
        sql = """
        SELECT difficulty_level, COUNT(*) as count 
        FROM questions 
        GROUP BY difficulty_level 
        ORDER BY FIELD(difficulty_level, 'easy', 'medium', 'hard')
        """
        results = query(sql)
        return {row['difficulty_level']: row['count'] for row in results}

class Option:
    """Option model for question choices"""
    
    def __init__(self, option_id: int = None, question_id: int = None, 
                 option_text: str = None, is_correct: bool = False, 
                 option_order: int = None):
        self.option_id = option_id
        self.question_id = question_id
        self.option_text = option_text
        self.is_correct = is_correct
        self.option_order = option_order
    
    @classmethod
    def get_by_question(cls, question_id: int) -> List['Option']:
        """Get all options for a specific question"""
        sql = "SELECT * FROM options WHERE question_id = %s ORDER BY option_order"
        results = query(sql, (question_id,))
        return [cls(**row) for row in results]
    
    @classmethod
    def get_by_id(cls, option_id: int) -> Optional['Option']:
        """Get option by ID"""
        sql = "SELECT * FROM options WHERE option_id = %s"
        result = query(sql, (option_id,))
        if result:
            return cls(**result[0])
        return None

class StudentAttempt:
    """Student attempt model for quiz results"""
    
    def __init__(self, attempt_id: int = None, user_id: int = None, 
                 lesson_id: int = None, score: int = 0, total_questions: int = 0, 
                 correct_answers: int = 0, attempt_date: datetime = None, 
                 completion_time_minutes: int = None):
        self.attempt_id = attempt_id
        self.user_id = user_id
        self.lesson_id = lesson_id
        self.score = score
        self.total_questions = total_questions
        self.correct_answers = correct_answers
        self.attempt_date = attempt_date
        self.completion_time_minutes = completion_time_minutes
    
    @classmethod
    def create(cls, user_id: int, lesson_id: int, score: int, 
               total_questions: int, correct_answers: int, 
               completion_time_minutes: int = None) -> 'StudentAttempt':
        """Create a new student attempt"""
        sql = """
        INSERT INTO student_attempts 
        (user_id, lesson_id, score, total_questions, correct_answers, completion_time_minutes)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        attempt_id = insert(sql, (user_id, lesson_id, score, total_questions, 
                                correct_answers, completion_time_minutes))
        return cls.get_by_id(attempt_id)
    
    @classmethod
    def get_by_id(cls, attempt_id: int) -> Optional['StudentAttempt']:
        """Get attempt by ID"""
        sql = "SELECT * FROM student_attempts WHERE attempt_id = %s"
        result = query(sql, (attempt_id,))
        if result:
            return cls(**result[0])
        return None
    
    @classmethod
    def get_by_user(cls, user_id: int) -> List['StudentAttempt']:
        """Get all attempts by a specific user"""
        sql = "SELECT * FROM student_attempts WHERE user_id = %s ORDER BY attempt_date DESC"
        results = query(sql, (user_id,))
        return [cls(**row) for row in results]
    
    def calculate_percentage(self) -> float:
        """Calculate percentage score"""
        if self.total_questions == 0:
            return 0.0
        return (self.correct_answers / self.total_questions) * 100
    
    def is_passing_score(self, passing_threshold: float = 70.0) -> bool:
        """Check if score meets passing threshold"""
        return self.calculate_percentage() >= passing_threshold
    
    @classmethod
    def get_performance_by_skill(cls, user_id: int) -> Dict[str, Dict[str, Any]]:
        """Get user performance breakdown by skill type"""
        sql = """
        SELECT 
            q.question_type,
            COUNT(*) as total_questions,
            SUM(CASE 
                WHEN o.is_correct = TRUE 
                AND EXISTS (
                    SELECT 1 FROM options correct_opt 
                    WHERE correct_opt.question_id = q.question_id 
                    AND correct_opt.is_correct = TRUE
                    AND correct_opt.option_id = ua.selected_option_id
                ) 
                THEN 1 ELSE 0 
            END) as correct_answers,
            AVG(sa.score) as avg_score,
            COUNT(DISTINCT sa.lesson_id) as lessons_attempted
        FROM student_attempts sa
        JOIN lessons l ON sa.lesson_id = l.lesson_id
        JOIN questions q ON l.lesson_id = q.lesson_id
        LEFT JOIN user_answers ua ON sa.attempt_id = ua.attempt_id AND q.question_id = ua.question_id
        LEFT JOIN options o ON ua.selected_option_id = o.option_id
        WHERE sa.user_id = %s
        GROUP BY q.question_type
        """
        results = query(sql, (user_id,))
        
        performance = {}
        for row in results:
            skill_type = row['question_type']
            total = row['total_questions'] or 0
            correct = row['correct_answers'] or 0
            
            performance[skill_type] = {
                'total_questions': total,
                'correct_answers': correct,
                'accuracy_percentage': (correct / total * 100) if total > 0 else 0,
                'average_score': row['avg_score'] or 0,
                'lessons_attempted': row['lessons_attempted'] or 0
            }
        
        return performance