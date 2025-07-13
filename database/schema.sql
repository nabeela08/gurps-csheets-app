-- WORDIAMO Database Schema
CREATE DATABASE IF NOT EXISTS english_learning_db;
USE english_learning_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    current_level_id INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Levels table
CREATE TABLE levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY,
    level_name VARCHAR(50) NOT NULL,
    level_description TEXT,
    level_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_level_order (level_order)
);

-- Lessons table
CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_name VARCHAR(100) NOT NULL,
    lesson_description TEXT,
    level_id INT NOT NULL,
    lesson_order INT NOT NULL,
    estimated_time_minutes INT DEFAULT 15,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (level_id) REFERENCES levels(level_id) ON DELETE CASCADE,
    INDEX idx_level_lesson (level_id, lesson_order)
);

-- Questions table
CREATE TABLE questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    question_text TEXT NOT NULL,
    lesson_id INT NOT NULL,
    question_type ENUM('vocabulary', 'grammar', 'sentence_formation', 'fill_in_blank', 'error_correction', 'reading_comprehension') DEFAULT 'vocabulary',
    difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'easy',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    INDEX idx_lesson_question (lesson_id),
    INDEX idx_question_type (question_type)
);

-- Options table
CREATE TABLE options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    option_order INT NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
    INDEX idx_question_option (question_id, option_order)
);

-- Student Attempts table
CREATE TABLE student_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    score INT NOT NULL DEFAULT 0,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL DEFAULT 0,
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_time_minutes INT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    INDEX idx_user_attempts (user_id, attempt_date),
    INDEX idx_lesson_attempts (lesson_id, attempt_date)
);

-- Add foreign key constraint for users current_level_id
ALTER TABLE users ADD CONSTRAINT fk_user_current_level 
FOREIGN KEY (current_level_id) REFERENCES levels(level_id);