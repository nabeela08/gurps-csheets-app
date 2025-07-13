# NABEELA'S FRONTEND TASKS 

## HTML Pages & User Interface
- [ ] 1. Login Page
- [ ] 2. Registration Page
- [ ] 3. Dashboard Page: Display user's level and score
- [ ] 4. Quiz Interface: Design page with questions, multiple choice options, and a timer.
- [ ] 5. Results Page: After a quiz, display detailed results showing which answers were right or wrong.
- [ ] 6. Profile Page: Allow users to view and update their profile information like name, email etc.
- [ ] 7. Navigation System: Add a navigation bar across all pages.

## Styling & Design
- [ ] 8. CSS Styling
- [ ] 9. Mobile Responsiveness
- [ ] 10. User Experience

## Frontend Logic
- [ ] 11. Frontend Scripts: Write JavaScript to handle API calls, form validation, and dynamic content updates
- [ ] 12. Form Validation: Make sure all user input (like emails, passwords, etc.) is checked on the client side before sending it to the server.
- [ ] 13. API Integration: Connect frontend to the backend using API endpoints.
- [ ] 14. Session Management: Keep track of whether the user is logged in or not.
- [ ] 15. Error Handling: Display user-friendly error messages from API responses

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