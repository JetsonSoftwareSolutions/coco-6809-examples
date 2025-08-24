        ; Create DATA.DAT using Disk Extended BASIC (RS-DOS) ROM services
        ; - Copies 8.3 into DNAMBF
        ; - Sets File Type/Data + ASCII flag ($01/$FF)
        ; - Preps FCB disk buffer pointer
        ; - Searches dir, creates if missing, then opens custom FCB
        ; - Closes all files and returns

        ; ---------- OS workspace & disk vectors (per Unravelled) ----------
DCTRK   EQU     $00EC           ; DSKCON track
DSEC    EQU     $00ED           ; DSKCON sector
DCBPT   EQU     $00EE           ; DSKCON data pointer
FCBTMP  EQU     $00F1           ; temp FCB ptr

DNAMBF  EQU     $094C           ; 11-byte “NAMEEXT” buffer (8+3)
DFLTYP  EQU     $0957           ; File Type (0=basic,1=data,2=ML,3=TE source)
DASCFL  EQU     $0958           ; ASCII flag: 0=binary/crunched, $FF=ASCII
SECTOR  EQU     $0973           ; (set nonzero by Search Dir if found)

        ; ROM calls (typical RS-DOS; keep as-is from your ROM map)
SEARCHD EQU     $C68C           ; Search Directory (uses DNAMBF, returns sector)
CREATEF EQU     $C567           ; Create File (FCB, DNAMBF, DFLTYP/DASCFL)
OPENCFB EQU     $C538           ; Open Custom FCB (X->FCB)
CLOSEALL EQU    $CA3B           ; Close all files

        ORG     $1300

MakeDATA:
        ; --- load filename "DATA    DAT" into DNAMBF (8+3 bytes) ---
        LDX     #FDATA
        JSR     SETNAM

        ; --- set File Type + ASCII flag: $01 (Data), $FF (ASCII) ---
        LDD     #$01FF
        STD     DFLTYP          ; DFLTYP=$01, DASCFL=$FF

        ; --- prep DSKCON parameter block & disk buffer addr for FCB ---
        LDU     $C006           ; (ROM’s DSKCON param base)
        CLRA
        STA     1,U             ; drive = 0 (current default drive)

        LDD     #FCB_DTA+25     ; start of sector buffer inside FCB area
        STD     FCB_BUF         ; remember in our symbol too (optional)
        STD     4,U             ; DSKCON data pointer -> FCB’s buffer

        ; --- directory search; SECTOR nonzero if found ---
        JSR     SEARCHD
        TST     SECTOR
        BNE     HaveEntry       ; found -> go open

        ; not found: create it
        JSR     CREATEF

HaveEntry:
        ; --- open custom FCB (X = FCB address) ---
        LDX     #FCB_DTA
        STX     FCBTMP
        JSR     OPENCFB

        ; --- all done; close files and return ---
        JSR     CLOSEALL
        RTS

; Copy 8.3 filename (11 bytes) from X -> DNAMBF
SETNAM:
        LDY     #DNAMBF
Copy11: LDA     ,X+
        STA     ,Y+
        CMPY    #DNAMBF+11
        BNE     Copy11
        RTS

; 8.3 “DATA    DAT”
FDATA   FCC     "DATA    DAT"

; FCB + buffer area (size matches your pattern)
FCB_BUF RMB     2               ; buffer start (mirrors what we store)
FCB_DTA RMB     281             ; FCB + workspace (25+256 fits nicely)

        END     MakeDATA
