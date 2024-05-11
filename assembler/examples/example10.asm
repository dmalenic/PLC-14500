;
; Example 10
; Edge Detection.
; Toggle output on positive edge on an input.
;

.board=PLC14500-Nano

.io_BUTTON=IN0
.io_OUTPUT=OUT0
.io_BUTTON_STATUS=SPR0
.io_OUTPUT_STATUS=SPR1

LD      BUTTON_STATUS       ; Compare BUTTON and
XNOR    BUTTON              ; in-memory BUTTON_STATUS
LDC     RR                  ; => 1 if different

OEN     RR                  ; If different
IEN     RR

LD      BUTTON              ; Store so next round we don't
STO     BUTTON_STATUS       ; come here again.

OEN     RR                  ; Only if button pressed

LDC     OUTPUT_STATUS       ; Toggle the output status
STO     OUTPUT_STATUS       ; and reflect it on the LED.
STO     OUTPUT

ORC     RR                  ; End both ifs (if different
OEN     RR                  ;  and if present)
IEN     RR

JMP     0

