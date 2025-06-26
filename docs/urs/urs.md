
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


# Table of Contents

1. [Introduction](#p1)
	1. [Document Scope](#sp1.1)
	2. [Definitios and Acronym](#sp1.2) 
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

### 1.2 Definitios and Acronym

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
- [https://en.wikipedia.org/wiki/GURPS#:~:text=The%20Generic%20Universal%20Role%20Playing,published%20by%20Steve%20Jackson%20Games.](https://dev.mysql.com/doc/

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

- Teachers or content creators 

- Developers of frontend/mobile UI (E)

- Backend developers & database administrators

<a name="sp3.2"></a>
### 3.2 Functional Requirements 

### 3.2.1 General Character Creation 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  The system shall allow user account creation with role info |M|
| 2.0 |  The system shall allow storing and retrieving levels and lessons |M|
| 3.0 |  The system shall allow insertion of new questions per lesson |M|
| 4.0 |  The system shall allow multiple answer options per question |M|
| 5.0 |  The system shall mark at least one option as correct |M|
| 6.0 |  The system shall allow fetching full quiz content (questions + options) |M|
| 7.0 |  The system shall allow recording student quiz attempts and scores |M|
| 8.0 |  The system shall retrieve past scores per student |D|

### 3.2.2 Attribute Management 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  XXXXX |M|
| 2.0 |  XXXXX |M|
| 3.0 |  XXXXX |M|
| 4.0 |  XXXXX |M|
| 5.0 |  XXXXX |M|
| 6.0 |  XXXXX |M|
| 7.0 |  XXXXX |M|
| 8.0 |  XXXXX |M|
| 9.0 |  XXXXX |M|

### 3.2.2 Skills Management 

| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 |  XXXXX |M|
| 2.0 |  XXXXX |M|
| 3.0 |  XXXXX |M|
| 4.0 |  XXXXX |M|
| 5.0 |  XXXXX |M|
| 6.0 |  XXXXX |M|
| 7.0 |  XXXXX |M|
| 8.0 |  XXXXX |M|
| 9.0 |  XXXXX |M|


<a name="sp3.3"></a>
### 3.2 Non-Functional Requirements 
 
| ID | Descrizione | Priorità |
| --------------- | ----------- | ---------- | 
| 1.0 | The system should respond to queries in under 1 second |M|
| 2.0 | The system should be able to store at least 1000 users and 5000 questions |M|
| 3.0 | The database should be compatible with Python 3.x |M|
| 4.0 | Data should be securely stored and protected against injection attacks |M|
| 5.0 | The database design should allow for future web/mobile frontend integration |E|
