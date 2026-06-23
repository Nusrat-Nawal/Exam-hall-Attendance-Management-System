.model small
.stack 100h

.data

;Title
MSG1 DB 0AH,0DH,'_____ Exam Hall Attendance System _____',0AH,0DH,'$'

;Menu
MENU_MSG DB 0AH,0DH,'1. Student Sign In',0AH,0DH,'2. View Attendance by Room',0AH,0DH,'3. View Summary by Course',0AH,0DH,'4. Delete Wrong Entry',0AH,0DH,'5. Exit',0AH,0DH,'Enter your choice: $'

;Messages for Entry
PROMPT_COURSE DB 0AH,0DH,'Select Course (1-5): $'
PROMPT_SECTION DB 0AH,0DH,'Select Section (1-5): $'
PROMPT_ROOM DB 0AH,0DH,'Select Room (1-10): $'
PROMPT_ID DB 0AH,0DH,'Enter Student ID: $'
PROMPT_BATCH DB 0AH,0DH, 'Enter Your Batch: $'
CONFIRM_MSG DB 0AH,0DH,0AH,0DH,'Operation Completed!',0AH,0DH,' $' 
SIGN_CONFIRM_MSG DB 0AH,0DH,'Signature Completed!',0AH,0DH,' $' 
ID_MSG DB 0AH, 0DH,'Student ID: $'
DUPLICATE_MSG DB 0DH,0AH,'Error: Same ID and Batch already exists!$'
;Messeges for view by room
PROMT_ATTEDENCE DB 0AH, 0DH, 0AH,0DH,'ROOM ATTENDENCE : $'  
PRESENT_MSG DB 0AH, 0DH,'Student Present: $'
ABSENT_MSG DB 0AH, 0DH, 'Student Absent: $'
EMPTY_ROOM_MSG DB 0AH, 0DH , 'No student signed in this room.$'
TOTAL_MSG DB 0AH,0DH,0AH,0DH,'Total Assigned: 30 $'
NOT_FOUND_MSG DB 0DH,0AH,'Error: Student record not found!$'

CSE241_STR DB 0DH,0AH,'CSE241','$'
CSE281_STR DB 0DH,0AH,'CSE281','$'
CSE364_STR DB 0DH,0AH,'CSE364','$'
EEE341_STR DB 0DH,0AH,'EEE341','$'
EEE381_STR DB 0DH,0AH,'EEE381','$'


SECTION_LABEL DB 0DH,0AH, 'Section: $'
DELETE_CONFIRM_MSG DB 0AH,0DH,'Are you sure? (1: Yes / 2: No): $'

; Variables for Multi Digit
Thirty DB 30
TENS DB 0
ONES DB 0
 
;Arrays (For 100 students)
STUDENT_ID DB 100 DUP(0)
ROOM_NO DB 100 DUP(0)
COURSE_CODE DB 100 DUP(0)
SECTION_CODE    DB 100 DUP(0)
SIGNED_IN_ROOM DB 10 DUP(0)
TOTAL_SIGNED_IN DB 0
STUDENT_BATCH DB 100 DUP(0) 

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

;Batch storage for 1 to 100 
BATCH_BUFFER DB 3  ; 2 digit + length byte
BATCH_INPUT DB DUP(0)

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
    MOV [COURSE_CODE + SI], BL


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
   MOV BX, 3
   MUL BX
   MOV SI, AX
   
;store first digit
   MOV AL, ID_BUFFER+2
   MOV [STUDENT_ID + SI], AL

;store second digit
   MOV AL, ID_BUFFER+3
   MOV [STUDENT_ID + SI + 1], AL

;store third digit
   MOV AL, ID_BUFFER+4
   MOV [STUDENT_ID + SI + 2], AL    
   
;-------BATCH INPUT START ---------

   LEA DX,PROMPT_BATCH
   MOV AH,09h
   INT 21h 
;read up to 3-digit batch   
   LEA DX, BATCH_BUFFER
   MOV AH, 0Ah
   INT 21h
   
;store input in STUDENT_Batch array as string
  MOV CL, BATCH_BUFFER+1
  CMP CL, 2  

; first digit
    MOV AL, BATCH_BUFFER+2
    SUB AL, 30h
    CMP AL, 0
    
    
  
    MOV BL, AL
    MOV BH, 10
    MUL BH            ; AL = first_digit * 10

    ; second digit
    MOV BL, BATCH_BUFFER+3
    SUB BL, 30h
    CMP BL, 0
     

    ADD AL, BL        ; AL = batch number (00–99)

    ; store batch
    MOV AH, 0
    MOV Al, TOTAL_SIGNED_IN 
    MOV [STUDENT_BATCH + SI], AL 
    
 ; ===== DUPLICATE CHECK START =====
XOR SI, SI                 ; SI = 0

CHECK_DUP:
    MOV AL, TOTAL_SIGNED_IN
    MOV AH, 0
    CMP SI, AX

    JGE NO_DUPLICATE

    ; old ID offset = SI * 3
    MOV AX, SI
    MOV BL, 3
    MUL BL
    MOV DI, AX

    ; new ID offset = TOTAL_SIGNED_IN * 3
    MOV AL, TOTAL_SIGNED_IN
    MOV AH, 0
    MUL BL
    MOV BX, AX

    ; compare ID (3 digits)
    MOV AL, [STUDENT_ID + DI]
    CMP AL, [STUDENT_ID + BX]
    JNE NEXT

    MOV AL, [STUDENT_ID + DI + 1]
    CMP AL, [STUDENT_ID + BX + 1]
    JNE NEXT

    MOV AL, [STUDENT_ID + DI + 2]
    CMP AL, [STUDENT_ID + BX + 2]
    JNE NEXT

  ; compare Batch
    MOV AL, [STUDENT_BATCH + SI]   ; old batch
    MOV BL, TOTAL_SIGNED_IN        ; new index
    CMP AL, [STUDENT_BATCH + BX]
    JE DUPLICATE_FOUND

NEXT:
    INC SI
    JMP CHECK_DUP

DUPLICATE_FOUND:
    LEA DX, DUPLICATE_MSG
    MOV AH, 09h
    INT 21h
    JMP MAIN_MENU

NO_DUPLICATE:
; ===== DUPLICATE CHECK END =====
    
    

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

;----- Confirmation -----
LEA DX, SIGN_CONFIRM_MSG
MOV AH,09h
INT 21h
JMP MAIN_MENU


;_____ VIEW room part ______
VIEW_ROOM:
    ;View Attendance by Room logic here 
    
; Show room list
    LEA DX, ROOM_LIST
    MOV AH, 09h
    INT 21h

    ; Ask room
    LEA DX, PROMPT_ROOM
    MOV AH, 09h
    INT 21h

    LEA DX, ROOM_BUFFER        ;buffer input(1-10)
    MOV AH, 0Ah
    INT 21h

    ; Convert room (1-10)
    MOV CL, ROOM_BUFFER+1
    CMP CL, 1
    JE VR_ONE             
    CMP CL, 2
    JE VR_TWO            
    JMP MAIN_MENU

VR_ONE:
    MOV AL, ROOM_BUFFER+2   ;single digit room(1-9)
    SUB AL, 30h
    MOV USER_ROOM, AL
    JMP VR_START

VR_TWO:
    MOV AL, ROOM_BUFFER+2     ;two digit room just 10
    SUB AL, 30h
    CMP AL, 1
    
    MOV AL, ROOM_BUFFER+3
    SUB AL, 30h
    CMP AL, 0
   
    MOV USER_ROOM, 10

VR_START:
    ; Header
    LEA DX, PROMT_ATTEDENCE
    MOV AH, 09h
    INT 21h

    XOR SI, SI          ;  array index
    XOR CX, CX          ; present student  count

VR_LOOP:
    MOV AL, TOTAL_SIGNED_IN    
    MOV AH, 0
    CMP SI, AX
    JGE VR_DONE

    MOV AL, [ROOM_NO + SI]     ;
    CMP AL, USER_ROOM
    JNE VR_NEXT

    ; New line
    MOV DL, 0Dh
    MOV AH, 02h
    INT 21h
    MOV DL, 0Ah
    INT 21h

    ; Print ID 3digit
    MOV BX, SI
    ADD BX, SI
    ADD BX, SI 
    
    LEA DX, ID_MSG
    MOV AH, 09h
    INT 21h
    
    MOV DL, [STUDENT_ID + BX]
    MOV AH, 02h
    INT 21h
    MOV DL, [STUDENT_ID + BX + 1]
    INT 21h
    MOV DL, [STUDENT_ID + BX + 2]
    INT 21h


    INC CX

VR_NEXT:
    INC SI
    JMP VR_LOOP

VR_DONE:
                                    
    CMP CX, 0        ; If empty room
    JNE VR_SUMMARY

    LEA DX, EMPTY_ROOM_MSG
    MOV AH, 09h
    INT 21h
    

VR_SUMMARY:
    ; Get total assigned
    MOV AL, USER_ROOM
    DEC AL
    MOV AH, 0
    MOV SI, AX
    MOV AL, [30 + SI]
    MOV BL, AL          ; BL = assigned

    ; Print total assigned
    LEA DX, TOTAL_MSG
    MOV AH, 09h
    INT 21h
    

    ; Print present
    LEA DX, PRESENT_MSG
    MOV AH, 09h
    INT 21h 
    
    ;print total presented student count
    MOV AL, CL  
    XOR AH, AH
    MOV BL, 10
    DIV BL 
 
 
 ;multi-digit print
    
    MOV TENS, AL    ;AL store quotient  
    MOV ONES , AH         ;AH store remainder 
    
    CMP TENS,0
    JE ADD_ONE 
    MOV DL, TENS 
    ADD DL, 30H       
    MOV AH,2 
    INT 21h
    
ADD_ONE:
    MOV DL, ONES 
    ADD DL, 30H       ; print for remainder 
    MOV AH,2 
    INT 21h
    
    
; Print absent
    LEA DX, ABSENT_MSG
    MOV AH, 09h
    INT 21h 
    
;print absent student count
    MOV AL, Thirty             ;30- present studnet 
    SUB AL, CL
                         
    XOR AH,AH
    MOV BL, 10
    DIV BL
    
    MOV TENS, AL 
    MOV ONES , AH 
    
    CMP TENS,0
    JE ABS_ONE 
    MOV DL, TENS 
    ADD DL, 30H       
    MOV AH,2 
    INT 21h
    
ABS_ONE:
    MOV DL, ONES 
    ADD DL, 30H       
    MOV AH,2 
    INT 21h    
         
    
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU

;_______ View Course summary _______
VIEW_COURSE:
    ;View Summary by Course logic

    LEA DX, COURSE_LIST
    MOV AH, 09h
    INT 21h

    ; Prompt course
    LEA DX, PROMPT_COURSE
    MOV AH, 09h
    INT 21h

    ; Input course choice
    MOV AH, 01h
    INT 21h
    SUB AL, 30h
    MOV USER_COURSE, AL

    ; Clear room counters (Room 1–10)
    XOR SI, SI
CLEAR_ROOM_COUNT:
    MOV SIGNED_IN_ROOM[SI], 0
    INC SI
    CMP SI, 10
    JL CLEAR_ROOM_COUNT

    ; Initialize index and total present counter
    XOR SI, SI
    XOR BX, BX              ; BX = total present count

COURSE_LOOP:
    MOV AL, TOTAL_SIGNED_IN
    CBW
    CMP SI, AX
    JGE COURSE_DONE

    ; Check course
    MOV AL, COURSE_CODE[SI]
    CMP AL, USER_COURSE
    JNE NEXT_COURSE

    ; Increment room counter
    MOV AL, ROOM_NO[SI]     ; room number (1–10)
    DEC AL                  ; convert to 0–9
    MOV DI, AX
    INC SIGNED_IN_ROOM[DI]
    INC BX

NEXT_COURSE:
    INC SI
    JMP COURSE_LOOP

COURSE_DONE:
    XOR SI, SI              ; room index

PRINT_ROOM_SUMMARY:
    MOV AL, SIGNED_IN_ROOM[SI]
    CMP AL, 0
    JE SKIP_ROOM

    ; New line
    MOV DL, 0Dh
    MOV AH, 02h
    INT 21h
    MOV DL, 0Ah
    INT 21h

    ; Print "Room "
    MOV DL, 'R'
    MOV AH, 02h
    INT 21h
    MOV DL, 'o'
    INT 21h
    MOV DL, 'o'
    INT 21h
    MOV DL, 'm'
    INT 21h
    MOV DL, ' '
    INT 21h

    ; Room number
MOV AX, SI        ; AX = SI (16-bit safe)
INC AX            ; AX = SI + 1
ADD AL, 30h       ; convert to ASCII (AL only)
MOV DL, AL
MOV AH, 02h
INT 21h


    MOV DL, ':'
    INT 21h
    MOV DL, ' '
    INT 21h

    ; Present count
    MOV AL, SIGNED_IN_ROOM[SI]
    AAM
    MOV DL, AH
    ADD DL, 30h
    CMP DL, '0'
    JE PRINT_ONES_ONLY
    MOV AH, 02h
    INT 21h

PRINT_ONES_ONLY:
    MOV DL, AL
    ADD DL, 30h
    MOV AH, 02h
    INT 21h

SKIP_ROOM:
    INC SI
    CMP SI, 10
    JL PRINT_ROOM_SUMMARY
    
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU


;________Deleting part_______
DELETE_ENTRY:
    ; Placeholder: Delete Wrong Entry logic

LEA DX, PROMPT_ID
    MOV AH, 09h
    INT 21h
    LEA DX, ID_BUFFER
    MOV AH, 0Ah
    INT 21h

    LEA DX, PROMPT_COURSE
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    SUB AL, 30h
    MOV USER_COURSE, AL

    LEA DX, PROMPT_BATCH
    MOV AH, 09h
    INT 21h
    LEA DX, BATCH_BUFFER
    MOV AH, 0Ah
    INT 21h

    ; --- Convert input batch string to a single number ---
    MOV AL, BATCH_BUFFER+2
    SUB AL, 30h
    MOV BL, 10
    MUL BL
    MOV CL, BATCH_BUFFER+3
    SUB CL, 30h
    ADD AL, CL         
    MOV USER_BATCH, AL 

    XOR SI, SI          ; Initialize search index to 0

SEARCH_DEL:
    MOV AL, TOTAL_SIGNED_IN
    XOR AH, AH
    CMP SI, AX
    JGE NOT_FOUND_LBL   ; Changed name to avoid conflict

    ; 1. Compare Course
    MOV AL, [COURSE_CODE + SI]
    CMP AL, USER_COURSE
    JNE NEXT_DEL

    ; 2. Compare Batch
    MOV AL, [STUDENT_BATCH + SI]
    CMP AL, USER_BATCH
    JNE NEXT_DEL

    ; 3. Compare ID (3 digits)
    MOV AX, SI
    MOV BL, 3
    MUL BL
    MOV DI, AX         

    MOV AL, ID_BUFFER+2
    CMP AL, STUDENT_ID[DI]
    JNE NEXT_DEL
    MOV AL, ID_BUFFER+3
    CMP AL, STUDENT_ID[DI+1]
    JNE NEXT_DEL
    MOV AL, ID_BUFFER+4
    CMP AL, STUDENT_ID[DI+2]
    JNE NEXT_DEL

    JMP FOUND_DEL_LBL

NEXT_DEL:
    INC SI
    JMP SEARCH_DEL


FOUND_DEL_LBL:

; -------- SHOW COURSE --------
CMP USER_COURSE, 1
JE D_CSE241
CMP USER_COURSE, 2
JE D_CSE281
CMP USER_COURSE, 3
JE D_CSE364
CMP USER_COURSE, 4
JE D_EEE341
CMP USER_COURSE, 5
JE D_EEE381

D_CSE241:
    LEA DX, CSE241_STR
    JMP PRINT_D_COURSE

D_CSE281:
    LEA DX, CSE281_STR
    JMP PRINT_D_COURSE

D_CSE364:
    LEA DX, CSE364_STR
    JMP PRINT_D_COURSE

D_EEE341:
    LEA DX, EEE341_STR
    JMP PRINT_D_COURSE

D_EEE381:
    LEA DX, EEE381_STR
    JMP PRINT_D_COURSE

PRINT_D_COURSE:
    MOV AH, 09h
    INT 21h



; -------- SHOW SECTION --------
LEA DX, SECTION_LABEL
MOV AH, 09h
INT 21h

MOV AL, SECTION_CODE[SI]
ADD AL, 30h
MOV DL, AL
MOV AH, 02h
INT 21h

; -------- CONFIRM DELETE --------
LEA DX, DELETE_CONFIRM_MSG
MOV AH, 09h
INT 21h

MOV AH, 01h
INT 21h
SUB AL, 30h

CMP AL, 1
JE CANCEL_DELETE     ; YES ? stay

CMP AL, 2
JE DO_DELETE         ; NO ? delete

JMP MAIN_MENU

CANCEL_DELETE:
    LEA DX,CONFIRM_MSG
    MOV AH,09h
    INT 21h
    JMP MAIN_MENU

DO_DELETE:
    JMP SHIFT_LOOP

    
SHIFT_LOOP:
    MOV AL, TOTAL_SIGNED_IN
    DEC AL
    XOR AH, AH
    CMP SI, AX          
    JGE DONE_DEL_LBL

    ; Shift simple arrays
    MOV AL, [COURSE_CODE + SI + 1]
    MOV [COURSE_CODE + SI], AL
    MOV AL, [ROOM_NO + SI + 1]
    MOV [ROOM_NO + SI], AL
    MOV AL, [STUDENT_BATCH + SI + 1]
    MOV [STUDENT_BATCH + SI], AL

    ; Shift 3-byte ID
    PUSH SI
    MOV AX, SI
    MOV BL, 3
    MUL BL
    MOV BX, AX          ; Current offset
    ADD AX, 3
    MOV DI, AX          ; Next offset

    MOV AL, [STUDENT_ID + DI]
    MOV [STUDENT_ID + BX], AL
    MOV AL, [STUDENT_ID + DI + 1]
    MOV [STUDENT_ID + BX + 1], AL
    MOV AL, [STUDENT_ID + DI + 2]
    MOV [STUDENT_ID + BX + 2], AL
    POP SI

    INC SI
    JMP SHIFT_LOOP

DONE_DEL_LBL:
    DEC TOTAL_SIGNED_IN
    LEA DX, CONFIRM_MSG
    MOV AH, 09h
    INT 21h
    JMP MAIN_MENU

NOT_FOUND_LBL:
    LEA DX, NOT_FOUND_MSG
    MOV AH, 09h
    INT 21h
    JMP MAIN_MENU

;________Exit part_______
EXIT:
    MOV AH,4Ch
    INT 21h
 
 MAIN ENDP
END MAIN 