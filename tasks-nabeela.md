# NABEELA'S FRONTEND TASKS 

## HTML Pages & User Interface
- [x] 1. Login Page
- [x] 2. Registration Page
- [x] 3. Dashboard Page: Display user's level and score
- [x] 4. Quiz Interface: Design page with questions, multiple choice options, and a timer.
- [x] 5. Results Page: After a quiz, display detailed results showing which answers were right or wrong.
- [x] 6. Profile Page: Allow users to view and update their profile information like name, email etc.
- [x] 7. Navigation System: Add a navigation bar across all pages.

## Styling & Design
- [x] 8. CSS Styling
- [x] 9. Mobile Responsiveness
- [x] 10. User Experience

## Frontend Logic
- [x] 11. Frontend Scripts: Write JavaScript to handle API calls, form validation, and dynamic content updates
- [x] 12. Form Validation: Make sure all user input (like emails, passwords, etc.) is checked on the client side before sending it to the server.
- [x] 13. API Integration: Connect frontend to the backend using API endpoints.
- [x] 14. Session Management: Keep track of whether the user is logged in or not.
- [x] 15. Error Handling: Display user-friendly error messages from API responses

## Testing
- [ ] 16. Frontend Tests: Test user interface components and user workflows
- [ ] 17. Cross-browser Testing: Ensure compatibility across different browsers

## API Endpoints to Integrate:
- POST /auth/register - User registration
- POST /auth/login - User login
- POST /auth/logout - User logout
- GET /levels - Get available levels
- GET /levels/{level_id}/lessons - Get lessons for level
- GET /lessons/{lesson_id}/questions - Get quiz questions
- POST /quiz/start - Start quiz session
- POST /quiz/submit - Submit quiz answers
- GET /user/progress - Get user progress
- GET /user/scores - Get score history
