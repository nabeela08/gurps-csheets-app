# ANMOL'S TASKS - English Learning Platform

## Database & Setup Tasks
- [x] 1. Setup the Database
- [x] 2. Designing Schema: Create 6 tables (Users, Levels, Lessons, Questions, Options, StudentAttempts) 
- [x] 3. Add Data: Insert test data (3+ levels, 10+ lessons, 50+ questions and with 4 options each)
- [x] 4. Set Project Structure: Create Python project with structured folder

## Core Backend Modules
- [x] 5. Database Module: Create a database.py file that handles connecting to the database.
- [x] 6. Data Models: Create models.py with all entity classes and their methods
- [x] 7. Authentication System: Develop an auth.py module that handles user sign-up and login. Use bcrypt for securely hashing passwords and set up session management to keep users logged in.
- [x] 8. Quiz Engine: Create quiz.py with scoring, validation, and tracking user attempts.
- [x] 9. Web Framework Setup: Setup Flask application 

## API Endpoints Implementation
- [x] 10. User Registration API: POST /auth/register with validation and password hashing
- [x] 11. User Authentication API: POST /auth/login with session token generation
- [x] 12. User Logout API: POST /auth/logout with session cleanup
- [x] 13. Levels API: GET /levels to retrieve all available learning levels
- [x] 14. Lessons API: GET /levels/{level_id}/lessons to get lessons for specific level
- [x] 15. Questions API: GET /lessons/{lesson_id}/questions to get quiz content
- [x] 16. Quiz Start API: POST /quiz/start to initialize new quiz session
- [x] 17. Quiz Submit API: POST /quiz/submit to process answers and calculate scores
- [x] 18. User Progress API: GET /user/progress to show current level and completion status
- [x] 19. Score History API: GET /user/scores to retrieve past quiz attempts

## Business Logic & Features
- [x] 20. User Profile Management: Track current level and completed lessons
- [x] 22. Different Question Types: Implement fill-in-blank and error correction exercises
- [x] 23. Content Categorization: Add skill type classification (grammar/vocabulary etc)
- [ ] 24. Progress Tracking: Implement prerequisite checking and handle how users move from one level to the next.
- [ ] 25. Quiz Retake System: Allow users to retake quizzes to improve scores
- [x] 26. Score Calculation: Implement percentage-based scoring with passing thresholds

## Security & Testing
- [x] 27. Session Management: Secure authentication with proper token handling
- [ ] 28. Input Validation: Server-side validation for all user inputs and API calls
- [x] 29. SQL Injection Prevention: Use parameterized queries throughout the application
- [ ] 30. Error Handling: Comprehensive error handling with user-friendly messages
- [ ] 31. Logging System: Implement logging for debugging and monitoring
- [ ] 32. Database Optimization: Add indexes on frequently queried fields
- [ ] 33. Unit Tests: Create comprehensive test suite for all Python modules
