        ; CoCo (32×16 text) — clear screen, print HELLO WORLD!, wait for key
        ; Assumes Color BASIC ROM entry WAITKEY at $A1B1 returns ASCII in A

SCREEN  EQU     $0400
ROWS    EQU     16
COLS    EQU     32
SIZE    EQU     ROWS*COLS       ; 512 bytes
SPACE   EQU     $60             ; plain blank for clearing
WAITKEY EQU     $A1B1           ; ROM routine: waits; returns key in A

        ORG     $1000           ; (example load address; adjust for your setup)
start:
        ; --- Clear the 32×16 text screen with SPACE ($60)
        LDX     #SCREEN
        LDA     #SPACE
        LDY     #SIZE
ClrLp:  STA     ,X+
        LEAY    -1,Y
        BNE     ClrLp

        ; --- Print message at top-left (SCREEN) with bit 6 set on each char
        LDX     #SCREEN         ; screen write pointer
        LEAU    Msg,PCR         ; U -> message text (0-terminated)
PrLp:   LDA     ,U+             ; get next char
        BEQ     Printed         ; 0 = end
        ORA     #$40            ; force bit 6 ON per requirement
        STA     ,X+             ; store to screen
        BRA     PrLp

Printed:
        ; --- Wait until any key is pressed, key code returned in A (ignored here)
        JSR     WAITKEY         ; blocks until key; key in A on return

        RTS                     ; back to caller (e.g., BASIC USR)

; --- Data ---
Msg:    FCC     "HELLO WORLD!"
        FCB     0

        end     start