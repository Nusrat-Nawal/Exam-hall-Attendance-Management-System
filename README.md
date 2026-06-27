# Exam-hall-Attendance-Management-System
---
An **Exam Hall Attendance Management System** developed in **Assembly Language** using **EMU8086** as part of a **Microprocessor Laboratory** course.
This project demonstrates how a conventional paper-based examination attendance process can be replaced with a simple digital attendance management system. It allows students to register their exam attendance while providing invigilators and course teachers with organized attendance records based on course, section and examination room.

## Problem Statement

In many examinations in Bangladesh, attendance is still recorded using printed attendance sheets. During an ongoing examination, invigilators pass these sheets around the classroom and every student is required to stop writing the exam to sign the sheet manually.

Although this process appears simple, it introduces several practical problems:
* Students are interrupted while taking their examination, causing unnecessary distraction and breaking their concentration.
* Manual signing consumes valuable examination time, especially in large classrooms.
* Paper attendance sheets are prone to human errors such as missing entries, duplicate signatures, or incorrect information.
* Attendance verification becomes difficult if an attendance sheet or an answer script is misplaced.

## Motivation

This project idea came from a real-life university incident where an answer script was temporarily reported missing. Before it was eventually found, one important concern arose: **how could a student prove that they had actually attended the examination?** A handwritten attendance sheet alone is not always reliable, since another person could potentially write someone else's ID or name.

This project shows how a simple microprocessor-based attendance management system can make examination attendance more organized, searchable and easier to verify while reducing dependence on traditional paper-based records.


## Features

**Student Features**

* Register attendance using:

  * Student ID
  * Batch
  * Course
  * Section
  * Examination Room
* Prevent duplicate attendance entries for the same student.
* Receive confirmation after successful attendance registration.

**Teacher / Invigilator Features**

* View all students present in a specific examination room.
* Display room-wise attendance lists.
* View course-wise attendance summaries.
* View how many students from a selected course are present in each examination room.
* Display the number of present and absent students for a room.
* Delete incorrect attendance records after confirmation.
* Search attendance records using student information.


## How System Works

1. A student selects:

   * Course
   * Section
   * Examination Room

2. The student enters:

   * Student ID
   * Batch

3. The system:

   * Stores the attendance record
   * Checks for duplicate entries
   * Rejects duplicate attendance attempts
   * Confirms successful registration

4. Teachers or invigilators can later:

   * View attendance by room
   * View course-wise attendance summaries
   * Remove incorrect attendance records if necessary


## Benefits

**For Students**

* Reduces interruptions during examinations.
* Eliminates the need for repeated manual attendance signing.
* Prevents accidental duplicate attendance entries.
* Creates a more organized attendance record that can assist during attendance verification.

**For Teachers and Invigilators**

* Instantly view attendance for any examination room.
* Monitor attendance based on individual courses.
* Analyze room-wise student distribution.
* Identify present and absent student counts quickly.
* Correct mistaken attendance entries without manually editing paper sheets.
* Reduce paperwork and simplify attendance management.


## Technologies Used

* 8086 Assembly Language
* EMU8086 Emulator
* DOS Interrupts (INT 21H)
* Buffered Keyboard Input
* Array-based Memory Management


## Data Managed

Each attendance record stores:

* Student ID
* Batch
* Course Code
* Section
* Room Number

The system maintains records for up to **100 students** in memory.


## Concepts Demonstrated

This project applies several fundamental microprocessor programming concepts, including:

* Menu-driven program design
* Array manipulation
* Buffered keyboard input
* Searching algorithms
* Duplicate detection
* Record deletion using array shifting
* Conditional branching
* Looping
* Memory management in Assembly Language


## Current Limitations

* Runs only in the EMU8086 environment.
* Data is stored only in memory and is lost after program termination.
* Supports a maximum of 100 attendance records.
* Console-based user interface.
* Designed as an educational prototype rather than a production-ready system.


## Future Improvements

* Permanent database or file storage
* Biometric verification
* Attendance report export
* Administrator authentication
* Graphical User Interface (GUI)

---

## Course Information

**Course:** Introduction to Microprocessor & Assembly Language Lab

This project was developed as a laboratory project to demonstrate practical applications of **8086 Assembly Language** by solving a real-world examination attendance management problem.


## Author
* Nusrat Jahan Nawal
* Sanzida Islam
* Nusrat Jahan Rafi

