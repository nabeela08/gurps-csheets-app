
### WORDIAMO - English Learning Platform
### User Requirements Specification Document (URS)
##### DIBRIS – Università di Genova. Scuola Politecnica, Software Engineering Course 


**VERSION : 1.0**

**Authors**  
Massimo Narizzano
Nabeela Masroor
Anmol Babar

**REVISION HISTORY**

| Version    | Date        | Authors      | Notes        |
| ----------- | ----------- | ----------- | ----------- |
| 1.0 | 09-04-2025 | M. Narizzano| Starting the URS |
| 1.1 | 10-04-2025 | M. Narizzano| Adding section 2 |
| 1.2 | 26-06-2025 | Nabeela Masroor | Editing the URS |
| 1.3 | 09-07-2025 | Anmol Babar | Editing URS requirements |


# Table of Contents

1. [Introduction](#p1)
	1. [Document Scope](#sp1.1)
	2. [Definitions and Acronym](#sp1.2) 
	3. [References](#sp1.3)
2. [System Description](#p2)
	1. [Context and Motivation](#sp2.1)
	2. [Project Objectives](#sp2.2)
3. [Requirement](#p3)
	1. [Stakeholders](#sp3.1)
	2. [Functional Requirements](#sp3.2)
	3. [Non-Functional Requirements](#sp3.3)
  
  

<a name="p1"></a>

## 1. Introduction

<a name="sp1.1"></a>


### 1.1 Document Scope
The purpose of this document is to define the user requirements for a MySQL-based backend database that supports an English Learning Platform. This system will allow students to take quizzes based on levels and lessons and will store structured content including questions, options, and user scores.
<a name="sp1.2"></a>

### 1.2 Definitions and Acronym

<a name="sp1.3"></a>

| Acronym				| Definition | 
| ------------------------------------- | ----------- | 
| CRUD                                  | Create, Read, Update, Delete |
| SQL                                   | Structured Query Language |
| MCQ                                   | Multiple Choice Question |
| ERD                                   | Entity Relationship Diagram |
| PK                                    | Primary Key |
| FK                                    | Foreign Key |


### 1.3 References 

<a name="p2"></a>
- https://dev.mysql.com/doc/

- https://pypi.org/project/mysql-connector-python/

## 2. System Description
<a name="sp2.15"></a>
This document outlines the User Requirements Specification (URS) for a backend learning platform that allows users to study English by completing quizzes structured by levels and lessons. The system is designed to simplify quiz handling and student progress tracking.

### 2.1 Context and Motivation

<a name="sp2.2"></a>

The increasing need for flexible, low-cost, and accessible English language learning tools—especially for beginners and self-paced learners—has motivated the creation of this system. The platform will use a level-based structure to guide students progressively through learning stages. Each level includes several lessons, and each lesson has MCQs. The system will be used as a backend service, without frontend or UI for now.


### 2.2 Project Obectives 

<a name="p3"></a>

<ul>
	<li> Enable structured storage of English learning content using a normalized database schema </li>
	<li> Support basic CRUD operations for users, questions, options, and quiz scores </li>
	<li> Allow Python applications to interact with the database using mysql-connector-python </li>
	<li> Provide level-based progress tracking through the StudentAttempts table </li>
	<li> Ensure data consistency and scalability for future UI/frontend integration </li>
	
</ul>

## 3. Requirements

| Priorità | Significato | 
| --------------- | ----------- | 
| M | **Mandatory:**   |
| D | **Desiderable:** |
| O | **Optional:**    |
| E | **future Enhancement:** |

<a name="sp3.1"></a>
### 3.1 Stakeholders

- English Learners (students)

- Backend developers & database administrators - System maintainers

- Content will be pre-loaded in the database (no content creation interface needed)

<a name="sp3.2"></a>
### 3.2 Functional Requirements 

### 3.2.1 General Character Creation 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  The system shall allow user account creation with authentication |M|
| 2.0 |  The system shall allow storing and retrieving levels and lessons |M|
| 3.0 |  The system shall have pre-loaded questions per lesson |M|
| 4.0 |  The system shall allow multiple answer options per question |M|
| 5.0 |  The system shall mark at least one option as correct |M|
| 6.0 |  The system shall allow fetching full quiz content (questions + options) |M|
| 7.0 |  The system shall allow recording student quiz attempts and scores |M|
| 8.0 |  The system shall retrieve past scores per student |D|
| 9.0 |  The system shall authenticate users before quiz access |M|
| 10.0 | The system shall prevent access to higher levels until prerequisites are met |D|

### 3.2.2 User Profile Management 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  The system shall store user's current level |M|
| 2.0 |  The system shall track completed lesson count |M|
| 3.0 |  The system shall store preferred learning focus (grammar/vocabulary) |O|
| 4.0 |  The system shall record user registration date |M|
| 5.0 |  The system shall store user email for authentication |M|
| 6.0 |  The system shall track user's current progress status |M|
| 7.0 |  The system shall allow users to update their profile |D|
| 8.0 |  The system shall store user activity timestamps |D|

### 3.2.2 Skills Management 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  The system shall support vocabulary questions |M|
| 2.0 |  The system shall support grammar questions |M|
| 3.0 |  The system shall support sentence formation exercises |M|
| 4.0 |  The system shall support fill-in-the-blank exercises |D|
| 5.0 |  The system shall support error correction questions |D|
| 6.0 |  The system shall support reading comprehension |O|
| 7.0 |  The system shall support synonyms & antonyms |O|
| 8.0 |  The system shall support idioms |O|


### 3.2.4 Basic User Stories

**As a Student:**
- I want to register for an account so I can track my progress
- I want to take quizzes appropriate for my level so I can learn effectively
- I want to see my quiz scores so I can track my improvement
- I want to progress through levels systematically so I build knowledge properly
- I want to view available levels and lessons so I can choose what to study
- I want to retake quizzes to improve my score

**As a System:**
- The system should validate user answers and calculate scores automatically
- The system should store all user progress securely
- The system should prevent unauthorized access to lessons
- The system should have pre-loaded content (levels, lessons, questions) ready for users

<a name="sp3.3"></a>
### 3.3 Non-Functional Requirements 
 
| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 | The system should respond to queries in under 1 second |M|
| 2.0 | The system should be able to store at least 1000 users and 5000 questions |M|
| 3.0 | The database should be compatible with Python 3.x |M|
| 4.0 | Data should be securely stored and protected against injection attacks |M|
| 5.0 | The database design should allow for future web/mobile frontend integration |E|
| 6.0 | User passwords should be hashed and salted |M|
| 7.0 | The system should have basic error handling and logging |M|

### 3.4 Complete API Implementation 

**Authentication Endpoints:**
-  POST /auth/register - Create new user account with validation
-  POST /auth/login - JWT-based user authentication
-  POST /auth/logout - Secure session termination

**Content Access Endpoints:**
-  GET /levels - Get all available levels with descriptions
-  GET /levels/{level_id} - Get specific level details
- GET /levels/{level_id}/lessons - Get lessons for a specific level
-  GET /lessons/{lesson_id}/questions - Get questions with options for a lesson
-  GET /content/categories - Content categorization system
-  GET /questions/by-type/{type} - Filter questions by type (vocabulary/grammar)
-  GET /lessons/by-skill/{skill} - Filter lessons by skill type

**Quiz Functionality:**
-  POST /quiz/start - Start a new quiz session with lesson selection
-  POST /quiz/submit - Submit quiz answers with real-time scoring
-  POST /quiz/check-answer - Validate individual answers during quiz
-  GET /lesson/access-check/{id} - Check level prerequisites before quiz access

**User Management:**
-  GET /user/progress - Comprehensive progress analytics with completion percentages
-  GET /user/scores - Complete quiz history with detailed statistics
-  GET /user/profile - User profile with current level and statistics
-  PUT /user/profile - Update user profile information
-  POST /user/change-password - Secure password change functionality
-  DELETE /user/account - Account deletion capability

**Project Deliverables:**
- Complete source code repository
- Database schema and sample data
- API documentation through code
- User interface documentation
- Installation and setup instructions
- Requirements traceability documentation