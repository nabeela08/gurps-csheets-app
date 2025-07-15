"""Database module for WORDIAMO"""

from .database import DatabaseManager, db_manager_instance, query, insert, update

__all__ = ['DatabaseManager', 'db_manager_instance', 'query', 'insert', 'update']