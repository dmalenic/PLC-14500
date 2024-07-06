;
; Rotate left.
; Rotate 1 left from OUT0..OUT5
;

.board=PLC14500-Nano

.io_LIGHT_A=SPR0
.io_LIGHT_B=SPR1
.io_LIGHT_C=SPR2
.io_LIGHT_D=SPR3
.io_LIGHT_E=SPR4
.io_LIGHT_F=SPR5
.io_SWAP=SPR6

STO     SWAP        ; Save RR
ORC     RR          ; RR=RR|!RR (always 1)
IEN     RR          ; Enable inputs
OEN     RR          ; Enable outputs
LD      SWAP        ; Restore RR

LDC     RR
OEN     RR

STOC    LIGHT_A     ; Initiate with only the last light ON, 
STOC    LIGHT_B     ;   it will be immedately rotated so it will look like
STOC    LIGHT_C     ;   initiating with the OUT0
STOC    LIGHT_D
STOC    LIGHT_E
STO     LIGHT_F

ORC     RR          ; RR=RR|!RR (always 1)
OEN     RR

; Rotate all bits forwared (and last back to first).
;   But only when TMR0 expires

LDC     TMR0-OUT    ; If TMR0 expired
OEN     RR
STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

LD      LIGHT_F
STO     SWAP
LD      LIGHT_E
STO     LIGHT_F    
LD      LIGHT_D
STO     LIGHT_E
LD      LIGHT_C
STO     LIGHT_D
LD      LIGHT_B
STO     LIGHT_C
LD      LIGHT_A
STO     LIGHT_B
LD      SWAP
STO     LIGHT_A

; Reflect the status on outputs

LD      LIGHT_A
STO     OUT0
LD      LIGHT_B
STO     OUT1
LD      LIGHT_C
STO     OUT2
LD      LIGHT_D
STO     OUT3
LD      LIGHT_E
STO     OUT4
LD      LIGHT_F
STO     OUT5

ORC     RR

JMP     0

