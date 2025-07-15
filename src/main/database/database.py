"""
Database connection module for WORDIAMO
Handles MySQL connections with pooling
"""

import mysql.connector
from mysql.connector import pooling, Error
import os
from typing import Optional, Dict, List, Any, Tuple
import logging
from contextlib import contextmanager
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DatabaseManager:
    """Database manager with connection pooling"""
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        self.config = config or self._default_config()
        self.pool = None
        self._create_connection_pool()
    
    def _default_config(self) -> Dict[str, Any]:
        """Get default database configuration"""
        return {
            'host': os.getenv('DB_HOST', 'localhost'),
            'port': int(os.getenv('DB_PORT', 3306)),
            'database': os.getenv('DB_NAME', 'english_learning_db'),
            'user': os.getenv('DB_USER', 'root'),
            'password': os.getenv('DB_PASSWORD', ''),
            'charset': 'utf8mb4',
            'use_unicode': True,
            'autocommit': True,
            'pool_name': 'wordiamo_pool',
            'pool_size': 10,
            'pool_reset_session': True
        }
    
    def _create_connection_pool(self):
        """Create MySQL connection pool"""
        try:
            self.pool = pooling.MySQLConnectionPool(**self.config)
            logger.info("Database connection pool created successfully")
        except Error as e:
            logger.error(f"Error creating connection pool: {e}")
            raise
    
    @contextmanager
    def connection(self):
        """Context manager for database connections"""
        connection = None
        try:
            connection = self.pool.get_connection()
            yield connection
        except Error as e:
            logger.error(f"Database connection error: {e}")
            if connection:
                connection.rollback()
            raise
        finally:
            if connection and connection.is_connected():
                connection.close()
    
    def execute_query(self, query: str, params: Optional[Tuple] = None) -> List[Dict[str, Any]]:
        """Execute SELECT query and return results"""
        with self.connection() as connection:
            cursor = connection.cursor(dictionary=True)
            try:
                cursor.execute(query, params or ())
                results = cursor.fetchall()
                return results
            except Error as e:
                logger.error(f"Error executing query: {e}")
                raise
            finally:
                cursor.close()
    
    def execute_insert(self, query: str, params: Optional[Tuple] = None) -> int:
        """Execute INSERT query and return last inserted ID"""
        with self.connection() as connection:
            cursor = connection.cursor()
            try:
                cursor.execute(query, params or ())
                connection.commit()
                return cursor.lastrowid
            except Error as e:
                logger.error(f"Error executing insert: {e}")
                connection.rollback()
                raise
            finally:
                cursor.close()
    
    def execute_update(self, query: str, params: Optional[Tuple] = None) -> int:
        """Execute UPDATE/DELETE query and return affected rows"""
        with self.connection() as connection:
            cursor = connection.cursor()
            try:
                cursor.execute(query, params or ())
                connection.commit()
                return cursor.rowcount
            except Error as e:
                logger.error(f"Error executing update: {e}")
                connection.rollback()
                raise
            finally:
                cursor.close()
    
    def test_connection(self) -> bool:
        """Test database connection"""
        try:
            with self.connection() as connection:
                cursor = connection.cursor()
                cursor.execute("SELECT 1")
                result = cursor.fetchone()
                cursor.close()
                return result is not None
        except Exception as e:
            logger.error(f"Database connection test failed: {e}")
            return False

# Global database manager instance
db_manager = None

def db_manager_instance() -> DatabaseManager:
    """Get global database manager instance"""
    global db_manager
    if db_manager is None:
        db_manager = DatabaseManager()
    return db_manager

def query(sql: str, params: Optional[Tuple] = None) -> List[Dict[str, Any]]:
    """Execute SELECT query"""
    return db_manager_instance().execute_query(sql, params)

def insert(sql: str, params: Optional[Tuple] = None) -> int:
    """Execute INSERT query"""
    return db_manager_instance().execute_insert(sql, params)

def update(sql: str, params: Optional[Tuple] = None) -> int:
    """Execute UPDATE/DELETE query"""
    return db_manager_instance().execute_update(sql, params)