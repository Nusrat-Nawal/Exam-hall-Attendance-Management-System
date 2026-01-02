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
SIGN_CONFIRM_MSG DB 0AH,0DH,'Signature Completed! $'
 
;Arrays (For 100 students)
STUDENT_ID DB 100 DUP(0)
ROOM_NO DB 100 DUP(0)
COURSE_CODE DB 100 DUP(0)
SECTION_CODE    DB 100 DUP(0)
SIGNED_IN_ROOM DB 10 DUP(0)
TOTAL_SIGNED_IN DB 0 

;User selections
USER_COURSE DB 0
USER_SECTION DB 0
USER_ROOM DB 0
USER_ID DB 0

;Display courses
COURSE_LIST DB 0AH,0DH,'1. CSE241',0AH,0DH,'2. CSE281',0AH,0DH,'3. CSE364',0AH,0DH,'4. EEE341',0AH,0DH,'5. EEE381',0AH,0DH,'$'

;Display rooms
ROOM_LIST DB 0AH,0DH,'1. Room-213',0AH,0DH,'2. Room-215',0AH,0DH,'3. Room-323',0AH,0DH,'4. Room-324',0AH,0DH,'5. Room-325',0AH,0DH,'6. Room-331',0AH,0DH,'7. Room-332',0AH,0DH,'8. Room-515',0AH,0DH,'9. Room-520',0AH,0DH,'10. Room-530',0AH,0DH,'$'

;Buffer storage for 3digit ids
ID_BUFFER DB 4       ; max 3 digits + 1 for length
ID_INPUT  DB 4 DUP(0) ; actual input storage

;Buffer storage for 1 to 10 room selection 
ROOM_BUFFER DB 3       ; 2 digits + length byte
ROOM_INPUT  DB 3 DUP(0)


.code
main PROC
    MOV AX,@data 
    MOV DS,AX
    
    ;Print Title
    LEA DX,MSG1
    MOV AH,9
    INT 21H

;----------Overall Main Menu--------     
MAIN_MENU:
   
    LEA DX,MENU_MSG  ;Print Menu
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
    
;_____Display Courses___
PRINT_COURSE_MENU:
    
    LEA DX, COURSE_LIST ;Print Course List
    MOV AH, 09h
    INT 21h
    
    LEA DX,PROMPT_COURSE
    MOV AH,09h
    INT 21h

;Input course choice
    MOV AH,01h
    INT 21h
    SUB AL,30h       ; ASCII ? number
    MOV BL,AL          ; store course in BL

    CMP BL,1
    JL PRINT_COURSE_MENU
    CMP BL,5
    JG PRINT_COURSE_MENU
    
    MOV AL, TOTAL_SIGNED_IN        ; load the byte value
    MOV AH, 0                    ; clear high byte
    MOV SI, AX                 ; now SI = TOTAL_SIGNED_IN
    MOV [COURSE_CODE + SI], AL


;___Display Sections____
PRINT_SECTION_MENU:
    LEA DX,PROMPT_SECTION
    MOV AH,09h
    INT 21h

    MOV AH,01h
    INT 21h
    SUB AL,30h
    MOV BL,AL
    CMP BL,1
    JL PRINT_SECTION_MENU
    CMP BL,5
    JG PRINT_SECTION_MENU
    
;____Store section____
    MOV AL, TOTAL_SIGNED_IN      ; get index
    MOV AH, 0                 ; zero-extend to 16-bit
    MOV SI, AX             ; SI now = index
    MOV BL, User_Section
    MOV [SECTION_CODE + SI], BL


;_____Display Rooms____

PRINT_ROOM_MENU:
 ;Print room list
    LEA DX, ROOM_LIST
    MOV AH,09h
    INT 21h

GET_ROOM_INPUT:
; Prompt user
    LEA DX,PROMPT_ROOM
    MOV AH,09h
    INT 21h


    LEA DX, ROOM_BUFFER
    MOV AH,0Ah                            ;DOS buffered input
    INT 21h

;Get length of input
    MOV CL, ROOM_BUFFER+1           ;number of characters entered
    CMP CL,1
    JL GET_ROOM_INPUT            ;must be at least 1 digit
    CMP CL,2
    JG GET_ROOM_INPUT         ;at most 2 digits
                         
;Convert first digit
    MOV AL, ROOM_BUFFER+2   ;first character typed
    SUB AL,30h
    CMP AL,1
    JL GET_ROOM_INPUT    ;reject 0 or negative
    MOV BL, AL

;If length=2, must be 10
    CMP CL,2
    JNE STORE_ROOM               ;single digit so go store
;check second digit
    MOV AL, ROOM_BUFFER+3
    SUB AL,30h
    CMP AL,0
    JNE GET_ROOM_INPUT      ;invalid, retry
    MOV BL,10           ;room number = 10

STORE_ROOM:
;store selection
    MOV USER_ROOM, BL 

; Store in array
    MOV AL, TOTAL_SIGNED_IN
    MOV AH,0
    MOV SI, AX
    MOV DL,USER_ROOM
    MOV [ROOM_NO + SI],DL
   
 
;___Enter Student ID___
   LEA DX, PROMPT_ID
   MOV AH,09h
   INT 21h

;read up to 3-digit ID
   LEA DX, ID_BUFFER
   MOV AH,0Ah               ;DOS buffered input
   INT 21h

;store input in STUDENT_ID array as string
   MOV AL, TOTAL_SIGNED_IN
   MOV AH,0
   MOV SI, AX        ;SI=index for arrays

;store first digit
   MOV AL, ID_BUFFER+1
   MOV [STUDENT_ID + SI], AL

;store second digit
   MOV AL, ID_BUFFER+2
   MOV [STUDENT_ID + SI + 1], AL

;store third digit
   MOV AL, ID_BUFFER+3
   MOV [STUDENT_ID + SI + 2], AL
    

    INC TOTAL_SIGNED_IN

;get last signed-in student index
    MOV AL, TOTAL_SIGNED_IN          ;load total signed in
    DEC AL                       ;subtract 1 to get last index
    MOV AH, 0               ;zero-extend
    MOV SI, AX          ;SI = index

;now access room array
    MOV BL, [ROOM_NO + SI]         ;BL = last room number
    DEC BL                    ;array index 0–9

;INC SIGNED_IN_ROOM[BL]
    MOV AL, TOTAL_SIGNED_IN      ;load byte from memory
    MOV AH, 0                 ;zero-extend to 16-bit
    MOV SI, AX           ;SI now holds the index
    MOV [COURSE_CODE + SI], BL


    
    LEA DX,Sign_CONFIRM_MSG
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