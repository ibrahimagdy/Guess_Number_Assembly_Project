.model small
.stack 64
.data
 
    correctNumber db 155   
    LF equ 10
 
    Msg         db  LF,'Please enter a number in range 0 to 255 : $'
    lessMsg     db  LF,'Value if Less ','$'
    moreMsg     db  LF,'Value is More ', '$'
    equalMsg    db  LF,'You guessed correctly', '$'
    overflowMsg db  LF,'The Number is out of the range!', '$'
    retry       db  LF,'Retry (y|n)?' ,'$'
    guess       db  ?      
    errorCheck  db  ?    
 
.code
 
start:
 
    LEA BX,guess
    MOV BYTE PTR [BX], 0
 
    LEA BX,errorCheck
    MOV BYTE PTR [BX], 0
 
    .STARTUP    
    LEA dx,Msg   
 
    MOV ah, 9h              
    INT 21h    
 
    MOV cl, 0h       
    MOV dx, 0h
 
while:
 
    CMP cl, 3         
    JG endwhile      
 
    MOV ah, 1h          
    INT 21h    
 
    CMP al, 0Dh       
    JE endwhile      
 
    SUB al, 30h    
    MOV dl, al          
    PUSH dx              
    INC cl              
 
    JMP while          
 
endwhile:

    DEC cl                  
    CMP cl, 02h             
    JG  overflow            
 
    LEA BX,errorCheck 
    MOV BYTE PTR [BX], cl   
 
    MOV cl, 0h       
 
while2:
 
    CMP cl,errorCheck
    JG endwhile2
 
    POP dx                
 
    MOV ch, 0h              
    MOV al, 1              
    MOV dh, 10            
 
while3:
 
    CMP ch, cl             
    JGE endwhile3     
 
    MUL dh               
 
    INC ch               
    JMP while3
 
 endwhile3:
 
    MUL dl                  
 
    JO  overflow        
    
    MOV dl, al              
    ADD dl, guess          
 
    JC  overflow           
 
    LEA BX,guess    
    MOV BYTE PTR [BX], dl   
 
    INC cl                 
 
    JMP while2       
 
endwhile2:             
 
    MOV dl, correctNumber          
    MOV dh, guess           
 
    CMP dh, dl             
 
    JC greater     
    JE equal            
    JG lower       
 
equal:
 
    LEA dx,equalMsg 
    MOV ah, 9h              
    INT 21h             
    JMP exit          
 
greater:
 
    LEA dx,moreMsg
    MOV ah, 9h            
    INT 21h            
    JMP start        
 
lower:
 
    LEA dx,lessMsg  
    MOV ah, 9h              
    INT 21h               
    JMP start               
 
overflow:
 
    LEA dx,overflowMsg 
    MOV ah, 9h             
    INT 21h                
    JMP start              
 
exit:
 
retry_while:
 
    LEA dx,retry  
 
    MOV ah, 9h            
    INT 21h              
 
    MOV ah, 1h              
    INT 21h                 
 
    CMP al, 6Eh             
    JE return_to_DOS        
 
    CMP al, 79h             
    JE restart             
 
    JMP retry_while       
 
retry_endwhile:
 
restart:
    JMP start            
    
return_to_DOS:
    
    .EXIT 
    
    end start
RET