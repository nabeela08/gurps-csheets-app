"""
Content Categorization module for WORDIAMO English Learning Platform
Handles skill type classification, content organization, and analytics
"""

from typing import Dict, List, Any, Optional
from .models import Question, Lesson, Level, StudentAttempt
from .database import query

class ContentCategorization:
    """Main class for content categorization and skill analytics"""
    
    # Define skill categories with descriptions
    SKILL_CATEGORIES = {
        'vocabulary': {
            'name': 'Vocabulary',
            'description': 'Word meanings, definitions, and usage',
            'icon': '📚',
            'color': '#4F46E5'
        },
        'grammar': {
            'name': 'Grammar',
            'description': 'Sentence structure, tenses, and rules',
            'icon': '📝',
            'color': '#059669'
        },
        'reading_comprehension': {
            'name': 'Reading Comprehension',
            'description': 'Text understanding and analysis',
            'icon': '📖',
            'color': '#DC2626'
        },
        'sentence_formation': {
            'name': 'Sentence Formation',
            'description': 'Word order and sentence construction',
            'icon': '🔤',
            'color': '#7C2D12'
        },
        'fill_in_blank': {
            'name': 'Fill in the Blank',
            'description': 'Completion and context exercises',
            'icon': '✏️',
            'color': '#9333EA'
        },
        'error_correction': {
            'name': 'Error Correction',
            'description': 'Identifying and fixing mistakes',
            'icon': '🔍',
            'color': '#EA580C'
        }
    }
    
    @classmethod
    def all_categories(cls) -> Dict[str, Dict[str, Any]]:
        """Get all available skill categories with metadata"""
        return cls.SKILL_CATEGORIES
    
    @classmethod
    def category_info(cls, category_id: str) -> Optional[Dict[str, Any]]:
        """Get information for a specific category"""
        return cls.SKILL_CATEGORIES.get(category_id)
    
    @classmethod
    def content_overview(cls) -> Dict[str, Any]:
        """Get overview of all content by categories"""
        # Get question statistics by type
        question_stats = Question.type_statistics()
        
        # Get difficulty distribution
        difficulty_stats = Question.difficulty_statistics()
        
        # Get total counts
        total_questions = sum(question_stats.values())
        total_lessons = len(Lesson.all())
        total_levels = len(Level.all())
        
        # Build category overview
        categories_overview = {}
        for category_id, category_info in cls.SKILL_CATEGORIES.items():
            question_count = question_stats.get(category_id, 0)
            categories_overview[category_id] = {
                **category_info,
                'question_count': question_count,
                'percentage': (question_count / total_questions * 100) if total_questions > 0 else 0
            }
        
        return {
            'total_questions': total_questions,
            'total_lessons': total_lessons,
            'total_levels': total_levels,
            'categories': categories_overview,
            'difficulty_distribution': difficulty_stats
        }
    
    @classmethod
    def lessons_by_skill(cls, skill_type: str, level_id: Optional[int] = None) -> List[Dict[str, Any]]:
        """Get lessons that focus on a specific skill"""
        lessons = Lesson.by_skill_focus(skill_type, level_id)
        
        result = []
        for lesson in lessons:
            skill_breakdown = lesson.skill_categories()
            result.append({
                'lesson_id': lesson.lesson_id,
                'lesson_name': lesson.lesson_name,
                'lesson_description': lesson.lesson_description,
                'level_id': lesson.level_id,
                'lesson_order': lesson.lesson_order,
                'estimated_time_minutes': lesson.estimated_time_minutes,
                'skill_breakdown': skill_breakdown,
                'primary_skill': skill_type,
                'question_count': lesson.question_count()
            })
        
        return result
    
    @classmethod
    def user_skill_analysis(cls, user_id: int) -> Dict[str, Any]:
        """Get comprehensive skill analysis for a user"""
        # Get performance by skill type
        skill_performance = StudentAttempt.performance_by_skill(user_id)
        
        # Calculate overall statistics
        total_questions = sum(perf['total_questions'] for perf in skill_performance.values())
        total_correct = sum(perf['correct_answers'] for perf in skill_performance.values())
        overall_accuracy = (total_correct / total_questions * 100) if total_questions > 0 else 0
        
        # Identify strengths and weaknesses
        strengths = []
        weaknesses = []
        
        for skill_type, performance in skill_performance.items():
            accuracy = performance['accuracy_percentage']
            category_info = cls.category_info(skill_type)
            
            skill_data = {
                'skill_type': skill_type,
                'skill_name': category_info['name'] if category_info else skill_type,
                'accuracy': accuracy,
                **performance
            }
            
            if accuracy >= 80:
                strengths.append(skill_data)
            elif accuracy < 60:
                weaknesses.append(skill_data)
        
        # Sort by accuracy
        strengths.sort(key=lambda x: x['accuracy'], reverse=True)
        weaknesses.sort(key=lambda x: x['accuracy'])
        
        # Generate recommendations
        recommendations = cls._generate_recommendations(skill_performance, user_id)
        
        return {
            'user_id': user_id,
            'overall_accuracy': overall_accuracy,
            'total_questions_attempted': total_questions,
            'total_correct_answers': total_correct,
            'skill_performance': skill_performance,
            'strengths': strengths,
            'weaknesses': weaknesses,
            'recommendations': recommendations
        }
    
    @classmethod
    def _generate_recommendations(cls, skill_performance: Dict[str, Dict[str, Any]], user_id: int) -> List[Dict[str, Any]]:
        """Generate personalized learning recommendations"""
        recommendations = []
        
        for skill_type, performance in skill_performance.items():
            accuracy = performance['accuracy_percentage']
            category_info = cls.category_info(skill_type)
            
            if accuracy < 70:  # Below passing threshold
                # Find lessons for this skill type
                skill_lessons = cls.lessons_by_skill(skill_type)
                
                if skill_lessons:
                    recommendations.append({
                        'type': 'practice_skill',
                        'priority': 'high' if accuracy < 50 else 'medium',
                        'skill_type': skill_type,
                        'skill_name': category_info['name'] if category_info else skill_type,
                        'current_accuracy': accuracy,
                        'target_accuracy': 80,
                        'message': f"Focus on {category_info['name']} - current accuracy is {accuracy:.1f}%",
                        'suggested_lessons': skill_lessons[:3]  # Top 3 lessons
                    })
        
        # Add general recommendations
        if not recommendations:
            recommendations.append({
                'type': 'continue_learning',
                'priority': 'low',
                'message': 'Great progress! Continue with advanced lessons to maintain your skills.',
                'suggested_action': 'Try more challenging questions or move to the next level'
            })
        
        return recommendations
    
    @classmethod
    def level_skill_distribution(cls, level_id: int) -> Dict[str, Any]:
        """Get skill type distribution for a specific level"""
        sql = """
        SELECT 
            q.question_type,
            COUNT(*) as question_count,
            l.lesson_name,
            l.lesson_id
        FROM questions q
        JOIN lessons l ON q.lesson_id = l.lesson_id
        WHERE l.level_id = %s
        GROUP BY q.question_type, l.lesson_id, l.lesson_name
        ORDER BY l.lesson_order, q.question_type
        """
        results = query(sql, (level_id,))
        
        # Organize by skill type
        skill_distribution = {}
        lessons_by_skill = {}
        
        for row in results:
            skill_type = row['question_type']
            
            if skill_type not in skill_distribution:
                skill_distribution[skill_type] = 0
                lessons_by_skill[skill_type] = []
            
            skill_distribution[skill_type] += row['question_count']
            
            # Add lesson info if not already present
            lesson_info = {
                'lesson_id': row['lesson_id'],
                'lesson_name': row['lesson_name'],
                'question_count': row['question_count']
            }
            
            if lesson_info not in lessons_by_skill[skill_type]:
                lessons_by_skill[skill_type].append(lesson_info)
        
        # Calculate percentages
        total_questions = sum(skill_distribution.values())
        skill_percentages = {}
        
        for skill_type, count in skill_distribution.items():
            category_info = cls.category_info(skill_type)
            skill_data = {
                'skill_name': category_info['name'] if category_info else skill_type,
                'question_count': count,
                'percentage': (count / total_questions * 100) if total_questions > 0 else 0,
                'lessons': lessons_by_skill[skill_type]
            }
            
            # Add category info if available
            if category_info:
                skill_data.update(category_info)
            
            skill_percentages[skill_type] = skill_data
        
        return {
            'level_id': level_id,
            'total_questions': total_questions,
            'skill_distribution': skill_percentages
        }

# Utility functions for quick access
def categories():
    """Quick access to all categories"""
    return ContentCategorization.all_categories()

def analyze_user_skills(user_id: int):
    """Quick access to user skill analysis"""
    return ContentCategorization.user_skill_analysis(user_id)

def content_stats():
    """Quick access to content overview"""
    return ContentCategorization.content_overview()