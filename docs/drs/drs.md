# ENGLISH LEARNING PLATFORM - DATABASE SYSTEM 

## Design Requirement Specification Document

DIBRIS – Università di Genova. Scuola Politecnica, Corso di Ingegneria del Software 80154


<div align='right'> <b> Authors </b> <br> NABEELA MASROOR (S5822193) <br> ANMOL BABAR  </div>

### REVISION HISTORY

Version | Data | Author(s)| Notes
---------|------|--------|------
1 | 23/06/25 | NABEELA MASROOR <br>  | First Versionn of the document. Document Template

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
   1. ...

##  <a name="intro"></a>  1 Introduction
<details>
    <summary> The design specification document reflects the design and provides directions to the builders and coders of the product.</summary> 
    Through this document, designers communicate the design for the product to which the builders or coders must comply. The design specification should state how the design will meet the requirements.
</details>
    
### <a name="purpose"></a> 1.1 Purpose and Scope
<details> 
    <summary> This document describes the design of the database system for the English Learning Platform.  </summary>
    <p>The purpose is to guide developers and database designers in building a MySQL-based system that stores English learning content, such as quiz questions, options, and user scores. The intended audience includes developers, database administrators, and instructors involved in the project. </p>
</details>

### <a name="def"></a> 1.2 Definitions
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
    
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
    
</details>

### <a name="overview"></a> 1.3 Document Overview
<details> 
    <summary> Explain how is organized the document
    </summary>
    <p>This sub section should describe ...</p>
</details>

### <a name="biblio"></a> 1.4 Bibliography
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

## <a name="description"></a> 2 Project Description

### <a name="project-intro"></a> 2.1 Project Introduction 
<details> 
    <summary>  The goal of this project is to design and implement a database system for an English Learning Platform.
    </summary>
    <p>This system will store quizzes, questions, options, and user performance data. It will allow students to take quizzes and allow teachers to manage quiz content easily. The solution is to build a MySQL database accessed by Python scripts or applications. </p>
</details>

### <a name="tech"></a> 2.2 Technologies used

<details> 
    <summary> Description of the overall architecture. </summary>
    <p>Database: MySQL 8.0

Programming Language: Python 3.x

Library: mysql-connector-python for Python-MySQL connection

Design Tools: dbdiagram.io (or similar tool) for ER diagram    </p>
</details>

### <a name="constraints"></a> 2.3 Assumption and Constraint 
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>The system will only support English language content.

Only multiple-choice questions will be stored in this version.

No user interface (web/app) is included in this document; only the database + Python interaction is covered.

The database will be hosted on a single server. </p>
</details>

## <a name="system-overview"></a>  3 System Overview
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

### <a name="architecture"></a>  3.1 System Architecture
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>The system consists of a Python application layer that connects to a MySQL database. Users interact with the system (e.g., take quizzes) via external applications that send inputs to the Python app, which in turn queries or updates the database. </p>
</details>

### <a name="interfaces"></a>  3.2 System Interfaces
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>Python ↔ MySQL: The Python app will interact with the database using mysql-connector-python.

There is no direct external API or GUI defined at this stage. </p>
</details>

### <a name="data"></a>  3.3 System Data
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>The system stores:

Users (students and teachers)

Quizzes

Questions

Options

Student attempts and scores</p>
</details>

#### <a name="inputs"></a>  3.3.1 System Inputs
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>New user registration (username, password)

New quiz creation (quiz name, description)

New question addition (question text, options, correct answer)

Student answers during quiz attempt</p>
</details>

#### <a name="outputs"></a>  3.3.2 System Ouputs
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>List of quizzes

List of questions and options for a quiz

Quiz result (score)

Student performance history </p>
</details>

## <a name="sys-module-1"></a>  4 System Module 1
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

### <a name="sd"></a>  4.1 Structural Diagrams
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

#### <a name="cd"></a>  4.1.1 Class diagram
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

##### <a name="cd-description"></a>  4.1.1.1 Class Description
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

#### <a name="od"></a>  4.1.2 Object diagram
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>

#### <a name="dm"></a>  4.2 Dynamic Models
<details> 
    <summary> Put a summary of the section
    </summary>
    <p>This sub section should describe ...</p>
</details>
