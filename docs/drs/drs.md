# ENGLISH LEARNING PLATFORM - DATABASE SYSTEM 

## Design Requirement Specification Document

DIBRIS – Università di Genova. Scuola Politecnica, Corso di Ingegneria del Software 80154


<div align='right'> <b> Authors </b> <br> NABEELA MASROOR (S5822193) <br> ANMOL BABAR (S6189822) </div>

### REVISION HISTORY

Version | Data | Author(s)| Notes
---------|------|--------|------
1 | 23/06/25 | NABEELA MASROOR <br>  | Version 1.0 . Document Template
2 | 26/06/25 | NABEELA MASROOR <br>  | Version 2.0 . Document Template
3 | 09/07/25 | NABEELA MASROOR, ANMOL BABAR <br>  | Version 3.0 . Completed DRS implementation details

## Table of Content

1. [Introduction](#intro)
    1. [Purpose and Scope](#purpose)  
    2. [Definitions](#def)
    3. [Document Overview](#overview)
    4. [Bibliography](#biblio)
2. [Project Description](#description)
    1. [Project Introduction](#project-intro)
    2. [Technologies used](#tech)
    3. [Assumptions and Constraints](#constraints)
3. [System Overview](#system-overview)
    1. [System Architecture](#architecture)
    2. [System Interfaces](#interfaces)
    3. [System Data](#data)
        1. [System Inputs](#inputs)
        2. [System Outputs](#outputs)
4. [System Module 1](#sys-module-1)
    1. [Structural Diagrams](#sd)
        1. [Class Diagram](#cd)
            1. [Class Description](#cd-description)
        2. [Object Diagram](#od)
        3. [Dynamic Models](#dm)
5. [System Module 2](#sys-module-2)
    1. [Python Implementation](#python-impl)
    2. [Database Connection](#db-connection)
    3. [Core Functions](#core-functions)

##  <a name="intro"></a>  1 Introduction
<details>
    <summary> The design specification document reflects the design and provides directions to the builders and coders of the product.</summary> Through this document, designers communicate the design of the database system for the English Learning Platform. It serves as a guideline for developers and database engineers to ensure the structure supports the platform's learning logic, level progression, and student scoring. The document explains how the design fulfills the user requirements previously defined.
</details>
    
### <a name="purpose"></a> 1.1 Purpose and Scope
<details>
    <p>The purpose is to guide developers and database designers in building a MySQL-based system that stores English learning content, such as levels, lessons, quiz questions, answer options, user accounts, and student performance data. It ensures a well-structured foundation for building future learning features. The intended audience includes backend developers, database administrators, and software engineers involved in the project. </p>
</details>

### <a name="def"></a> 1.2 Definitions
<details> 
<!--     <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p> -->
    
| Term          | Definition    |
| ------------- | ------------- |
| CRUD          | Create, Read, Update, Delete – the basic operations for managing data  |
| PK            | Primary Key – a unique identifier for a table record  |
| FK            | Foreign Key – a reference to a primary key in another table  |
| ERD           | Entity-Relationship Diagram – a visual representation of the database  |
| Attempt       | A student's record of completing a lesson  |
    
</details>

### <a name="overview"></a> 1.3 Document Overview
<details> 
    <summary> This document is organized to provide comprehensive design details for the English Learning Platform
    </summary>
    <p>The document starts with an introduction and project context, then describes the system architecture and interfaces. It concludes with detailed structural diagrams including the database schema design and data relationships. Each section builds upon the previous to provide a complete technical specification.</p>
</details>

### <a name="biblio"></a> 1.4 Bibliography
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
    <ul>
        <li> MySQL 8.0 Documentation (https://dev.mysql.com/doc/) </li>
        <li> Python mysql-connector-python library </li>
       <li> dbdiagram.io tool for ERD </li> 
    </ul>
</details>

## <a name="description"></a> 2 Project Description

### <a name="project-intro"></a> 2.1 Project Introduction 
<details> 
    <summary>  The goal of this project is to design and implement a database system for an English Learning Platform.
    </summary> <p>The system enables students to learn English through level-based structured lessons. It stores various types of data: users, levels, lessons, questions, answer options, and student scores. This system ensures that students can take quizzes in a structured learning flow. Developers will use Python to interact with the database for inserting, retrieving, and evaluating data. </p>
</details>

### <a name="tech"></a> 2.2 Technologies used

<details> 
    <summary> Description of the overall architecture. </summary>
    <ul> <li> Database: MySQL 8.0 </li>
         <li> Programming Language: Python 3.x </li>
        <li> Library: mysql-connector-python </li>
        <li> Diagram Tool: dbdiagram.io (for ERD visualization) </li>
        <li> Version Control: GitHub for code and documentation tracking </li>
    </ul>
</details>

### <a name="constraints"></a> 2.3 Assumption and Constraint 
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
    <ul>
        <li>  Only multiple-choice questions are supported </li>
        <li> Content is restricted to the English language only </li>
        <li> The database is hosted locally or on a single server </li>
    </ul>
</details>

## <a name="system-overview"></a>  3 System Overview
<details> 
<!-- <!--     <summary> Put a summary of the section
    </summary>  -->
    <p> The system is designed to facilitate structured learning. Users progress through levels, each of which contains multiple lessons. Each lesson contains a set of questions with multiple-choice options. Python scripts are used to retrieve data, accept user input, and store results in the database. 
 </p>
</details>

### <a name="architecture"></a>  3.1 System Architecture
<details> 
    <summary> The architecture follows a simple three-tier model:
 <b> User → Python Application → MySQL Database </b>
    </summary>
    <p>The system consists of a Python application layer that connects to a MySQL database. The user interacts through this layer to access the quizzes and submit answers. The database is used for persistent storage of all learning data. </p>
</details>

### <a name="interfaces"></a>  3.2 System Interfaces
<details> 
    <summary> The Python application interacts with MySQL using mysql-connector-python.
    </summary>
    <p>There are no external APIs or frontend interfaces in the scope of this version. All actions like creating users, inserting questions, or retrieving quiz data occur through Python scripts. </p>
</details>

### <a name="data"></a>  3.3 System Data
<details> 
    <summary> The database contains structured information:
    </summary>
    <ul>
        <li> Levels </li> 
        <li> Lessons </li> 
        <li> Questions </li>
        <li> Options </li>
        <li> Users </li> 
        <li> StudentAttempts (scores and attempt history) </li> 
</ul>
</details>

#### <a name="inputs"></a>  3.3.1 System Inputs
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
    <ul>
        <li> User registration data (username, password, email) </li> 
        <li> Student answers during lesson attempts </li> 
        <li> User profile information (user name, current level) </li> 
        <li> Quiz attempt submissions </li>  </ul>
</details>

#### <a name="outputs"></a>  3.3.2 System Ouputs
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
    <ul>
        <li> List of available levels and lessons </li>
        <li> Quiz content (questions and answer choices) </li> 
        <li>  Calculated quiz scores</li> 
        <li> Student progress history  </li>  </ul>
</details>

## <a name="sys-module-1"></a>  4 System Module 1
<details> 
    <summary> This section provides a detailed breakdown of the database schema used to support the English learning application. 
    </summary>
    <p>It defines all core tables, their relationships, and the user data flow during quiz interaction.</p>
</details>

### <a name="sd"></a>  4.1 Structural Diagrams
<details> 
    <summary> The ERD includes the following main entities: 
    </summary>
   <ul>
       <li> Levels </li>
       <li> Lessons </li>
       <li> Questions </li>
       <li> Options </li> 
       <li> Users </li> 
       <li> StudentAttempts </li>
   </ul>
 <p> Relationships are defined using primary and foreign keys. Each level has multiple lessons. Each lesson contains multiple questions. Each question has multiple answer options. Students attempt lessons and their results are stored in the attempts table.
    </p>
</details>

#### <a name="cd"></a>  4.1.1 Class diagram

<details> 
    <summary> The complete class structure with attributes and methods: 
    </summary>
    
**Entity Classes:**
    <ul> 
        <li><strong>User</strong>
            <ul>
                <li>Attributes: user_id (PK), username, email, password_hash, current_level_id (FK), created_at, updated_at,</li>
                <li>Methods: register(), authenticate(), get_profile(), update_profile(), get_progress(), get_attempts()</li>
            </ul>
        </li>
        <li><strong>Level</strong>
            <ul>
                <li>Attributes: level_id (PK), level_name, level_description, level_order, created_at</li>
                <li>Methods: get_lessons(), get_lesson_count()</li>
            </ul>
        </li>
        <li><strong>Lesson</strong>
            <ul>
                <li>Attributes: lesson_id (PK), lesson_name, lesson_description, level_id (FK), lesson_order, estimated_time_minutes, created_at</li>
                <li>Methods: get_questions(), get_question_count(), get_attempts(), get_average_score()</li>
            </ul>
        </li>
        <li><strong>Question</strong>
            <ul>
                <li>Attributes: question_id (PK), question_text, lesson_id (FK), question_type, difficulty_level, created_at</li>
                <li>Methods: get_options(), get_correct_options(), validate_answer()</li>
            </ul>
        </li>
        <li><strong>Option</strong>
            <ul>
                <li>Attributes: option_id (PK), question_id (FK), option_text, is_correct, option_order</li>
                <li>Methods: is_answer_correct()</li>
            </ul>
        </li>
        <li><strong>StudentAttempts</strong>
            <ul>
                <li>Attributes: attempt_id (PK), user_id (FK), lesson_id (FK), score, total_questions, correct_answers, attempt_date, completion_time_minutes</li>
                <li>Methods: calculate_percentage(), is_passing_score(), get_completion_time()</li>
            </ul>
        </li>
    </ul>
        
**Relationships:**
    <ul>
        <li>User (1) → (0..*) StudentAttempts</li>
        <li>User (1) ← (0..1) Level (current_level)</li>
        <li>Level (1) → (1..*) Lesson</li>
        <li>Lesson (1) → (1..*) Question</li>
        <li>Lesson (1) → (0..*) StudentAttempts</li>
        <li>Question (1) → (2..4) Option</li>
    </ul>
</details>


##### <a name="cd-description"></a>  4.1.1.1 Class Description
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
    <ul>
    <li><em>Levels</em> – Stores level titles such as "Beginner", "A1", etc.</li>
    <li><em>Lessons</em> – Each level contains one or more lessons like "Greetings" or "Verbs"</li>
    <li><em>Questions</em> – Stores each quiz question linked to a specific lesson</li>
    <li><em>Options</em> – Multiple answer options for each question, with one or more marked correct</li>
    <li><em>Users</em> – Student accounts with secure login info</li>
    <li><em>StudentAttempts</em> – Stores each student's performance including score and attempt date</li>
  </ul>
</details>

#### <a name="od"></a>  4.1.2 Object diagram
<details> 
    <summary> This may show an example where a <b>User</b> attempts a <b>Lesson</b> that contains <b>Questions</b> with <b>Options</b> .
    </summary>
    <p>Useful for visualizing the object instances and their relationships in runtime.</p>
</details>

#### <a name="dm"></a>  4.2 Dynamic Models
<details> 
<!--     <summary> Put a summary of the section
    </summary> -->
     <ol>
    <li>User selects a level and lesson</li>
    <li>System fetches related questions and options</li>
    <li>User submits answers via Python interface</li>
    <li>System evaluates and calculates score</li>
    <li>StudentAttempt record is created and stored in the database</li>
  </ol>
</details>

## <a name="sys-module-2"></a>  5 System Module 2
<details>
    <summary>Python Implementation Details</summary>
    <p>This section describes the Python backend implementation for the English Learning Platform. The system focuses on database design with pre-loaded content and provides essential functionality through Python scripts.</p>
</details>

### <a name="python-impl"></a>  5.1 Python Implementation
<details>
    <summary>Core Python modules and project structure</summary>
    <ul>
        <li><strong>main.py</strong> - Entry point for the application</li>
        <li><strong>database.py</strong> - MySQL connection and query functions</li>
        <li><strong>auth.py</strong> - User authentication and session management</li>
        <li><strong>quiz.py</strong> - Quiz logic and score calculation</li>
        <li><strong>models.py</strong> - Data models for User, Level, Lesson, Question</li>
        <li><strong>utils.py</strong> - Helper functions and utilities</li>
    </ul>
</details>

### <a name="db-connection"></a>  5.2 Database Connection
<details>

### <a name="core-functions"></a>  5.3 Core Functions
<details>
</details>