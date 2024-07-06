;
; Example 9
; 2-Bit Adder.
; Adds 2-bit number on IN0 and IN1 to anohter 2-bit number IN2 and IN3 and produces 3-bit number on OUT0, OUT1 and OUT2.
;

.board=PLC14500-Nano

.io_A0=IN0
.io_A1=IN1
.io_A2=IN2
.io_B0=IN3
.io_B1=IN4
.io_B2=IN5
.io_R0=OUT0
.io_R1=OUT1
.io_R2=OUT2
.io_R3=OUT3
.io_C0=SPR0
.io_C1=SPR1
.io_T0=SPR2

ORC     RR          ; RR=RR|!RR, always 1
IEN     RR          ; Enable inputs
OEN     RR          ; Enable outputs

; Half adder A0+B0 => R0, carry in C0

LD      A0          ; Peform an XOR of A0 and B0
XNOR    B0
STOC    R0

LD      A0          ; Compute the carry (C0)
AND     B0
STO     C0

; Full adder A1+B1+C0 => R1, carry => C1

LD      A1          ; XOR A1 and B1
XNOR    B1
STOC    T0          ; Store the intermediate result.
XNOR    C0          ; XOR with C0 to get R1
STO     R1

LD      T0          ; Compute the carry of A1+B1+C0
AND     C0          ;  which is in fact our last output
STO     T0          ;  bit R2
LD      A1
AND     B1
OR      T0
STO     C1

; Full adder A2+B2+C1 => R2, carry => R3

LD      A2          ; XOR A2 and B2
XNOR    B2
STOC    T0          ; Store the intermediate result.
XNOR    C1          ; XOR with C1 to get R2
STO     R2

LD      T0          ; Compute the carry of A2+B2+C1
AND     C1          ;  which is in fact our last output
STO     T0          ;  bit R3
LD      A2
AND     B2
OR      T0
STO     R3

JMP     0

