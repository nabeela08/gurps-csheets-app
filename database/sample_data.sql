-- Data for WORDIAMO English Learning Platform
USE english_learning_db;

--  Levels
INSERT INTO levels (level_name, level_description, level_order) VALUES
('Beginner', 'Basic English fundamentals for absolute beginners', 1),
('Elementary', 'Elementary level English with basic grammar and vocabulary', 2),
('Intermediate', 'Intermediate level English with complex grammar structures', 3);

-- Lessons for Beginner Level
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Greetings and Introductions', 'Learn how to greet people and introduce yourself', 1, 1, 15),
('Basic Vocabulary - Colors', 'Learn basic color names in English', 1, 2, 10),
('Numbers 1-20', 'Learn to count from 1 to 20 in English', 1, 3, 12),
('Family Members', 'Learn vocabulary for family relationships', 1, 4, 15);

-- Lessons for Elementary Level  
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Present Simple Tense', 'Learn how to use present simple tense', 2, 1, 20),
('Days of the Week', 'Learn the seven days of the week', 2, 2, 10),
('Common Verbs', 'Learn frequently used English verbs', 2, 3, 18),
('Food and Drinks', 'Learn vocabulary for food and beverages', 2, 4, 15);

-- Lessons for Intermediate Level
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Past Tense Formation', 'Learn regular and irregular past tense forms', 3, 1, 25),
('Modal Verbs', 'Learn can, could, should, would, might, must', 3, 2, 22),
('Conditional Sentences', 'Learn if-clauses and conditional structures', 3, 3, 30),
('Business Vocabulary', 'Learn professional English vocabulary', 3, 4, 20);

--Questions for Lesson 1: Greetings and Introductions
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('What is the correct way to greet someone in the morning?', 1, 'vocabulary', 'easy'),
('How do you ask someone for their name?', 1, 'vocabulary', 'easy'),
('What is the proper response to "How are you?"', 1, 'vocabulary', 'easy'),
('How do you say goodbye formally?', 1, 'vocabulary', 'easy'),
('What does "Nice to meet you" mean?', 1, 'vocabulary', 'easy');

-- Options for Questions 1-5
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(1, 'Good morning', TRUE, 1), (1, 'Good night', FALSE, 2), (1, 'Good afternoon', FALSE, 3), (1, 'Good evening', FALSE, 4),
(2, 'What is your name?', TRUE, 1), (2, 'How old are you?', FALSE, 2), (2, 'Where are you from?', FALSE, 3), (2, 'What do you do?', FALSE, 4),
(3, 'I am fine, thank you', TRUE, 1), (3, 'I am going home', FALSE, 2), (3, 'I am 25 years old', FALSE, 3), (3, 'I am from Spain', FALSE, 4),
(4, 'Goodbye', TRUE, 1), (4, 'See you later', FALSE, 2), (4, 'Bye', FALSE, 3), (4, 'Take care', FALSE, 4),
(5, 'It is a polite way to express pleasure when meeting someone for the first time', TRUE, 1), (5, 'It means you want to meet them again', FALSE, 2), (5, 'It means you like their appearance', FALSE, 3), (5, 'It means you are happy today', FALSE, 4);

-- Questions for Lesson 2: Basic Vocabulary - Colors
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('What color do you get when you mix red and yellow?', 2, 'vocabulary', 'easy'),
('Which color is associated with the sky on a clear day?', 2, 'vocabulary', 'easy'),
('What color is grass typically?', 2, 'vocabulary', 'easy'),
('Which color is the opposite of black?', 2, 'vocabulary', 'easy'),
('What color do you get when you mix blue and yellow?', 2, 'vocabulary', 'medium');

-- Options for Color Questions (Questions 6-10)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(6, 'Orange', TRUE, 1), (6, 'Purple', FALSE, 2), (6, 'Green', FALSE, 3), (6, 'Brown', FALSE, 4),
(7, 'Blue', TRUE, 1), (7, 'Green', FALSE, 2), (7, 'Yellow', FALSE, 3), (7, 'Red', FALSE, 4),
(8, 'Green', TRUE, 1), (8, 'Blue', FALSE, 2), (8, 'Yellow', FALSE, 3), (8, 'Red', FALSE, 4),
(9, 'White', TRUE, 1), (9, 'Gray', FALSE, 2), (9, 'Yellow', FALSE, 3), (9, 'Red', FALSE, 4),
(10, 'Green', TRUE, 1), (10, 'Purple', FALSE, 2), (10, 'Orange', FALSE, 3), (10, 'Brown', FALSE, 4);

-- Questions for Lesson 5: Present Simple Tense
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('Which sentence uses present simple correctly?', 5, 'grammar', 'medium'),
('What is the correct form: "He _____ to school every day"?', 5, 'grammar', 'medium'),
('Which is correct for negative present simple?', 5, 'grammar', 'medium'),
('What is the question form of "She plays tennis"?', 5, 'grammar', 'hard'),
('Which verb form is correct: "They _____ homework every evening"?', 5, 'grammar', 'medium');

-- Options for Grammar Questions (Questions 11-15)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(11, 'I eat breakfast every morning', TRUE, 1), (11, 'I am eat breakfast every morning', FALSE, 2), (11, 'I eating breakfast every morning', FALSE, 3), (11, 'I eats breakfast every morning', FALSE, 4),
(12, 'goes', TRUE, 1), (12, 'go', FALSE, 2), (12, 'going', FALSE, 3), (12, 'gone', FALSE, 4),
(13, 'I do not like coffee', TRUE, 1), (13, 'I not like coffee', FALSE, 2), (13, 'I am not like coffee', FALSE, 3), (13, 'I don\'t liking coffee', FALSE, 4),
(14, 'Does she play tennis?', TRUE, 1), (14, 'Do she plays tennis?', FALSE, 2), (14, 'Is she play tennis?', FALSE, 3), (14, 'She plays tennis?', FALSE, 4),
(15, 'do', TRUE, 1), (15, 'does', FALSE, 2), (15, 'doing', FALSE, 3), (15, 'done', FALSE, 4);

-- Insert sample users
INSERT INTO users (username, email, password_hash, current_level_id) VALUES
('maria_garcia', 'maria@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj39/GY8ylYK', 2),
('ahmed_hassan', 'ahmed@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj39/GY8ylYK', 1);

-- Insert sample student attempts
INSERT INTO student_attempts (user_id, lesson_id, score, total_questions, correct_answers, completion_time_minutes) VALUES
(1, 1, 80, 5, 4, 12),
(1, 2, 100, 5, 5, 8),
(2, 1, 60, 5, 3, 15),
(2, 5, 75, 5, 4, 18),
(3, 1, 40, 5, 2, 20);