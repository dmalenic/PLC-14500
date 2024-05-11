;
; Example 8
; If/else blocks.
; The code below will flash the OUT0 led and OUT1 led interchangeably at the speed adjustable with RV1. Status is held in SPR0.
;

.board=PLC14500-Nano

.io_STATUS=SPR0
.io_TMP=SPR1
.io_LIGHT1=OUT0
.io_LIGHT2=OUT1

ORC     RR          ; RR=RR|!RR, always 1
IEN     RR          ; Enable inputs

LDC     TMR0-OUT    ; If TMR0 expired
STOC    TMP         ; Store for else
OEN     RR

STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

LD      STATUS      ; Toggle STATUS
STOC    STATUS 
STOC    LIGHT1      ; Flash LIGHT1

OEN     TMP         ; else

LD      STATUS      ; Flash LIGHT2
STOC    LIGHT2

ORC     RR          ; RR=RR|!RR, always 1
OEN     RR          ; end if

JMP     0

