.define ROM_NAME "TEST"
.MEMORYMAP
 SLOTSIZE $8000
 DEFAULTSLOT 0
 SLOT 0 $8000
.ENDME

.ROMBANKSIZE $8000
.ROMBANKS 96

;.BASE $C0

.DEFINE HEADER_OFF $0000

.EMPTYFILL $FF

.SNESHEADER
 ID "SNES"
 NAME "Renovara"
 SLOWROM
 LOROM
 CARTRIDGETYPE $00
 ROMSIZE $0C
 SRAMSIZE $00
 COUNTRY $01
 LICENSEECODE $00
 VERSION $00
.ENDSNES

.BANK 0 SLOT 0

.SNESNATIVEVECTOR

COP EmptyHandler
BRK EmptyHandler
ABORT EmptyHandler
NMI NMI
UNUSED $0000
IRQ EmptyHandler

.ENDNATIVEVECTOR

.SNESEMUVECTOR 
COP EmptyHandler
ABORT EmptyHandler
NMI EmptyHandler
RESET Start
IRQBRK EmptyHandler
.ENDEMUVECTOR

.define TileDataSection $00A0
.define FirstPictureBank 01
.define MosaicDir $00A1
.define MosaicMirror $00A2
.define PaletteLength 32
.define DoingTransition $00A3
.define PalAndMapIndex $7e0100
.define PalAndMapBank $7e0102
.define LastPictureBank 23
.define PalPlusMapSize 2080
.define FirstTilBank 03
.define GoingForward $7e0089

.BANK 0 SLOT 0
.ORG $0
.SECTION "Code" SEMIFREE

MAIN:
Start:

    ; SNES initialzation

    sei
    phk
    plb
    clc
    xce
    rep         #$30                    ; 16-bit A/X/Y
    lda         #$0000                  ; Direct page @ $0000
    tcd
    ldx         #$01ff                  ; Stack @ $0100-01ff
    txs
    sep         #%00100000              ; 8-bit A

    lda         #$8F                    ; forced blanking (screen off), full brightness
    sta         $2100                   ; brightness & screen enable register
    lda         #$00
    sta         $2101                   ; sprite register (size & address in VRAM)
    sta         $2102                   ; sprite registers (address of sprite memory [OAM])
    sta         $2103                   ; sprite registers (address of sprite memory [OAM])
    sta         $2105                   ; graphic mode register
    sta         $2106                   ; mosaic register
    sta         $2107                   ; plane 0 map VRAM location
    sta         $2108                   ; plane 1 map VRAM location
    sta         $2109                   ; plane 2 map VRAM location
    sta         $210A                   ; plane 3 map VRAM location
    sta         $210B                   ; plane 0 & 1 Tile data location
    sta         $210C                   ; plane 2 & 3 Tile data location
    sta         $210D                   ; plane 0 scroll x (first 8 bits)
    sta         $210D                   ; plane 0 scroll x (last 3 bits)
    sta         $210E                   ; plane 0 scroll y (first 8 bits)
    sta         $210E                   ; plane 0 scroll y (last 3 bits)
    sta         $210F                   ; plane 1 scroll x (first 8 bits)
    sta         $210F                   ; plane 1 scroll x (last 3 bits)
    sta         $2110                   ; plane 1 scroll y (first 8 bits)
    sta         $2110                   ; plane 1 scroll y (last 3 bits)
    sta         $2111                   ; plane 2 scroll x (first 8 bits)
    sta         $2111                   ; plane 2 scroll x (last 3 bits)
    sta         $2112                   ; plane 2 scroll y (first 8 bits)
    sta         $2112                   ; plane 2 scroll y (last 3 bits)
    sta         $2113                   ; plane 3 scroll x (first 8 bits)
    sta         $2113                   ; plane 3 scroll x (last 3 bits)
    sta         $2114                   ; plane 3 scroll y (first 8 bits)
    sta         $2114                   ; plane 3 scroll y (last 3 bits)
    lda         #$80                    ; increase VRAM address after writing to $2119
    sta         $2115                   ; VRAM address increment register
    lda         #$00
    sta         $2116                   ; VRAM address low
    sta         $2117                   ; VRAM address high
    sta         $211A                   ; initial mode 7 setting register
    sta         $211B                   ; mode 7 matrix parameter A register (low)
    lda         #$01
    sta         $211B                   ; mode 7 matrix parameter A register (high)
    lda         #$00
    sta         $211C                   ; mode 7 matrix parameter B register (low)
    sta         $211C                   ; mode 7 matrix parameter B register (high)
    sta         $211D                   ; mode 7 matrix parameter C register (low)
    sta         $211D                   ; mode 7 matrix parameter C register (high)
    sta         $211E                   ; mode 7 matrix parameter D register (low)
    lda         #$01
    sta         $211E                   ; mode 7 matrix parameter D register (high)
    lda         #$00
    sta         $211F                   ; mode 7 center position X register (low)
    sta         $211F                   ; mode 7 center position X register (high)
    sta         $2120                   ; mode 7 center position Y register (low)
    sta         $2120                   ; mode 7 center position Y register (high)
    sta         $2121                   ; color number register ($00-$ff)
    sta         $2123                   ; bg1 & bg2 window mask setting register
    sta         $2124                   ; bg3 & bg4 window mask setting register
    sta         $2125                   ; obj & color window mask setting register
    sta         $2126                   ; window 1 left position register
    sta         $2127                   ; window 2 left position register
    sta         $2128                   ; window 3 left position register
    sta         $2129                   ; window 4 left position register
    sta         $212A                   ; bg1, bg2, bg3, bg4 window logic register
    sta         $212B                   ; obj, color window logic register (or, and, xor, xnor)
    sta         $212C                   ; main screen designation (planes, sprites enable)
    sta         $212D                   ; sub screen designation
    sta         $212E                   ; window mask for main screen
    sta         $212F                   ; window mask for sub screen
    lda         #$30
    sta         $2130                   ; color addition & screen addition init setting
    lda         #$00
    sta         $2131                   ; add/sub sub designation for screen, sprite, color
    lda         #$E0
    sta         $2132                   ; color data for addition/subtraction
    lda         #$00
    sta         $2133                   ; screen setting (interlace x,y/enable SFX data)
    lda         #$00
    sta         $4016
    sta         $4200                   ; enable v-blank, interrupt, joypad register
    lda         #$FF
    sta         $4201                   ; programmable I/O port
    lda         #$00
    sta         $4202                   ; multiplicand A
    sta         $4203                   ; multiplier B
    sta         $4204                   ; multiplier C
    sta         $4205                   ; multiplicand C
    sta         $4206                   ; divisor B
    sta         $4207                   ; horizontal count timer
    sta         $4208                   ; horizontal count timer MSB
    sta         $4209                   ; vertical count timer
    sta         $420A                   ; vertical count timer MSB
    sta         $420B                   ; general DMA enable (bits 0-7)
    sta         $420C                   ; horizontal DMA (HDMA) enable (bits 0-7)
    sta         $420D                   ; access cycle designation (slow/fast rom)

    ; Zero-initialize VRAM via DMA

    ldx         #$0000
    stx         $2116                   ; Starting address in VRAM
    lda         #%00001001
    sta         $4300                   ; DMA properties: CPU to PPU, no increment, 2 bytes to 2 registers
    lda         #$18
    sta         $4301                   ; Set write address to $2118
    ldx.w       #zerobyte
    stx         $4302                   ; Set source address to the zero byte
    lda         #:zerobyte
    sta         $4304                   ; Set source address to the zero byte
    ldx         #$0000
    stx         $4305                   ; Writing 0 bytes??
    lda         #%00000001
    sta         $420B                   ; Enable DMA channel 0

.define FirstTileDataSection 03
    ; Set up tile map for backgrounds

    lda #$01                            ; Set the bank for the Palette and TileMap to be 1
    sta PalAndMapBank
    lda #$00                            ; Set the section 0th TileDataSection within the PalAndMapBank to 0
    sta.l PalAndMapSectionWithinBank 
    lda #FirstTileDataSection            
    sta TileDataSection
    lda #$02
    sta GoingForward
    jsr DisplayPicture                  ; Draw the picture

    cli                                 ; Enable interrupts

    lda         #$01                    ; Enable BG1
    sta         $212c

    ; Enable VBlank interrupt


    ldx	    	#$0000
    stx         $4209

    lda         #$91
    sta         $4200

    sep         #$20                    ; Set the A register to 8-bit.
    lda		    #$01
    sta		    MosaicDir
    
    lda         #$01
    sta         MosaicMirror
    sta         $2106
 
    stz         DoingTransition

    ; End force blank

    lda         #$0F
    sta         $2100
    

@Loop:
    wai
    jmp         @Loop                    ;  Wait for NMI


EmptyHandler:
    rti

.define MapSize 2048
.define PalSize 32
.define PalAndMapSectionWithinBank $7e0235
LastTileBankToFirst:
DisplayPicture:   
    php
    lda		#$80
    sta		$2100  ; Enable forced blanking
    
    lda GoingForward                                ; If we haven't done anything yet, don't modify anything and display the title.
    cmp #$02
    beq DoneDeterminingDirection
    
    lda GoingForward                                ; Are we going forward? Branch to we are going forward.
    cmp #$01
    beq WeAreGoingForward
    
    lda TileDataSection                             ; If backwards, load TileDataSection and compare it to FirstTileDataSection
    cmp #FirstTilBank
    bne NotFirstBank                                ; If not first bank, go to NotFirstBank
    
    lda #LastPictureBank                             ; If it is the first bank, however, load the LastPictureBank and store it in TileDataSection
    sta TileDataSection
    bra DoneDeterminingDirection

NotFirstBank:
    dec TileDataSection                             ; Otherwise, decrement TileDataSection, go to previous picture.
    bra DoneDeterminingDirection
WeAreGoingForward:

    lda TileDataSection                             ; We're going forward. Are we on the last picture bank
    cmp #LastPictureBank
    bne NotLastBank                                 ; If not, go to NotLastBank (which increments TileDataSection)
   
    lda #FirstTilBank                           ; If so, Put FirstTilBank in TileDataSection (the title screen) and we're done.
    sta TileDataSection
    bra DoneDeterminingDirection

NotLastBank:
    inc TileDataSection                             ; Increment TileDataSection if it's not the last bank.
DoneDeterminingDirection:   
TileDataSectionCode:
    lda #$00
    pha
    plb
    lda 	TileDataSection                ; Load TileDataSection
+   sec                                 ; Subtract it by the amount of banks it is away from 0.
    sbc #FirstTileDataSection
    asl                                 ; Multiply by 2 (table is 2 bytes)
    rep #$20                            ; Change A to 16-bit
    and #$00FF                          ; Make sure the high byte is zeroed out.
    ldx.w 0                             ; Unnecessary. For superstition only.
    tax                                 ; Transfer A to X
    sep #$20                            ; Change A to 8-bit

    lda PalMapLocData.w,x               ; Load bank byte of palette and map data.
    sta PalAndMapBank                   ; Store it in PalAndMapBank
    lda PalMapLocDataByte2.w,x          ; Load image number within bank from table
    sta PalAndMapSectionWithinBank      ; Store into PalAndMapSectionWithinBank
     
    lda     PalAndMapBank               ; Load which Palette and Map Bank we're on
    pha                                 ; Put it in the data bank register
    plb
    rep     #$20                        ; Change A to 16-bit
    lda     PalAndMapSectionWithinBank  ; Which picture's section within the Palette and map bank?
    and     #$00FF                      ; AND it by #$00FF for some reason
    tay                                 ; Transfer A to Y
    lda     #$0000                      ; Clear A
    sta     AddNextTime                 ; Store A in AddNextTime
    lda     #$8000                      ; We're in LoROM, so add #$8000 to all addresses
    cpy     #$0000                      ; Is this the first section we need?

    beq MapPointerLoop                  ; If so, skip calculating the address further

.define AddNextTime $7e0300
DisplayPictureLoop:

    clc
    adc #PalPlusMapSize                 ; Add size of palette and map

    dey                                 ; Decrement Y...
 
    cpy #$0000                          ; Until it's 0
    bne DisplayPictureLoop              

MapPointerLoop:
    tay
    sep #$20 
    lda         #$00                    ; Set BG1 tile map at VRAM $0000-07FF, 32x32
    sta         $2107
    lda         #$01                    ; Set BG1 CHR at $2000
    sta         $210b
    ; Copy BG1 chr to VRAM at $2000 via DMA
    ldx         #$1000
    stx         $2116
    ldx         #%0001100000000001
    stx         $4300
    ldx         #$8000
    stx         $4302                              
    lda         TileDataSection           ; Bank with palette data
 
    sta         $4304
    ldx         #$7FFF
    stx         $4305
    lda		#%00000001
    sta		$420b

    ; Copy palette to CGRAM via DMA

    lda         #$00                    ; start at palette entry #0
    sta         $2121
    ldx         #$2200
    stx         $4320
    sty         $4322                   ; Store location of palette
    lda         PalAndMapBank           ; Bank with Palette data
    sta         $4324
    ldx         #32                     ;size of palette
    stx         $4325
    lda         #%00000100
    sta         $420B

    ; Copy BG1 tilemap to VRAM at $0000 via DMA

    ldx         #$0000
    stx         $2116
    ldx         #$1801
    stx         $4310
    rep         #$30
    tya
    clc
    adc         #32
    tay
    sty         $4312                      ;  Tilemap location is in Y after 32 is added
    sep         #$20
    lda         PalAndMapBank              ;  Bank with map data
    sta         $4314
    ldx         #$07ff
    stx         $4315
    lda 	#%00000010
    sta 	$420b
   


    ; Use graphics mode 1

    lda         #$01
    sta         $2105


;    lda.l PalAndMapSectionWithinBank      ; There are 15 (0 - 14) picture sections in a bank.
;    cmp #14                               ; Check if we're on the last bank
;    bne Not14                             ; If not, skip
;    lda #$00                              ; If so, set picture section within bank to 0
;    sta.l PalAndMapSectionWithinBank         
;    lda PalAndMapBank                     ; Increment the bank we're on, and put it in data bank register;
;    inc a
;    pha
;    plb
;    sta PalAndMapBank
;    bra TileDataSectionCode                ; Skip to next section
;Not14:
;    inc a
;    sta.l PalAndMapSectionWithinBank





    lda 	#$0f
    sta		$2100                        ; Disable forced blank

    plp		


    rts                                  ; Return from subroutine 


.define SkipGraphicsChange = $00a4

NMI:
   lda          DoingTransition              ; Are we doing the transition?
   cmp          #$00
   beq          +                            ; If NOT, SKIP

   jsr  		DoTransition

+  
JoyLoop:
   lda          $4212
   and          #$01
   bne          JoyLoop
   
   lda  		$4219                        ; Check controller for button presses
   and          #$02
   cmp          #$02
   beq          LeftPressed
   lda          $4219
   and          #$01
   cmp          #$01
   beq          RightPressed


   
EndInt:  
   rti                                       ; Return to non-VBlank loop
LeftPressed:
   lda #$00                                  ;Left has been pressed, we're going backward
   sta GoingForward 
   lda #$01
   sta DoingTransition                       ;And we're doing a transition.
   rti
RightPressed:
   lda #$01                                  ;Right has been Pressed, we're going forward
   sta GoingForward
   lda #$01
   sta DoingTransition
   rti
DoTransition:
   php
   lda          MosaicDir                    ; See if mosaic direction is down

   cmp          #$00
   beq          MosaicDown                   ; If so, go to MosaicDown
MosaicUp:
   lda          #$01                         ; If we're going up, we're doing the transition
   sta          DoingTransition
   lda 		    MosaicMirror                 ; Bit wrangle to get to check if the mosaic is done
   lsr
   lsr
   lsr
   lsr
   cmp 		    #$0f                         ; Check if mosaic is done going up
   bne          IncrementMosaic

   jsr 	    	DisplayPicture               ; If done, change the picture
   stz 	    	MosaicDir                    ; Change the mosaic direction                            
   lda 	    	#$f1                         
   sta 	    	MosaicMirror
   sta 	    	$2106                        ; Store it in mosaic register
   plb
   rts                                       ; Return from subroutine

IncrementMosaic:
   inc          a                            ; Increase mosaic, and bit wrangle to get it proper
   asl
   asl
   asl
   asl
   inc          a
   sta          MosaicMirror                 ; Store mosaic byte 
   sta          $2106

   plb
   rts	                                     ; Return from interrupt

MosaicDown:
   lda          MosaicMirror                

+  lsr
   lsr
   lsr
   lsr
   cmp 	    	#$00                        ; Are we done going down?
   beq          ChangeMosaicToUp            ; If so, change MosaicDir to up and end it
      
   dec          a
   asl
   asl
   asl
   asl
   inc          a

   sta          MosaicMirror
   sta		$2106
   cmp          #$01                        ; Is it Done?
   bne          +                           ; If not, skip to end.

   stz          DoingTransition             ; Otherwise, store zero in DoingTransition
+  plb
   rts
ChangeMosaicToUp
   lda #$01                                 ; Change mosaic direction to up and leave
   sta MosaicDir
   plb
   rts

zerobyte: .byte 1

PalMapLocData:
;This is a table of information about each image. The first byte is the bank for the palette and map data, the second byte is the image within the bank.
;Bank 1
.db 1
PalMapLocDataByte2:
.db 0
.db 1, 1 
.db 1, 2
.db 1, 3
.db 1, 4
.db 1, 5
.db 1, 6
.db 1, 7
.db 1, 8
.db 1, 9
.db 1, 10
.db 1, 11
.db 1, 12
.db 1, 13
.db 1, 14

;Bank 2

.db 2, 0
.db 2, 1
.db 2, 2
.db 2, 3
.db 2, 4
.db 2, 5
.db 2, 6

.ends
.BANK 1 SLOT 0
.ORG $0
DataBeginning:
.section "MAP0" force

palettetitlepal: .incbin "assets/pal/renovaratitlescreen.pal"
frametitlemap: .incbin "assets/maps/renovaratitlescreen.map"

palettetext01pal: .incbin "assets/pal/renovaratext1.pal"
palettetext01map: .incbin "assets/maps/renovaratext1.map"

palettetext02pal: .incbin "assets/pal/renovaratext2.pal"
palettetext02map: .incbin "assets/maps/renovaratext2.map"

palettetext03pal: .incbin "assets/pal/renovaratext3.pal"
palettetext03map: .incbin "assets/maps/renovaratext3.map"

palettetext04pal: .incbin "assets/pal/renovaratext4.pal"
palettetext04map: .incbin "assets/maps/renovaratext4.map"

palette01: .incbin "assets/pal/more_renovara0001.pal"
frame01map: .incbin "assets/maps/more_renovara0001.map"

palette02: .incbin "assets/pal/more_renovara0002.pal"
frame02map: .incbin "assets/maps/more_renovara0002.map"

palette03: .incbin "assets/pal/more_renovara0003.pal"
frame03map: .incbin "assets/maps/more_renovara0003.map"

palette04: .incbin "assets/pal/more_renovara0004.pal"
frame04map: .incbin "assets/maps/more_renovara0004.map"

palette05: .incbin "assets/pal/more_renovara0005.pal"
frame05map: .incbin "assets/maps/more_renovara0005.map"

palette06: .incbin "assets/pal/more_renovara0006.pal"
frame06map: .incbin "assets/maps/more_renovara0006.map"

palette07: .incbin "assets/pal/more_renovara0007.pal"
frame07map: .incbin "assets/maps/more_renovara0007.map"

palette08: .incbin "assets/pal/more_renovara0008.pal"
frame08map: .incbin "assets/maps/more_renovara0008.map"

palette09: .incbin "assets/pal/more_renovara0009.pal"
frame09map: .incbin "assets/maps/more_renovara0009.map"

palette10: .incbin "assets/pal/more_renovara0010.pal"
frame10map: .incbin "assets/maps/more_renovara0010.map"

.ends

.BANK 2 SLOT 0
.ORG $0
.section MAP1 force

palette11: .incbin "assets/pal/more_renovara0011.pal"
frame11map: .incbin "assets/maps/more_renovara0011.map"

palette12: .incbin "assets/pal/more_renovara0012.pal"
frame12map: .incbin "assets/maps/more_renovara0012.map"

palette13: .incbin "assets/pal/more_renovara0013.pal"
frame13map: .incbin "assets/maps/more_renovara0013.map"

palette14: .incbin "assets/pal/more_renovara0014.pal"
frame14map: .incbin "assets/maps/more_renovara0014.map"

palette15: .incbin "assets/pal/more_renovara0015.pal"
frame15map: .incbin "assets/maps/more_renovara0015.map"


palette16: .incbin "assets/pal/more_renovara0016.pal"
frame16map: .incbin "assets/maps/more_renovara0016.map"

.ends

.BANK 3 SLOT 0
.ORG $0
.section "TITLE1" force
title1chr .incbin "assets/til/renovaratitlescreen.til"
.ends

.BANK 4 SLOT 0
.ORG $0
.section "TEXT1" force
text1chr .incbin "assets/til/renovaratext1.til"
.ends

.BANK 5 SLOT 0
.ORG $0
.section "TEXT2" force
text2chr .incbin "assets/til/renovaratext2.til"
.ends

.BANK 6 SLOT 0
.ORG $0
.section "TEXT3" force
text3chr .incbin "assets/til/renovaratext3.til"
.ends

.BANK 7 SLOT 0
.ORG $0
.section "TEXT4" force
text4chr .incbin "assets/til/renovaratext4.til"
.ends


.BANK 8 SLOT 0
.ORG $0
.section "IMAGE1" force
frame1chr: .incbin "assets/til/more_renovara0001.til"
.ends

.BANK 9 SLOT 0
.ORG $0
.section "IMAGE2" force
frame2chr: .incbin "assets/til/more_renovara0002.til"
.ends


.BANK 10 SLOT 0
.ORG $0
.section "IMAGE3" force
frame3chr: .incbin "assets/til/more_renovara0003.til"
.ends

.BANK 11 SLOT 0
.ORG $0
.section "IMAGE4" force
frame4chr: .incbin "assets/til/more_renovara0004.til"
.ends

.BANK 12 SLOT 0
.ORG $0
.section "IMAGE5" force
frame5chr: .incbin "assets/til/more_renovara0005.til"
.ends

.BANK 13 SLOT 0
.ORG $0
.section "IMAGE6" force
frame6chr: .incbin "assets/til/more_renovara0006.til"
.ends

.BANK 14 SLOT 0
.ORG $0
.section "IMAGE7" force
frame7chr: .incbin "assets/til/more_renovara0007.til"
.ends

.BANK 15 SLOT 0
.ORG $0
.section "IMAGE8" force
frame8chr: .incbin "assets/til/more_renovara0008.til"
.ends

.BANK 16 SLOT 0
.ORG $0
.section "IMAGE9" force
frame9chr: .incbin "assets/til/more_renovara0009.til"
.ends

.BANK 17 SLOT 0
.ORG $0
.section "IMAGE10" force
frame10chr: .incbin "assets/til/more_renovara0010.til"
.ends

.BANK 18 SLOT 0
.ORG $0
.section "IMAGE11" force
frame11chr: .incbin "assets/til/more_renovara0011.til"
.ends

.BANK 19 SLOT 0
.ORG $0
.section "IMAGE12" force
frame12chr: .incbin "assets/til/more_renovara0012.til"
.ends

.BANK 20 SLOT 0
.ORG $0
.section "IMAGE13" force
frame13chr: .incbin "assets/til/more_renovara0013.til"
.ends

.BANK 21 SLOT 0
.ORG $0
.section "IMAGE14" force
frame14chr: .incbin "assets/til/more_renovara0014.til"
.ends

.BANK 22 SLOT 0
.ORG $0
.section "IMAGE15" force
frame15chr: .incbin "assets/til/more_renovara0015.til"
.ends

.BANK 23 SLOT 0
.ORG $0
.section "IMAGE16" force
frame16chr: .incbin "assets/til/more_renovara0016.til"
.ends

