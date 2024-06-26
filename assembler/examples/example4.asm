;
; Example 4
; Timed lights with multiple buttons (eg block of flats staircase)

.board=PLC14500-Nano

.io_BUTTON_A=IN0
.io_BUTTON_B=IN1
.io_BUTTON_C=IN2
.io_BUTTON_D=IN3
.io_BUTTON_E=IN4
.io_BUTTON_F=IN5
.io_BUTTON_G=IN6
.io_LIGHT=OUT0

ORC  RR
IEN  RR
OEN  RR

LD   BUTTON_A
OR   BUTTON_B
OR   BUTTON_C
OR   BUTTON_D
OR   BUTTON_E
OR   BUTTON_F
OR   BUTTON_G

STO  OUT7

LD   IN7
STO  LIGHT

JMP  0




