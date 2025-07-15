import mysql.connector
import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

def get_mysql_connection():
    """Get MySQL connection for setup"""
    try:
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            port=int(os.getenv('DB_PORT', 3306)),
            user=os.getenv('DB_USER', 'root'),
            password=os.getenv('DB_PASSWORD', ''),
            charset='utf8mb4'
        )
        return connection
    except mysql.connector.Error as e:
        print(f"MySQL Connection Error: {e}")
        return None

def run_sql_file(connection, file_path, ignore_table_exists=False):
    """Execute SQL file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            sql_content = file.read()
        
        statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
        
        cursor = connection.cursor(buffered=True)
        for statement in statements:
            if statement:
                try:
                    cursor.execute(statement)
                    # Consume any results to avoid "Unread result found" error
                    try:
                        cursor.fetchall()
                    except:
                        pass
                except mysql.connector.Error as e:
                    if ignore_table_exists and "already exists" in str(e):
                        print(f"  Skipping: {str(e)}")
                        continue
                    else:
                        raise e
        
        connection.commit()
        cursor.close()
        return True
        
    except Exception as e:
        print(f" SQL Execution Error: {e}")
        return False

def check_database_exists(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("SHOW DATABASES LIKE 'english_learning_db'")
        result = cursor.fetchone()
        cursor.close()
        return result is not None
    except Exception as e:
        print(f"Database Check Error: {e}")
        return False

def check_tables_exist(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("USE english_learning_db")
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        cursor.close()
        
        table_names = [table[0] for table in tables]
        required_tables = ['users', 'levels', 'lessons', 'questions', 'options', 'student_attempts']
        
        return all(table in table_names for table in required_tables)
    except Exception as e:
        print(f"Tables Check Error: {e}")
        return False

def check_data(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("USE english_learning_db")
        cursor.execute("SELECT COUNT(*) FROM levels")
        level_count = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM questions")
        question_count = cursor.fetchone()[0]
        cursor.close()
        
        return level_count > 0 and question_count > 0
    except Exception as e:
        print(f"Sample Data Check Error: {e}")
        return False

def setup_database():
    print(" WORDIAMO Database Setup")
    print("=" * 50)
    
    # Get MySQL connection
    print("1. Connecting to MySQL...")
    connection = get_mysql_connection()
    if not connection:
        return False
    print("Connected to MySQL")
    
    # Check if database exists
    print("\n2. Checking database...")
    if not check_database_exists(connection):
        print("  Database not found. Creating schema...")
        if run_sql_file(connection, 'database/schema.sql', ignore_table_exists=True):
            print("Database schema created")
        else:
            print("Failed to create schema")
            return False
    else:
        print("Database exists")
    
    # Check if tables exist
    print("\n3. Checking tables...")
    if not check_tables_exist(connection):
        print(" Tables missing. Creating schema...")
        if run_sql_file(connection, 'database/schema.sql', ignore_table_exists=True):
            print("Tables created")
        else:
            print("Failed to create tables")
            return False
    else:
        print("All tables exist")
    
    # Check if sample data exists
    print("\n4. Checking data...")
    if not check_data(connection):
        print("   data missing. Loading...")
        if run_sql_file(connection, 'database/sample_data.sql'):
            print(" data loaded")
        else:
            print("Failed to load data")
            return False
    else:
        print("Sample exists")
    
    connection.close()
    
    print("\n" + "=" * 50)
    print("DATABASE SETUP DONE")
    print("english_learning_db database ready")
    print("All tables created")
    print("Sample data loaded")
    print("=" * 50)
    
    return True

if __name__ == "__main__":
    print("WORDIAMO Database Setup")
    print("This will create the database and load data if needed")
    print()
    
    # Check if SQL files exist
    schema_file = Path('database/schema.sql')
    data_file = Path('database/sample_data.sql')
    
    if not schema_file.exists():
        print("database/schema.sql not found")
        print("Make sure you're in the project root directory")
        exit(1)
    
    if not data_file.exists():
        print("database/sample_data.sql not found")
        print("Make sure you're in the project root directory")
        exit(1)
    
    success = setup_database()
    if success:
        print("Database setup completed successfully")
    else:
        print("Database setup failed")