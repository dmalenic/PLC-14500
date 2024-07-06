;
; Bathrom Lights and Fan
;
; This is a classic setup ofte found in old-ish hotels
; and public restrooms. The installation consists of a
; ceiling light and an extractor fan. The light goes ON
; and OFF with a switch. The extractor fan, instead,
; turns ON only if the lights have been ON for a certain
; time. The fan, if it was started, will run for a
; certain periond of time after the light is switched
; OFF.
;

.board=PLC14500-Nano

.io_SWITCH=IN0
.io_LIGHT=OUT0
.io_FAN=OUT1
.io_FANTON=SPR2
.io_FANTOFF=SPR1

ORC     RR
IEN     RR
OEN     RR

LD      SWITCH          ; Lights always follow the swithc.
STO     LIGHT

ANDC    FANTON          ; Trigger the timer if lights ON and
STO     TMR0-TRIG       ; TON timer was not triggered yet.
SKZ
STO     FANTON

LDC     TMR0-OUT        ; Start the fan if timer elapsed and
AND     FANTON          ; TON timer was triggred
AND     LIGHT           ; and LIGHT is still ON
SKZ
STO     FAN

LDC     SWITCH          ; Trigger TMR0 if lights are OFF,
AND     FANTON          ; and TON has been triggred
ANDC    FANTOFF         ; and TOFF has not been triggered (yet)
ANDC    TMR0-OUT        ; and the timer is not running.
STO     TMR0-TRIG
SKZ
STO     FANTOFF

LDC     FANTOFF         ; If TOFF has not been triggered
SKZ                     ; we are done, go around.
JMP     0

LD      TMR0-OUT        ; If the TOFF timer has not elapsed
SKZ                     ; go around, nothing else to do
JMP     0

STO     FAN             ; TOFF elapsed, turn OFF the fan
STO     FANTON          ; reset everything
STO     FANTOFF
JMP     0               ; and go back to start

