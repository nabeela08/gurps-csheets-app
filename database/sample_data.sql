-- Enhanced WORDIAMO Database with Multiple Levels and Lessons
-- 10+ lessons per level, 50+ questions total

USE english_learning_db;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data
DELETE FROM student_attempts;
DELETE FROM options;
DELETE FROM questions;
DELETE FROM lessons;
DELETE FROM levels;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Levels
INSERT INTO levels (level_name, level_description, level_order) VALUES
('Beginner', 'Learn basic English vocabulary and simple grammar structures', 1),
('Intermediate', 'Build on your foundation with more complex grammar and expanded vocabulary', 2),
('Advanced', 'Master advanced English concepts and sophisticated communication skills', 3);

-- Get level IDs for reference
SET @beginner_id = (SELECT level_id FROM levels WHERE level_name = 'Beginner');
SET @intermediate_id = (SELECT level_id FROM levels WHERE level_name = 'Intermediate');
SET @advanced_id = (SELECT level_id FROM levels WHERE level_name = 'Advanced');

-- Insert Lessons for Beginner Level (10 lessons)
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Basic Greetings', 'Learn how to greet people in different situations', @beginner_id, 1, 30),
('Personal Introductions', 'Introduce yourself and others', @beginner_id, 2, 35),
('Numbers 1-20', 'Learn numbers from one to twenty', @beginner_id, 3, 25),
('Days and Months', 'Master days of the week and months', @beginner_id, 4, 30),
('Colors and Shapes', 'Basic colors and simple shapes', @beginner_id, 5, 25),
('Family Members', 'Vocabulary for family relationships', @beginner_id, 6, 30),
('Food and Drinks', 'Basic food vocabulary', @beginner_id, 7, 35),
('Common Animals', 'Domestic and wild animals', @beginner_id, 8, 30),
('Body Parts', 'Learn parts of the human body', @beginner_id, 9, 30),
('Simple Present Tense', 'Basic grammar: present tense verbs', @beginner_id, 10, 40);

-- Insert Lessons for Intermediate Level (10 lessons)
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Past Tense Regular', 'Form and use regular past tense', @intermediate_id, 1, 40),
('Past Tense Irregular', 'Common irregular past tense forms', @intermediate_id, 2, 45),
('Future Tense', 'Express future plans and predictions', @intermediate_id, 3, 40),
('Present Perfect', 'Actions connecting past and present', @intermediate_id, 4, 45),
('Comparative Forms', 'Comparing two things', @intermediate_id, 5, 35),
('Modal Verbs', 'Can, could, should, must', @intermediate_id, 6, 40),
('Articles Usage', 'Proper use of a, an, the', @intermediate_id, 7, 35),
('Prepositions', 'In, on, at, by, for, with', @intermediate_id, 8, 35),
('Question Formation', 'How to form different types of questions', @intermediate_id, 9, 40),
('Passive Voice', 'Actions done to the subject', @intermediate_id, 10, 45);

-- Insert Lessons for Advanced Level (10 lessons)
INSERT INTO lessons (lesson_name, lesson_description, level_id, lesson_order, estimated_time_minutes) VALUES
('Advanced Conditionals', 'Complex conditional structures', @advanced_id, 1, 50),
('Complex Passive Voice', 'Passive in all verb tenses', @advanced_id, 2, 45),
('Advanced Modals', 'Might, ought to, would rather', @advanced_id, 3, 45),
('Reported Speech', 'Saying what someone else said', @advanced_id, 4, 50),
('Relative Clauses', 'Who, which, that in complex sentences', @advanced_id, 5, 45),
('Phrasal Verbs', 'Complex phrasal verb patterns', @advanced_id, 6, 40),
('Idioms and Expressions', 'Common English idioms', @advanced_id, 7, 40),
('Business English', 'Professional communication', @advanced_id, 8, 45),
('Academic Writing', 'Formal writing structures', @advanced_id, 9, 50),
('Advanced Grammar', 'Complex grammatical structures', @advanced_id, 10, 55);

-- Now add questions for each lesson (5-6 questions per lesson to reach 50+ total)

-- Questions for Lesson 1: Basic Greetings (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Basic Greetings' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What is the correct way to greet someone in the morning?', 'vocabulary', 'easy'),
(@lesson_id, 'Which greeting is most formal?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you say when you meet someone for the first time?', 'vocabulary', 'easy'),
(@lesson_id, 'How do you greet a friend casually?', 'vocabulary', 'easy'),
(@lesson_id, 'What is the appropriate response to "How are you?"', 'vocabulary', 'easy');

-- Add options for Basic Greetings questions
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct way to greet someone in the morning?'), 'Good morning', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct way to greet someone in the morning?'), 'Good night', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct way to greet someone in the morning?'), 'Good afternoon', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct way to greet someone in the morning?'), 'Good evening', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which greeting is most formal?'), 'Hi there!', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which greeting is most formal?'), 'Hey!', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which greeting is most formal?'), 'Good day, sir/madam', 1, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which greeting is most formal?'), 'What\'s up?', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when you meet someone for the first time?'), 'Nice to meet you', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when you meet someone for the first time?'), 'See you later', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when you meet someone for the first time?'), 'Long time no see', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when you meet someone for the first time?'), 'How have you been?', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you greet a friend casually?'), 'Good day, sir', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you greet a friend casually?'), 'Hi! What\'s up?', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you greet a friend casually?'), 'Good evening, madam', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you greet a friend casually?'), 'How do you do?', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the appropriate response to "How are you?"'), 'I\'m fine, thank you', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the appropriate response to "How are you?"'), 'Nice to meet you', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the appropriate response to "How are you?"'), 'Good morning', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the appropriate response to "How are you?"'), 'See you tomorrow', 0, 4);

-- Questions for Lesson 2: Personal Introductions (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Personal Introductions' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'How do you introduce yourself formally?', 'vocabulary', 'easy'),
(@lesson_id, 'What information should you include in a basic introduction?', 'vocabulary', 'easy'),
(@lesson_id, 'How do you ask someone\'s name politely?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you say when introducing two people?', 'vocabulary', 'easy'),
(@lesson_id, 'How do you respond when someone introduces themselves?', 'vocabulary', 'easy');

-- Add options for Personal Introductions
INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you introduce yourself formally?'), 'My name is John Smith', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you introduce yourself formally?'), 'I\'m Johnny', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you introduce yourself formally?'), 'Call me Jack', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you introduce yourself formally?'), 'Hey, I\'m John', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What information should you include in a basic introduction?'), 'Only your first name', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What information should you include in a basic introduction?'), 'Name and occupation', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What information should you include in a basic introduction?'), 'Your entire life story', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What information should you include in a basic introduction?'), 'Your personal secrets', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you ask someone\'s name politely?'), 'What\'s your name?', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you ask someone\'s name politely?'), 'May I ask your name?', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you ask someone\'s name politely?'), 'Who are you?', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you ask someone\'s name politely?'), 'Tell me your name!', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when introducing two people?'), 'This is my friend, Sarah', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when introducing two people?'), 'That\'s Sarah over there', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when introducing two people?'), 'Sarah is here', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say when introducing two people?'), 'Look, it\'s Sarah', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you respond when someone introduces themselves?'), 'So what?', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you respond when someone introduces themselves?'), 'Nice to meet you', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you respond when someone introduces themselves?'), 'I don\'t care', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you respond when someone introduces themselves?'), 'Whatever', 0, 4);

-- Add questions for a few more key lessons to reach 50+ questions total

-- Questions for Numbers 1-20 (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Numbers 1-20' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'How do you write the number 13?', 'vocabulary', 'easy'),
(@lesson_id, 'What comes after fifteen?', 'vocabulary', 'easy'),
(@lesson_id, 'How do you spell the number 8?', 'vocabulary', 'easy'),
(@lesson_id, 'What is 10 + 5?', 'vocabulary', 'easy'),
(@lesson_id, 'How do you say the number 20?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you write the number 13?'), 'thirteen', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you write the number 13?'), 'threeteen', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you write the number 13?'), 'thrteen', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you write the number 13?'), 'therteen', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What comes after fifteen?'), 'fourteen', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What comes after fifteen?'), 'sixteen', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What comes after fifteen?'), 'seventeen', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What comes after fifteen?'), 'fiveteen', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you spell the number 8?'), 'eight', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you spell the number 8?'), 'eigt', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you spell the number 8?'), 'eigth', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you spell the number 8?'), 'ate', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is 10 + 5?'), 'fourteen', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is 10 + 5?'), 'fifteen', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is 10 + 5?'), 'sixteen', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is 10 + 5?'), 'fifty', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you say the number 20?'), 'twenty', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you say the number 20?'), 'twonty', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you say the number 20?'), 'twelty', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How do you say the number 20?'), 'two ten', 0, 4);

-- Questions for Past Tense Regular (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Past Tense Regular' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What is the past tense of "walk"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "study"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "play"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "work"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "dance"?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "walk"?'), 'walk', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "walk"?'), 'walked', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "walk"?'), 'walking', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "walk"?'), 'walks', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "study"?'), 'studyed', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "study"?'), 'studied', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "study"?'), 'studying', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "study"?'), 'studies', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "play"?'), 'play', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "play"?'), 'played', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "play"?'), 'playing', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "play"?'), 'plaied', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "work"?'), 'work', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "work"?'), 'worked', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "work"?'), 'working', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "work"?'), 'works', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "dance"?'), 'dance', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "dance"?'), 'danced', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "dance"?'), 'dancing', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "dance"?'), 'danceed', 0, 4);

-- Questions for Advanced Conditionals (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Advanced Conditionals' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Complete: "If I _____ rich, I would travel the world."', 'grammar', 'hard'),
(@lesson_id, 'Which is correct? "If I had known, I _____ come earlier."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "_____ you were the president, what would you do?"', 'grammar', 'hard'),
(@lesson_id, 'Complete: "If it _____ tomorrow, we will cancel the picnic."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "I wish I _____ speak French fluently."', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'am', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'was', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'were', 1, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'will be', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'would', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'would have', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'had', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ you were the president, what would you do?"'), 'When', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ you were the president, what would you do?"'), 'If', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ you were the president, what would you do?"'), 'Because', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ you were the president, what would you do?"'), 'Since', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'rain', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'rains', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'rained', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'will rain', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'can', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'could', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'would', 0, 4);

-- Add a few more questions for other lessons to reach 50+ questions

-- Questions for Food and Drinks (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Food and Drinks' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What do you drink in the morning?', 'vocabulary', 'easy'),
(@lesson_id, 'Which is a healthy snack?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you use to eat soup?', 'vocabulary', 'easy'),
(@lesson_id, 'Which is a breakfast food?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you say before eating?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you drink in the morning?'), 'Coffee or tea', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you drink in the morning?'), 'Soup', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you drink in the morning?'), 'Rice', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you drink in the morning?'), 'Bread', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a healthy snack?'), 'Candy', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a healthy snack?'), 'Apple', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a healthy snack?'), 'Chips', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a healthy snack?'), 'Chocolate', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to eat soup?'), 'Fork', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to eat soup?'), 'Spoon', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to eat soup?'), 'Knife', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to eat soup?'), 'Hands', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a breakfast food?'), 'Pizza', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a breakfast food?'), 'Eggs', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a breakfast food?'), 'Steak', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is a breakfast food?'), 'Hamburger', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say before eating?'), 'Goodbye', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say before eating?'), 'Enjoy your meal', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say before eating?'), 'See you later', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you say before eating?'), 'Good night', 0, 4);

-- Questions for Modal Verbs (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Modal Verbs' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which modal verb expresses ability?', 'grammar', 'medium'),
(@lesson_id, 'Complete: "You _____ study harder for better grades."', 'grammar', 'medium'),
(@lesson_id, 'Which sentence shows obligation?', 'grammar', 'medium'),
(@lesson_id, 'Complete: "_____ I borrow your pen?"', 'grammar', 'medium'),
(@lesson_id, 'Which modal verb expresses possibility?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses ability?'), 'must', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses ability?'), 'can', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses ability?'), 'should', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses ability?'), 'would', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ study harder for better grades."'), 'can', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ study harder for better grades."'), 'should', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ study harder for better grades."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ study harder for better grades."'), 'could', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows obligation?'), 'I can swim', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows obligation?'), 'I must go to work', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows obligation?'), 'I might come', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows obligation?'), 'I could help', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ I borrow your pen?"'), 'Must', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ I borrow your pen?"'), 'Can', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ I borrow your pen?"'), 'Should', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ I borrow your pen?"'), 'Would', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses possibility?'), 'must', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses possibility?'), 'can', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses possibility?'), 'might', 1, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal verb expresses possibility?'), 'should', 0, 4);

-- Questions for Days and Months (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Days and Months' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which day comes after Monday?', 'vocabulary', 'easy'),
(@lesson_id, 'What is the first month of the year?', 'vocabulary', 'easy'),
(@lesson_id, 'How many days are in a week?', 'vocabulary', 'easy'),
(@lesson_id, 'Which month comes before March?', 'vocabulary', 'easy'),
(@lesson_id, 'What day is usually considered the start of the weekend?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which day comes after Monday?'), 'Sunday', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which day comes after Monday?'), 'Tuesday', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which day comes after Monday?'), 'Wednesday', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which day comes after Monday?'), 'Friday', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the first month of the year?'), 'January', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the first month of the year?'), 'February', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the first month of the year?'), 'March', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the first month of the year?'), 'December', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many days are in a week?'), 'Six', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many days are in a week?'), 'Seven', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many days are in a week?'), 'Eight', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many days are in a week?'), 'Five', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which month comes before March?'), 'January', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which month comes before March?'), 'February', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which month comes before March?'), 'April', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which month comes before March?'), 'May', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What day is usually considered the start of the weekend?'), 'Friday', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What day is usually considered the start of the weekend?'), 'Saturday', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What day is usually considered the start of the weekend?'), 'Sunday', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What day is usually considered the start of the weekend?'), 'Monday', 0, 4);

-- Questions for Colors and Shapes (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Colors and Shapes' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What color do you get when you mix red and white?', 'vocabulary', 'easy'),
(@lesson_id, 'How many sides does a triangle have?', 'vocabulary', 'easy'),
(@lesson_id, 'What is the color of the sun?', 'vocabulary', 'easy'),
(@lesson_id, 'Which shape has four equal sides?', 'vocabulary', 'easy'),
(@lesson_id, 'What color do you get when you mix blue and yellow?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix red and white?'), 'Pink', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix red and white?'), 'Purple', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix red and white?'), 'Orange', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix red and white?'), 'Brown', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many sides does a triangle have?'), 'Two', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many sides does a triangle have?'), 'Three', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many sides does a triangle have?'), 'Four', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many sides does a triangle have?'), 'Five', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the color of the sun?'), 'Red', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the color of the sun?'), 'Yellow', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the color of the sun?'), 'Blue', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the color of the sun?'), 'Green', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shape has four equal sides?'), 'Triangle', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shape has four equal sides?'), 'Square', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shape has four equal sides?'), 'Circle', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shape has four equal sides?'), 'Rectangle', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix blue and yellow?'), 'Purple', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix blue and yellow?'), 'Green', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix blue and yellow?'), 'Orange', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What color do you get when you mix blue and yellow?'), 'Red', 0, 4);

-- Questions for Family Members (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Family Members' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What do you call your father\'s brother?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you call your mother\'s mother?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you call your brother\'s son?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you call your spouse\'s father?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you call your sister\'s daughter?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your father\'s brother?'), 'Uncle', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your father\'s brother?'), 'Cousin', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your father\'s brother?'), 'Nephew', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your father\'s brother?'), 'Grandfather', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your mother\'s mother?'), 'Aunt', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your mother\'s mother?'), 'Grandmother', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your mother\'s mother?'), 'Sister', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your mother\'s mother?'), 'Cousin', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your brother\'s son?'), 'Nephew', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your brother\'s son?'), 'Niece', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your brother\'s son?'), 'Cousin', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your brother\'s son?'), 'Uncle', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your spouse\'s father?'), 'Father-in-law', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your spouse\'s father?'), 'Step-father', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your spouse\'s father?'), 'Uncle', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your spouse\'s father?'), 'Brother-in-law', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your sister\'s daughter?'), 'Niece', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your sister\'s daughter?'), 'Nephew', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your sister\'s daughter?'), 'Daughter', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you call your sister\'s daughter?'), 'Cousin', 0, 4);

-- Questions for Common Animals (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Common Animals' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which animal is known as man\'s best friend?', 'vocabulary', 'easy'),
(@lesson_id, 'What sound does a cow make?', 'vocabulary', 'easy'),
(@lesson_id, 'Which animal gives us milk?', 'vocabulary', 'easy'),
(@lesson_id, 'What do we call a baby cat?', 'vocabulary', 'easy'),
(@lesson_id, 'Which animal says "neigh"?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal is known as man\'s best friend?'), 'Dog', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal is known as man\'s best friend?'), 'Cat', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal is known as man\'s best friend?'), 'Bird', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal is known as man\'s best friend?'), 'Fish', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What sound does a cow make?'), 'Moo', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What sound does a cow make?'), 'Woof', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What sound does a cow make?'), 'Meow', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What sound does a cow make?'), 'Oink', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal gives us milk?'), 'Cow', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal gives us milk?'), 'Dog', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal gives us milk?'), 'Cat', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal gives us milk?'), 'Bird', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do we call a baby cat?'), 'Kitten', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do we call a baby cat?'), 'Puppy', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do we call a baby cat?'), 'Calf', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do we call a baby cat?'), 'Chick', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal says "neigh"?'), 'Horse', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal says "neigh"?'), 'Cow', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal says "neigh"?'), 'Pig', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which animal says "neigh"?'), 'Sheep', 0, 4);

-- Questions for Body Parts (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Body Parts' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What do you use to see?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you use to hear?', 'vocabulary', 'easy'),
(@lesson_id, 'How many fingers do you have on one hand?', 'vocabulary', 'easy'),
(@lesson_id, 'What connects your head to your body?', 'vocabulary', 'easy'),
(@lesson_id, 'What do you use to smell?', 'vocabulary', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to see?'), 'Eyes', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to see?'), 'Ears', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to see?'), 'Nose', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to see?'), 'Mouth', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to hear?'), 'Eyes', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to hear?'), 'Ears', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to hear?'), 'Nose', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to hear?'), 'Hands', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many fingers do you have on one hand?'), 'Four', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many fingers do you have on one hand?'), 'Five', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many fingers do you have on one hand?'), 'Six', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'How many fingers do you have on one hand?'), 'Ten', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What connects your head to your body?'), 'Neck', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What connects your head to your body?'), 'Arm', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What connects your head to your body?'), 'Leg', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What connects your head to your body?'), 'Hand', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to smell?'), 'Nose', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to smell?'), 'Eyes', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to smell?'), 'Ears', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What do you use to smell?'), 'Mouth', 0, 4);

-- Questions for Simple Present Tense (Beginner)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Simple Present Tense' AND level_id = @beginner_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Complete: "She _____ to school every day."', 'grammar', 'easy'),
(@lesson_id, 'Which sentence is correct?', 'grammar', 'easy'),
(@lesson_id, 'Complete: "I _____ English every morning."', 'grammar', 'easy'),
(@lesson_id, 'What is the correct form?', 'grammar', 'easy'),
(@lesson_id, 'Complete: "They _____ football on weekends."', 'grammar', 'easy');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ to school every day."'), 'go', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ to school every day."'), 'goes', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ to school every day."'), 'going', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ to school every day."'), 'went', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is correct?'), 'He play football', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is correct?'), 'He plays football', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is correct?'), 'He playing football', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is correct?'), 'He played football', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ English every morning."'), 'study', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ English every morning."'), 'studies', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ English every morning."'), 'studying', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ English every morning."'), 'studied', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct form?'), 'We eats lunch', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct form?'), 'We eat lunch', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct form?'), 'We eating lunch', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the correct form?'), 'We ate lunch', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "They _____ football on weekends."'), 'play', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "They _____ football on weekends."'), 'plays', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "They _____ football on weekends."'), 'playing', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "They _____ football on weekends."'), 'played', 0, 4);

-- Questions for Past Tense Irregular (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Past Tense Irregular' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What is the past tense of "go"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "eat"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "buy"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "think"?', 'grammar', 'medium'),
(@lesson_id, 'What is the past tense of "come"?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "go"?'), 'goed', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "go"?'), 'went', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "go"?'), 'goes', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "go"?'), 'going', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "eat"?'), 'eated', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "eat"?'), 'ate', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "eat"?'), 'eating', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "eat"?'), 'eats', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "buy"?'), 'buyed', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "buy"?'), 'bought', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "buy"?'), 'buying', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "buy"?'), 'buys', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "think"?'), 'thinked', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "think"?'), 'thought', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "think"?'), 'thinking', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "think"?'), 'thinks', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "come"?'), 'comed', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "come"?'), 'came', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "come"?'), 'coming', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What is the past tense of "come"?'), 'comes', 0, 4);

-- Questions for Advanced Conditionals (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Advanced Conditionals' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Complete: "If I _____ rich, I would travel the world."', 'grammar', 'hard'),
(@lesson_id, 'Which is correct? "If I had known, I _____ come earlier."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "If it _____ tomorrow, we will cancel the picnic."', 'grammar', 'hard'),
(@lesson_id, 'Which sentence shows third conditional?', 'grammar', 'hard'),
(@lesson_id, 'Complete: "I wish I _____ speak French fluently."', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'were', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'was', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'am', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If I _____ rich, I would travel the world."'), 'will be', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'would have', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'would', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "If I had known, I _____ come earlier."'), 'had', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'rains', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'rained', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'will rain', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "If it _____ tomorrow, we will cancel the picnic."'), 'would rain', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows third conditional?'), 'If I study, I will pass', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows third conditional?'), 'If I had studied, I would have passed', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows third conditional?'), 'If I studied, I would pass', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence shows third conditional?'), 'If I am studying, I pass', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'could', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'can', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I wish I _____ speak French fluently."'), 'would', 0, 4);

-- Questions for Lesson: Future Tense (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Future Tense' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which form expresses future intention? "I _____ visit my grandmother next week."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "The weather forecast says it _____ rain tomorrow."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct for scheduled future events?', 'grammar', 'medium'),
(@lesson_id, 'Complete: "By next year, I _____ my degree."', 'grammar', 'medium'),
(@lesson_id, 'Choose the best future form: "Don\'t worry, I _____ help you."', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which form expresses future intention? "I _____ visit my grandmother next week."'), 'am going to', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which form expresses future intention? "I _____ visit my grandmother next week."'), 'will', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which form expresses future intention? "I _____ visit my grandmother next week."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which form expresses future intention? "I _____ visit my grandmother next week."'), 'might', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather forecast says it _____ rain tomorrow."'), 'will', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather forecast says it _____ rain tomorrow."'), 'is going to', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather forecast says it _____ rain tomorrow."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather forecast says it _____ rain tomorrow."'), 'might', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct for scheduled future events?'), 'The train will leave at 3 PM', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct for scheduled future events?'), 'The train leaves at 3 PM', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct for scheduled future events?'), 'The train is going to leave at 3 PM', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct for scheduled future events?'), 'The train would leave at 3 PM', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "By next year, I _____ my degree."'), 'will have finished', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "By next year, I _____ my degree."'), 'will finish', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "By next year, I _____ my degree."'), 'am going to finish', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "By next year, I _____ my degree."'), 'would finish', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the best future form: "Don\'t worry, I _____ help you."'), 'will', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the best future form: "Don\'t worry, I _____ help you."'), 'am going to', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the best future form: "Don\'t worry, I _____ help you."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the best future form: "Don\'t worry, I _____ help you."'), 'might', 0, 4);

-- Questions for Lesson: Present Perfect (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Present Perfect' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Complete: "I _____ never _____ to Japan."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct? "She _____ here for five years."', 'grammar', 'medium'),
(@lesson_id, 'Choose the right form: "_____ you _____ your homework yet?"', 'grammar', 'medium'),
(@lesson_id, 'Complete: "We _____ just _____ from our vacation."', 'grammar', 'medium'),
(@lesson_id, 'Which sentence uses present perfect correctly?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ never _____ to Japan."'), 'have / been', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ never _____ to Japan."'), 'had / been', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ never _____ to Japan."'), 'was / been', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I _____ never _____ to Japan."'), 'will / be', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She _____ here for five years."'), 'has lived', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She _____ here for five years."'), 'lived', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She _____ here for five years."'), 'lives', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She _____ here for five years."'), 'will live', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "_____ you _____ your homework yet?"'), 'Have / finished', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "_____ you _____ your homework yet?"'), 'Did / finish', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "_____ you _____ your homework yet?"'), 'Are / finishing', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "_____ you _____ your homework yet?"'), 'Will / finish', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We _____ just _____ from our vacation."'), 'have / returned', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We _____ just _____ from our vacation."'), 'had / returned', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We _____ just _____ from our vacation."'), 'are / returning', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We _____ just _____ from our vacation."'), 'will / return', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses present perfect correctly?'), 'I have seen that movie yesterday', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses present perfect correctly?'), 'I have seen that movie', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses present perfect correctly?'), 'I saw that movie already', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses present perfect correctly?'), 'I will see that movie', 0, 4);

-- Questions for Lesson: Comparative Forms (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Comparative Forms' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which is the correct comparative form of "good"?', 'grammar', 'medium'),
(@lesson_id, 'Complete: "This book is _____ than the one I read yesterday."', 'grammar', 'medium'),
(@lesson_id, 'Choose the superlative form: "Mount Everest is _____ mountain in the world."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct? "She is _____ her sister."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "The weather today is _____ than yesterday."', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct comparative form of "good"?'), 'better', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct comparative form of "good"?'), 'gooder', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct comparative form of "good"?'), 'more good', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct comparative form of "good"?'), 'best', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "This book is _____ than the one I read yesterday."'), 'more interesting', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "This book is _____ than the one I read yesterday."'), 'most interesting', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "This book is _____ than the one I read yesterday."'), 'interestinger', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "This book is _____ than the one I read yesterday."'), 'interesting', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the superlative form: "Mount Everest is _____ mountain in the world."'), 'the highest', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the superlative form: "Mount Everest is _____ mountain in the world."'), 'higher', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the superlative form: "Mount Everest is _____ mountain in the world."'), 'the most high', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the superlative form: "Mount Everest is _____ mountain in the world."'), 'most highest', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She is _____ her sister."'), 'taller than', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She is _____ her sister."'), 'more tall than', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She is _____ her sister."'), 'tallest than', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She is _____ her sister."'), 'the taller than', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather today is _____ than yesterday."'), 'worse', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather today is _____ than yesterday."'), 'more bad', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather today is _____ than yesterday."'), 'badder', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The weather today is _____ than yesterday."'), 'worst', 0, 4);

-- Questions for Lesson: Articles Usage (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Articles Usage' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Choose the correct article: "I saw _____ elephant at _____ zoo."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct? "She plays _____ piano beautifully."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "_____ Earth revolves around _____ Sun."', 'grammar', 'medium'),
(@lesson_id, 'Choose the right form: "He is _____ doctor at _____ local hospital."', 'grammar', 'medium'),
(@lesson_id, 'Which sentence uses articles correctly?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct article: "I saw _____ elephant at _____ zoo."'), 'an / the', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct article: "I saw _____ elephant at _____ zoo."'), 'a / the', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct article: "I saw _____ elephant at _____ zoo."'), 'the / a', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct article: "I saw _____ elephant at _____ zoo."'), 'an / a', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She plays _____ piano beautifully."'), 'the', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She plays _____ piano beautifully."'), 'a', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She plays _____ piano beautifully."'), 'an', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She plays _____ piano beautifully."'), '(no article)', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ Earth revolves around _____ Sun."'), 'The / the', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ Earth revolves around _____ Sun."'), 'A / the', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ Earth revolves around _____ Sun."'), 'The / a', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ Earth revolves around _____ Sun."'), '(no article) / (no article)', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "He is _____ doctor at _____ local hospital."'), 'a / the', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "He is _____ doctor at _____ local hospital."'), 'the / a', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "He is _____ doctor at _____ local hospital."'), 'an / the', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right form: "He is _____ doctor at _____ local hospital."'), 'a / a', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses articles correctly?'), 'I love the music', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses articles correctly?'), 'I love music', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses articles correctly?'), 'I love a music', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses articles correctly?'), 'I love an music', 0, 4);

-- Questions for Lesson: Prepositions (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Prepositions' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Choose the correct preposition: "I will arrive _____ Monday _____ 3 PM."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "The book is _____ the table _____ the lamp."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct? "She has been working here _____ 2015."', 'grammar', 'medium'),
(@lesson_id, 'Choose the right preposition: "I am interested _____ learning Spanish."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "We walked _____ the park _____ get to the museum."', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct preposition: "I will arrive _____ Monday _____ 3 PM."'), 'on / at', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct preposition: "I will arrive _____ Monday _____ 3 PM."'), 'in / at', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct preposition: "I will arrive _____ Monday _____ 3 PM."'), 'at / on', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct preposition: "I will arrive _____ Monday _____ 3 PM."'), 'on / in', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book is _____ the table _____ the lamp."'), 'on / next to', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book is _____ the table _____ the lamp."'), 'in / behind', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book is _____ the table _____ the lamp."'), 'at / under', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book is _____ the table _____ the lamp."'), 'under / on', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She has been working here _____ 2015."'), 'since', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She has been working here _____ 2015."'), 'for', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She has been working here _____ 2015."'), 'from', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "She has been working here _____ 2015."'), 'at', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right preposition: "I am interested _____ learning Spanish."'), 'in', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right preposition: "I am interested _____ learning Spanish."'), 'at', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right preposition: "I am interested _____ learning Spanish."'), 'on', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right preposition: "I am interested _____ learning Spanish."'), 'for', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We walked _____ the park _____ get to the museum."'), 'through / to', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We walked _____ the park _____ get to the museum."'), 'in / for', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We walked _____ the park _____ get to the museum."'), 'at / in', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We walked _____ the park _____ get to the museum."'), 'on / at', 0, 4);

-- Questions for Lesson: Question Formation (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Question Formation' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which is the correct question form? "_____ you like coffee?"', 'grammar', 'medium'),
(@lesson_id, 'Complete: "_____ are you going to the party?"', 'grammar', 'medium'),
(@lesson_id, 'Choose the right tag question: "You can drive, _____?"', 'grammar', 'medium'),
(@lesson_id, 'Which is correct? "_____ time does the movie start?"', 'grammar', 'medium'),
(@lesson_id, 'Complete: "_____ has been to Paris before?"', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct question form? "_____ you like coffee?"'), 'Do', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct question form? "_____ you like coffee?"'), 'Are', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct question form? "_____ you like coffee?"'), 'Will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the correct question form? "_____ you like coffee?"'), 'Did', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ are you going to the party?"'), 'When', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ are you going to the party?"'), 'What', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ are you going to the party?"'), 'How', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ are you going to the party?"'), 'Why', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right tag question: "You can drive, _____?"'), 'can\'t you', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right tag question: "You can drive, _____?"'), 'can you', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right tag question: "You can drive, _____?"'), 'do you', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right tag question: "You can drive, _____?"'), 'don\'t you', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "_____ time does the movie start?"'), 'What', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "_____ time does the movie start?"'), 'When', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "_____ time does the movie start?"'), 'Where', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "_____ time does the movie start?"'), 'How', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ has been to Paris before?"'), 'Who', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ has been to Paris before?"'), 'What', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ has been to Paris before?"'), 'When', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ has been to Paris before?"'), 'Where', 0, 4);

-- Questions for Lesson: Passive Voice (Intermediate)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Passive Voice' AND level_id = @intermediate_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Choose the passive form: "The chef cooks the meal."', 'grammar', 'medium'),
(@lesson_id, 'Which is correct passive voice? "The book _____ by millions of people."', 'grammar', 'medium'),
(@lesson_id, 'Complete: "The house _____ built in 1950."', 'grammar', 'medium'),
(@lesson_id, 'Choose the active form: "The window was broken by the children."', 'grammar', 'medium'),
(@lesson_id, 'Which sentence is in passive voice?', 'grammar', 'medium');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "The chef cooks the meal."'), 'The meal is cooked by the chef', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "The chef cooks the meal."'), 'The meal was cooked by the chef', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "The chef cooks the meal."'), 'The chef is cooking the meal', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "The chef cooks the meal."'), 'The meal will be cooked by the chef', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct passive voice? "The book _____ by millions of people."'), 'is read', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct passive voice? "The book _____ by millions of people."'), 'reads', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct passive voice? "The book _____ by millions of people."'), 'reading', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct passive voice? "The book _____ by millions of people."'), 'read', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The house _____ built in 1950."'), 'was', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The house _____ built in 1950."'), 'is', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The house _____ built in 1950."'), 'has', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The house _____ built in 1950."'), 'will be', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the active form: "The window was broken by the children."'), 'The children broke the window', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the active form: "The window was broken by the children."'), 'The children are breaking the window', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the active form: "The window was broken by the children."'), 'The children have broken the window', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the active form: "The window was broken by the children."'), 'The children will break the window', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is in passive voice?'), 'She sings beautifully', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is in passive voice?'), 'The song is sung beautifully', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is in passive voice?'), 'She is singing a song', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence is in passive voice?'), 'She will sing tomorrow', 0, 4);

-- Questions for Lesson: Complex Passive Voice (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Complex Passive Voice' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Transform to passive: "They should have completed the project by now."', 'grammar', 'hard'),
(@lesson_id, 'Which is correct? "The report _____ being written when I arrived."', 'grammar', 'hard'),
(@lesson_id, 'Choose the passive form: "Someone must have stolen my bicycle."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "The new policy _____ by the board next week."', 'grammar', 'hard'),
(@lesson_id, 'Which passive form shows continuous action in the past?', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform to passive: "They should have completed the project by now."'), 'The project should have been completed by now', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform to passive: "They should have completed the project by now."'), 'The project should be completed by now', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform to passive: "They should have completed the project by now."'), 'The project has been completed by now', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform to passive: "They should have completed the project by now."'), 'The project was completed by now', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The report _____ being written when I arrived."'), 'was', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The report _____ being written when I arrived."'), 'is', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The report _____ being written when I arrived."'), 'has been', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The report _____ being written when I arrived."'), 'will be', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "Someone must have stolen my bicycle."'), 'My bicycle must have been stolen', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "Someone must have stolen my bicycle."'), 'My bicycle must be stolen', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "Someone must have stolen my bicycle."'), 'My bicycle was stolen', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the passive form: "Someone must have stolen my bicycle."'), 'My bicycle has been stolen', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The new policy _____ by the board next week."'), 'will be discussed', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The new policy _____ by the board next week."'), 'is discussed', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The new policy _____ by the board next week."'), 'was discussed', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The new policy _____ by the board next week."'), 'has been discussed', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which passive form shows continuous action in the past?'), 'The bridge was being built', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which passive form shows continuous action in the past?'), 'The bridge was built', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which passive form shows continuous action in the past?'), 'The bridge has been built', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which passive form shows continuous action in the past?'), 'The bridge will be built', 0, 4);

-- Questions for Lesson: Advanced Modals (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Advanced Modals' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which modal expresses regret? "I _____ have studied harder."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "You _____ to see a doctor about that cough."', 'grammar', 'hard'),
(@lesson_id, 'Choose the correct modal: "_____ you mind opening the window?"', 'grammar', 'hard'),
(@lesson_id, 'Which is most polite? "_____ I use your phone?"', 'grammar', 'hard'),
(@lesson_id, 'Complete: "She _____ have arrived by now, but I don\'t see her."', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal expresses regret? "I _____ have studied harder."'), 'should', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal expresses regret? "I _____ have studied harder."'), 'could', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal expresses regret? "I _____ have studied harder."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which modal expresses regret? "I _____ have studied harder."'), 'might', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ to see a doctor about that cough."'), 'ought', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ to see a doctor about that cough."'), 'must', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ to see a doctor about that cough."'), 'would', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "You _____ to see a doctor about that cough."'), 'might', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct modal: "_____ you mind opening the window?"'), 'Would', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct modal: "_____ you mind opening the window?"'), 'Could', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct modal: "_____ you mind opening the window?"'), 'Should', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the correct modal: "_____ you mind opening the window?"'), 'Must', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most polite? "_____ I use your phone?"'), 'Might', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most polite? "_____ I use your phone?"'), 'Can', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most polite? "_____ I use your phone?"'), 'Could', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most polite? "_____ I use your phone?"'), 'May', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ have arrived by now, but I don\'t see her."'), 'should', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ have arrived by now, but I don\'t see her."'), 'must', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ have arrived by now, but I don\'t see her."'), 'will', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She _____ have arrived by now, but I don\'t see her."'), 'would', 0, 4);

-- Questions for Lesson: Reported Speech (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Reported Speech' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Transform: "I will call you tomorrow," she said.', 'grammar', 'hard'),
(@lesson_id, 'Which is correct? He asked me _____ I was ready.', 'grammar', 'hard'),
(@lesson_id, 'Report this question: "Where do you live?"', 'grammar', 'hard'),
(@lesson_id, 'Complete: She told me that she _____ the movie the day before.', 'grammar', 'hard'),
(@lesson_id, 'Which reporting verb fits? "Please help me," she _____.', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform: "I will call you tomorrow," she said.'), 'She said she would call me the next day', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform: "I will call you tomorrow," she said.'), 'She said she will call me tomorrow', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform: "I will call you tomorrow," she said.'), 'She said I will call you tomorrow', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Transform: "I will call you tomorrow," she said.'), 'She said she would call you tomorrow', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? He asked me _____ I was ready.'), 'if', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? He asked me _____ I was ready.'), 'that', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? He asked me _____ I was ready.'), 'what', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? He asked me _____ I was ready.'), 'when', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Report this question: "Where do you live?"'), 'He asked me where I lived', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Report this question: "Where do you live?"'), 'He asked me where do I live', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Report this question: "Where do you live?"'), 'He asked me where I live', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Report this question: "Where do you live?"'), 'He asked where do you live', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: She told me that she _____ the movie the day before.'), 'had seen', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: She told me that she _____ the movie the day before.'), 'saw', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: She told me that she _____ the movie the day before.'), 'has seen', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: She told me that she _____ the movie the day before.'), 'would see', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which reporting verb fits? "Please help me," she _____.'), 'begged', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which reporting verb fits? "Please help me," she _____.'), 'said', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which reporting verb fits? "Please help me," she _____.'), 'told', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which reporting verb fits? "Please help me," she _____.'), 'asked', 0, 4);

-- Questions for Lesson: Relative Clauses (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Relative Clauses' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Complete: "The book _____ I read last week was amazing."', 'grammar', 'hard'),
(@lesson_id, 'Which is correct? "The person _____ car is red works here."', 'grammar', 'hard'),
(@lesson_id, 'Choose the right relative pronoun: "This is the place _____ I was born."', 'grammar', 'hard'),
(@lesson_id, 'Complete: "She met a man _____ wife is a famous actress."', 'grammar', 'hard'),
(@lesson_id, 'Which sentence uses a non-defining relative clause?', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book _____ I read last week was amazing."'), 'that', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book _____ I read last week was amazing."'), 'who', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book _____ I read last week was amazing."'), 'where', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The book _____ I read last week was amazing."'), 'when', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The person _____ car is red works here."'), 'whose', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The person _____ car is red works here."'), 'who', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The person _____ car is red works here."'), 'which', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is correct? "The person _____ car is red works here."'), 'that', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right relative pronoun: "This is the place _____ I was born."'), 'where', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right relative pronoun: "This is the place _____ I was born."'), 'which', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right relative pronoun: "This is the place _____ I was born."'), 'that', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Choose the right relative pronoun: "This is the place _____ I was born."'), 'when', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She met a man _____ wife is a famous actress."'), 'whose', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She met a man _____ wife is a famous actress."'), 'who', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She met a man _____ wife is a famous actress."'), 'which', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "She met a man _____ wife is a famous actress."'), 'that', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses a non-defining relative clause?'), 'The man who called you is my brother', 0, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses a non-defining relative clause?'), 'My brother, who lives in Paris, is visiting', 1, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses a non-defining relative clause?'), 'The book that I bought is interesting', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses a non-defining relative clause?'), 'People who work hard succeed', 0, 4);

-- Questions for Lesson: Phrasal Verbs (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Phrasal Verbs' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What does "put off" mean? "We had to put off the meeting."', 'vocabulary', 'hard'),
(@lesson_id, 'Complete: "I need to _____ some money for my vacation."', 'vocabulary', 'hard'),
(@lesson_id, 'Which phrasal verb means "to investigate"?', 'vocabulary', 'hard'),
(@lesson_id, 'Complete: "The plane will _____ in five minutes."', 'vocabulary', 'hard'),
(@lesson_id, 'What does "break down" mean in this context? "My car broke down."', 'vocabulary', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "put off" mean? "We had to put off the meeting."'), 'postpone', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "put off" mean? "We had to put off the meeting."'), 'cancel', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "put off" mean? "We had to put off the meeting."'), 'start', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "put off" mean? "We had to put off the meeting."'), 'attend', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I need to _____ some money for my vacation."'), 'set aside', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I need to _____ some money for my vacation."'), 'put up', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I need to _____ some money for my vacation."'), 'take off', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I need to _____ some money for my vacation."'), 'give up', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrasal verb means "to investigate"?'), 'look into', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrasal verb means "to investigate"?'), 'look up', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrasal verb means "to investigate"?'), 'look after', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrasal verb means "to investigate"?'), 'look for', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The plane will _____ in five minutes."'), 'take off', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The plane will _____ in five minutes."'), 'put off', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The plane will _____ in five minutes."'), 'set up', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The plane will _____ in five minutes."'), 'break down', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break down" mean in this context? "My car broke down."'), 'stopped working', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break down" mean in this context? "My car broke down."'), 'was stolen', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break down" mean in this context? "My car broke down."'), 'was expensive', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break down" mean in this context? "My car broke down."'), 'was fast', 0, 4);

-- Questions for Lesson: Idioms and Expressions (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Idioms and Expressions' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'What does "break the ice" mean?', 'vocabulary', 'hard'),
(@lesson_id, 'Complete the idiom: "It\'s raining cats and _____."', 'vocabulary', 'hard'),
(@lesson_id, 'What does "spill the beans" mean?', 'vocabulary', 'hard'),
(@lesson_id, 'Complete: "Don\'t count your chickens before they _____."', 'vocabulary', 'hard'),
(@lesson_id, 'What does "bite the bullet" mean?', 'vocabulary', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break the ice" mean?'), 'start a conversation', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break the ice" mean?'), 'be very cold', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break the ice" mean?'), 'make a mistake', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "break the ice" mean?'), 'end a relationship', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete the idiom: "It\'s raining cats and _____."'), 'dogs', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete the idiom: "It\'s raining cats and _____."'), 'birds', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete the idiom: "It\'s raining cats and _____."'), 'fish', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete the idiom: "It\'s raining cats and _____."'), 'mice', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "spill the beans" mean?'), 'reveal a secret', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "spill the beans" mean?'), 'make a mess', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "spill the beans" mean?'), 'cook dinner', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "spill the beans" mean?'), 'waste money', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Don\'t count your chickens before they _____."'), 'hatch', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Don\'t count your chickens before they _____."'), 'fly', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Don\'t count your chickens before they _____."'), 'run', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Don\'t count your chickens before they _____."'), 'sing', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "bite the bullet" mean?'), 'face a difficult situation', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "bite the bullet" mean?'), 'be very angry', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "bite the bullet" mean?'), 'eat something hard', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'What does "bite the bullet" mean?'), 'make a quick decision', 0, 4);

-- Questions for Lesson: Business English (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Business English' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which is most appropriate for a formal business email opening?', 'vocabulary', 'hard'),
(@lesson_id, 'Complete: "I would like to _____ a meeting for next week."', 'vocabulary', 'hard'),
(@lesson_id, 'Which phrase means "to increase profits"?', 'vocabulary', 'hard'),
(@lesson_id, 'Complete: "We need to _____ our market share."', 'vocabulary', 'hard'),
(@lesson_id, 'Which is the most professional way to end a business email?', 'vocabulary', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for a formal business email opening?'), 'Dear Mr. Smith', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for a formal business email opening?'), 'Hey there!', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for a formal business email opening?'), 'Hi buddy', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for a formal business email opening?'), 'What\'s up?', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I would like to _____ a meeting for next week."'), 'schedule', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I would like to _____ a meeting for next week."'), 'make', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I would like to _____ a meeting for next week."'), 'do', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "I would like to _____ a meeting for next week."'), 'create', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrase means "to increase profits"?'), 'boost revenue', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrase means "to increase profits"?'), 'cut costs', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrase means "to increase profits"?'), 'reduce expenses', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which phrase means "to increase profits"?'), 'minimize losses', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We need to _____ our market share."'), 'expand', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We need to _____ our market share."'), 'reduce', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We need to _____ our market share."'), 'forget', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "We need to _____ our market share."'), 'ignore', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most professional way to end a business email?'), 'Best regards', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most professional way to end a business email?'), 'See ya!', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most professional way to end a business email?'), 'Bye!', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most professional way to end a business email?'), 'Later!', 0, 4);

-- Questions for Lesson: Academic Writing (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Academic Writing' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which is most appropriate for academic writing?', 'grammar', 'hard'),
(@lesson_id, 'Complete: "The research _____ that climate change is accelerating."', 'vocabulary', 'hard'),
(@lesson_id, 'Which transition word shows contrast in academic writing?', 'grammar', 'hard'),
(@lesson_id, 'Complete: "_____ the evidence, we can conclude that..."', 'grammar', 'hard'),
(@lesson_id, 'Which is the most formal way to present an opinion?', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for academic writing?'), 'The data demonstrates significant correlations', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for academic writing?'), 'The stuff shows cool connections', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for academic writing?'), 'This proves everything perfectly', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is most appropriate for academic writing?'), 'It\'s pretty obvious that', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The research _____ that climate change is accelerating."'), 'indicates', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The research _____ that climate change is accelerating."'), 'thinks', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The research _____ that climate change is accelerating."'), 'feels', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "The research _____ that climate change is accelerating."'), 'guesses', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which transition word shows contrast in academic writing?'), 'Nevertheless', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which transition word shows contrast in academic writing?'), 'Furthermore', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which transition word shows contrast in academic writing?'), 'Moreover', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which transition word shows contrast in academic writing?'), 'Additionally', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ the evidence, we can conclude that..."'), 'Based on', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ the evidence, we can conclude that..."'), 'Looking at', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ the evidence, we can conclude that..."'), 'Checking out', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "_____ the evidence, we can conclude that..."'), 'Seeing', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most formal way to present an opinion?'), 'It is argued that', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most formal way to present an opinion?'), 'I think that', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most formal way to present an opinion?'), 'I feel like', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which is the most formal way to present an opinion?'), 'In my opinion', 0, 4);

-- Questions for Lesson: Advanced Grammar (Advanced)
SET @lesson_id = (SELECT lesson_id FROM lessons WHERE lesson_name = 'Advanced Grammar' AND level_id = @advanced_id);

INSERT INTO questions (lesson_id, question_text, question_type, difficulty_level) VALUES
(@lesson_id, 'Which sentence uses subjunctive mood correctly?', 'grammar', 'hard'),
(@lesson_id, 'Complete: "Had I known earlier, I _____ differently."', 'grammar', 'hard'),
(@lesson_id, 'Which shows correct use of inversion?', 'grammar', 'hard'),
(@lesson_id, 'Complete: "Not only _____ late, but he also forgot his presentation."', 'grammar', 'hard'),
(@lesson_id, 'Which sentence uses cleft structure correctly?', 'grammar', 'hard');

INSERT INTO options (question_id, option_text, is_correct, option_order) VALUES
-- Question 1
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses subjunctive mood correctly?'), 'I suggest that he be more careful', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses subjunctive mood correctly?'), 'I suggest that he is more careful', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses subjunctive mood correctly?'), 'I suggest that he will be more careful', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses subjunctive mood correctly?'), 'I suggest that he was more careful', 0, 4),

-- Question 2
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Had I known earlier, I _____ differently."'), 'would have acted', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Had I known earlier, I _____ differently."'), 'would act', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Had I known earlier, I _____ differently."'), 'will act', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Had I known earlier, I _____ differently."'), 'acted', 0, 4),

-- Question 3
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shows correct use of inversion?'), 'Never have I seen such beauty', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shows correct use of inversion?'), 'Never I have seen such beauty', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shows correct use of inversion?'), 'I have never seen such beauty', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which shows correct use of inversion?'), 'I never have seen such beauty', 0, 4),

-- Question 4
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Not only _____ late, but he also forgot his presentation."'), 'was he', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Not only _____ late, but he also forgot his presentation."'), 'he was', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Not only _____ late, but he also forgot his presentation."'), 'is he', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Complete: "Not only _____ late, but he also forgot his presentation."'), 'he is', 0, 4),

-- Question 5
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses cleft structure correctly?'), 'It was John who called yesterday', 1, 1),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses cleft structure correctly?'), 'John was who called yesterday', 0, 2),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses cleft structure correctly?'), 'John who called yesterday was', 0, 3),
((SELECT question_id FROM questions WHERE lesson_id = @lesson_id AND question_text = 'Which sentence uses cleft structure correctly?'), 'Was John who called yesterday', 0, 4);

-- Display summary
SELECT 
    l.level_name,
    COUNT(DISTINCT les.lesson_id) as total_lessons,
    COUNT(DISTINCT q.question_id) as total_questions
FROM levels l
LEFT JOIN lessons les ON l.level_id = les.level_id
LEFT JOIN questions q ON les.lesson_id = q.lesson_id
GROUP BY l.level_id, l.level_name
ORDER BY l.level_order;

COMMIT;