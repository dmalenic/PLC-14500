;
; Example 7
; If blocks.
; The code below will flash the OUT0 led at the speed adjustable with RV1. Status is held in SPR0.
;

.board=PLC14500-Nano

.io_STATUS=SPR0
.io_LIGHT=OUT0

ORC     RR          ; RR=RR|!RR, always 1
IEN     RR          ; Enable inputs

LDC     TMR0-OUT    ; If TMR0 expired
OEN     RR

STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

LD      STATUS      ; Toggle STATUS
STOC    STATUS
STOC    LIGHT       ; Flash LIGHT

ORC     RR          ; RR=RR|!RR, always 1
OEN     RR          ; end if

JMP     0

