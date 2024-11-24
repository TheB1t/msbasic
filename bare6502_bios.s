.setcpu "65C02"
.debuginfo
.segment "BIOS"

ACIA_DATA   = $5000
ACIA_STATUS = $5001
ACIA_CMD    = $5002
ACIA_CTRL   = $5003

LOAD:
    rts

SAVE:
    rts

MONRDKEY:
CHRIN:
    LDA     ACIA_STATUS
    AND     #$08
    BEQ     @no_keypressed
    LDA     ACIA_DATA
    JSR     CHROUT
    SEC
    RTS
@no_keypressed:
    CLC
    RTS

MONCOUT:
CHROUT:
    PHA
    STA     ACIA_DATA      ; Output character.
    LDA     #$FF           ; Wait for transmit buffer to empty.
@tx_delay:
    DEC
    BNE     @tx_delay
    PLA
    RTS


VIDEOBUF      = $6000
BANK_ADDR     = $7001

BLACK_COLOR   = $00
WHITE_COLOR   = $FF

SCREEN_WIDTH  = 128    ; Ширина экрана (в пикселях)
SCREEN_HEIGHT = 128    ; Высота экрана (в пикселях)

DRAW_START:
    LDA     #$00

.include "wozmon.s"

.segment "IRQVEC"
    .word   $0F00          ; NMI vector
    .word   RESET          ; RESET vector
    .word   $0000          ; IRQ vector