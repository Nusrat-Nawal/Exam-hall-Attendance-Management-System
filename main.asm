.model small
.stack 100h

.data

;Title
MSG1 DB 0AH,0DH,'_____ Exam Hall Attendance System _____',0AH,0DH,'$'

;Menu
MENU_MSG DB 0AH,0DH,'1. Student Sign In',0AH,0DH,'2. View Attendance by Room',0AH,0DH,'3. View Summary by Course',0AH,0DH,'4. Delete Wrong Entry',0AH,0DH,'5. Exit',0AH,0DH,'Enter your choice: $'

;Messages
PROMPT_COURSE DB 0AH,0DH,'Select Course (1-5): $'
PROMPT_SECTION DB 0AH,0DH,'Select Section (1-5): $'
PROMPT_ROOM DB 0AH,0DH,'Select Room (1-10): $'
PROMPT_ID DB 0AH,0DH,'Enter Student ID: $'
CONFIRM_MSG DB 0AH,0DH,'Operation Completed! $'
 
;Arrays (For 100 students)
STUDENT_ID DB 100 DUP(0)
ROOM_NO DB 100 DUP(0)
COURSE_CODE DB 100 DUP(0)
SECTION_CODE    DB 100 DUP(0)
SIGNED_IN_ROOM DB 10 DUP(0)
TOTAL_SIGNED_IN DB 0

.code
main PROC
    MOV AX,@data 
    MOV DS,AX
    
    ;Print Title
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    
MAIN_MENU:
    ;Print Menu
    LEA DX,MENU_MSG
    MOV AH,09h
    INT 21h 
    
    ;Taking input choice
    MOV AH,01h
    INT 21h
    SUB AL,30h   ; Convering ASCII to number
    MOV BL,AL     ; Storing choice in BL

    CMP BL,1
    JE SIGN_IN
    CMP BL,2
    JE VIEW_ROOM
    CMP BL,3
    JE VIEW_COURSE
    CMP BL,4
    JE DELETE_ENTRY
    CMP BL,5
    JE EXIT
    JMP MAIN_MENU  

;_____Sign in section_____

SIGN_IN:
    ;Sign-In logic will be implemented here
    
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU


;_____ VIEW room part ______
VIEW_ROOM:
    ;View Attendance by Room logic here 
    
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU

;_______ View Course summary _______
VIEW_COURSE:
    ;View Summary by Course logic
    
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU


;________Deleting part_______
DELETE_ENTRY:
    ; Placeholder: Delete Wrong Entry logic
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU

;________Exit part_______
EXIT:
    MOV AH,4Ch
    INT 21h
 
 MAIN ENDP
END MAIN 