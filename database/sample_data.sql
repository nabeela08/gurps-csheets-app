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

-- Fill-in-the-blank Questions for Lesson 3: Numbers 1-20
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('Fill in the blank: "I have _____ apples" (Write the number word for 5)', 3, 'fill_in_blank', 'easy'),
('Complete: "There are _____ days in a week" (Write the number word)', 3, 'fill_in_blank', 'medium'),
('Fill in: "My birthday is on the _____ of May" (Write the ordinal number for 15)', 3, 'fill_in_blank', 'hard');

-- Options for Fill-in-the-blank Questions (Questions 16-18)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(16, 'five', TRUE, 1), (16, 'fife', FALSE, 2), (16, 'fyve', FALSE, 3), (16, '5', FALSE, 4),
(17, 'seven', TRUE, 1), (17, 'sevn', FALSE, 2), (17, 'sevan', FALSE, 3), (17, '7', FALSE, 4),
(18, 'fifteenth', TRUE, 1), (18, 'fifteen', FALSE, 2), (18, 'fiveteenth', FALSE, 3), (18, '15th', FALSE, 4);

-- Error Correction Questions for Lesson 6: Days of the Week  
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('Find the error: "I will meet you in Monday morning"', 6, 'error_correction', 'medium'),
('Correct this sentence: "Yesterday was Sunday, tomorrow will be Tuesday"', 6, 'error_correction', 'hard'),
('What is wrong with: "I work from Monday to Friday everyday"?', 6, 'error_correction', 'medium');

-- Options for Error Correction Questions (Questions 19-21)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(19, 'Change "in" to "on" - "I will meet you on Monday morning"', TRUE, 1), (19, 'Change "Monday" to "monday"', FALSE, 2), (19, 'Change "morning" to "evening"', FALSE, 3), (19, 'The sentence is correct', FALSE, 4),
(20, 'Change "Tuesday" to "Monday" - "Yesterday was Sunday, tomorrow will be Monday"', TRUE, 1), (20, 'Change "Yesterday" to "Today"', FALSE, 2), (20, 'Change "Sunday" to "Saturday"', FALSE, 3), (20, 'The sentence is correct', FALSE, 4),
(21, 'Remove "everyday" - "I work from Monday to Friday"', TRUE, 1), (21, 'Change "work" to "worked"', FALSE, 2), (21, 'Change "from" to "between"', FALSE, 3), (21, 'The sentence is correct', FALSE, 4);

-- Reading Comprehension Questions for Lesson 8: Food and Drinks
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('Read: "Sarah loves Italian food. She eats pasta twice a week and pizza on Fridays. Her favorite drink is orange juice." What does Sarah eat twice a week?', 8, 'reading_comprehension', 'easy'),
('Based on the text: "The restaurant serves breakfast from 7 AM to 11 AM. Lunch is available from 12 PM to 3 PM. Dinner starts at 6 PM and ends at 10 PM." When can you order lunch?', 8, 'reading_comprehension', 'medium'),
('Read: "Coffee contains caffeine which can keep you awake. Tea has less caffeine than coffee. Herbal teas like chamomile have no caffeine and can help you sleep." Which drink is best before bedtime?', 8, 'reading_comprehension', 'hard');

-- Options for Reading Comprehension Questions (Questions 22-24)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(22, 'Pasta', TRUE, 1), (22, 'Pizza', FALSE, 2), (22, 'Orange juice', FALSE, 3), (22, 'Italian food', FALSE, 4),
(23, 'From 12 PM to 3 PM', TRUE, 1), (23, 'From 7 AM to 11 AM', FALSE, 2), (23, 'From 6 PM to 10 PM', FALSE, 3), (23, 'All day', FALSE, 4),
(24, 'Chamomile tea', TRUE, 1), (24, 'Coffee', FALSE, 2), (24, 'Regular tea', FALSE, 3), (24, 'Any herbal tea', FALSE, 4);

-- Sentence Formation Questions for Lesson 7: Common Verbs
INSERT INTO questions (question_text, lesson_id, question_type, difficulty_level) VALUES
('Arrange these words to make a correct sentence: "every / runs / morning / John / in / park / the"', 7, 'sentence_formation', 'medium'),
('Form a sentence using: "They / watch / TV / never / evening / in / the"', 7, 'sentence_formation', 'medium'),
('Create a sentence from: "always / She / homework / her / does / carefully"', 7, 'sentence_formation', 'hard');

-- Options for Sentence Formation Questions (Questions 25-27)
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
(25, 'John runs in the park every morning', TRUE, 1), (25, 'Every morning John runs in the park', FALSE, 2), (25, 'In the park John runs every morning', FALSE, 3), (25, 'Runs John in the park every morning', FALSE, 4),
(26, 'They never watch TV in the evening', TRUE, 1), (26, 'They watch never TV in the evening', FALSE, 2), (26, 'Never they watch TV in the evening', FALSE, 3), (26, 'They watch TV never in the evening', FALSE, 4),
(27, 'She always does her homework carefully', TRUE, 1), (27, 'She does always her homework carefully', FALSE, 2), (27, 'Always she does her homework carefully', FALSE, 3), (27, 'She does her homework always carefully', FALSE, 4);

-- Insert sample student attempts
INSERT INTO student_attempts (user_id, lesson_id, score, total_questions, correct_answers, completion_time_minutes) VALUES
(1, 1, 80, 5, 4, 12),
(1, 2, 100, 5, 5, 8),
(2, 1, 60, 5, 3, 15),
(2, 5, 75, 5, 4, 18),
(1, 3, 85, 3, 3, 10),
(2, 6, 70, 3, 2, 12),
(1, 8, 90, 3, 3, 15),
(2, 7, 65, 3, 2, 18);