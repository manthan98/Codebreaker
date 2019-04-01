; LED Definitions
; 0x01 = red
; 0x02 = green
; 0x04 = orange
; 0x08 = white
; 0x10 = pink
; 0x20 = blue

; Misc
.def cyclingLEDCount = r21
.def isPlayerOneTurn = r28

ldi cyclingLEDCount, 0x00 ; Counter for cycling through LEDs
ldi isPlayerOneTurn, 0x00

; Player 1
.def playerOneFirstLEDChoice = r22
.def playerOneSecondLEDChoice = r23
.def playerOneThirdLEDChoice = r24
.def playerOneOrderCount = r26

ldi playerOneFirstLEDChoice, 0x00 ; Player 1 selected first LED
ldi playerOneSecondLEDChoice, 0x00 ; Player 1 selected second LED
ldi playerOneThirdLEDChoice, 0x00 ; Player 1 selected third LED

ldi playerOneOrderCount, 0x00

; Player 2
.def playerTwoFirstLEDChoice = r29
.def playerTwoSecondLEDChoice = r30
.def playerTwoThirdLEDChoice = r31
.def playerTwoOrderCount = r26

ldi playerTwoFirstLEDChoice, 0x00 ; Player 1 selected first LED
ldi playerTwoSecondLEDChoice, 0x00 ; Player 1 selected second LED
ldi playerTwoThirdLEDChoice, 0x00 ; Player 1 selected third LED

ldi playerTwoOrderCount, 0x00

loop:

rcall Delay

; Read the pins associated with the buttons
in r17, pinD
ANDI r17, 0x0C

; Check if ENTER button is pressed
cpi r17, 0x04
breq is_enterPressed
isnt_enterPressed:
    jmp done_enterPressed
is_enterPressed:

    ; Check which LED is chosen
    in r27, pinB
    andi r27, 0xFF

    cpi isPlayerOneTurn, 0x00
    breq is_playerOneTurn
    isnt_playerOneTurn:
        jmp done_playerOneTurn
    is_playerOneTurn:
        cpi playerOneOrderCount, 0x00
        breq is_firstLEDChoice
        isnt_firstLEDChoice:
            jmp done_firstLEDChoice
        is_firstLEDChoice:
            mov playerOneFirstLEDChoice, r27

            ; Blink the chosen LED
            rcall BlinkLEDPlayerOne

            inc playerOneOrderCount
            jmp done_enterPressed
        done_firstLEDChoice:

        cpi playerOneOrderCount, 0x01
        breq is_secondLEDChoice
        isnt_secondLEDChoice:
            jmp done_secondLEDChoice
        is_secondLEDChoice:
            mov playerOneSecondLEDChoice, r27

            rcall BlinkLEDPlayerOne

            inc playerOneOrderCount
            jmp done_enterPressed
        done_secondLEDChoice:

        cpi playerOneOrderCount, 0x02
        breq is_thirdLEDChoice
        isnt_thirdLEDChoice:
            jmp done_thirdLEDChoice
        is_thirdLEDChoice:
            mov playerOneThirdLEDChoice, r27

            rcall BlinkLEDPlayerOne

			ldi playerTwoOrderCount, 0x00
            inc isPlayerOneTurn

			rcall SetupPortDLED
			sbi portD, 7

            jmp done_enterPressed
        done_thirdLEDChoice:
    done_playerOneTurn:

    cpi isPlayerOneTurn, 0x01
    breq is_playerTwoTurn
    isnt_playerTwoTurn:
        jmp done_playerTwoTurn
    is_playerTwoTurn:
        cpi playerTwoOrderCount, 0x00
        breq is_firstLEDChoiceP2
        isnt_firstLEDChoiceP2:
            jmp done_firstLEDChoiceP2
        is_firstLEDChoiceP2:
            mov playerTwoFirstLEDChoice, r27

            ; Blink the chosen LED
            rcall BlinkLEDPlayerTwo

            inc playerTwoOrderCount
            jmp done_enterPressed
        done_firstLEDChoiceP2:

        cpi playerTwoOrderCount, 0x01
        breq is_secondLEDChoiceP2
        isnt_secondLEDChoiceP2:
            jmp done_secondLEDChoiceP2
        is_secondLEDChoiceP2:
            mov playerTwoSecondLEDChoice, r27

            rcall BlinkLEDPlayerTwo

            inc playerTwoOrderCount
            jmp done_enterPressed
        done_secondLEDChoiceP2:

        cpi playerTwoOrderCount, 0x02
        breq is_thirdLEDChoiceP2
        isnt_thirdLEDChoiceP2:
            jmp done_thirdLEDChoiceP2
        is_thirdLEDChoiceP2:
            mov playerTwoThirdLEDChoice, r27

            rcall BlinkLEDPlayerTwo

			ldi r26, 0x00
            inc isPlayerOneTurn

			rcall CheckResults

			in r25, pinD
            ANDI r25, 0xFF

            cpi r25, 0xF0
            breq is_equalCodes
            isnt_equalCodes:
                rcall ResetPlayerTwo
            is_equalCodes:
                ; CELEBRATION
				rcall Celebration
            done_equalCodes:


            jmp done_enterPressed
        done_thirdLEDChoiceP2:
    done_playerTwoTurn:

done_enterPressed:

; Check if UP push-button is pressed
cpi r17, 0x08
breq is_upPressed
isnt_upPressed:
    jmp done_upPressed
is_upPressed:
    cpi cyclingLEDCount, 0x00
    breq is_firstLED
    isnt_firstLED:
        jmp done_firstLED
    is_firstLED:
        ; Light up the first LED - red colour
        rcall SetupPortBLED
        sbi PORTB, 0 ; Sets bit 0 on port B to 1

        inc cyclingLEDCount ; Increment count
        jmp done_upPressed
    done_firstLED:

    rcall Delay

    cpi cyclingLEDCount, 0x01
    breq is_secondLED
    isnt_secondLED:
        jmp done_secondLED
    is_secondLED:
        ; Light up the second LED - green colour
        rcall SetupPortBLED
        sbi PORTB, 1 ; Sets bit 0 on port B to 1.

        inc cyclingLEDCount ; Increment count
        jmp done_upPressed
    done_secondLED:

    rcall Delay

    cpi cyclingLEDCount, 0x02
    breq is_thirdLED
    isnt_thirdLED:
        jmp done_thirdLED
    is_thirdLED:
        ; Light up the third LED - white colour
        rcall SetupPortBLED
        sbi PORTB, 2

        inc cyclingLEDCount
        jmp done_upPressed
    done_thirdLED:

    cpi cyclingLEDCount, 0x03
    breq is_fourthLED
    isnt_fourthLED:
        jmp done_fourthLED
    is_fourthLED:
        ; Light up the third LED - white colour
        rcall SetupPortBLED
        sbi PORTB, 3

        inc cyclingLEDCount
        jmp done_upPressed
    done_fourthLED:

    cpi cyclingLEDCount, 0x04
    breq is_fifthLED
    isnt_fifthLED:
        jmp done_fifthLED
    is_fifthLED:
        rcall SetupPortBLED
        sbi portB, 4
        
        inc cyclingLEDCount
        jmp done_upPressed
    done_fifthLED:

    cpi cyclingLEDCount, 0x05
    breq is_sixthLED
    isnt_sixthLED:
        jmp done_sixthLED
    is_sixthLED:
        rcall SetupPortBLED
        sbi portB, 5

        ldi cyclingLEDCount, 0x00
        jmp done_upPressed
    done_sixthLED:
done_upPressed:

jmp loop

; Delay subroutine
Delay:
ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    nop

ret

; Setup LED code subroutine - port B
SetupPortBLED:   
ldi r16, 0xFF ; Load register 16 with 0xFF (all bits 1) 
out DDRB, r16 ; Write 0xFF to Data Direction Register for port B. This defines all pins on port B as output. 
ldi r16, 0x0 ; Load register 16 with 0x00 (all bits 0) 
out portB, r16 ; Write 0x00 to port B. This sets all pins to 0.
ret

; Setup LED code subroutine - port D
SetupPortDLED:   
ldi r16, 0xFF ; Load register 16 with 0xFF (all bits 1) 
out DDRD, r16 ; Write 0xFF to Data Direction Register for port B. This defines all pins on port B as output. 
ldi r16, 0x0 ; Load register 16 with 0x00 (all bits 0) 
out portD, r16 ; Write 0x00 to port B. This sets all pins to 0.
ret

; Clear LED code subroutine - port B
ClearPortBLED:
ldi r16, 0xFF ; Load register 16 with 0xFF (all bits 1) 
out DDRB, r16 ; Write 0xFF to Data Direction Register for port B. This defines all pins on port B as output. 
ldi r16, 0x0 ; Load register 16 with 0x00 (all bits 0) 
out portB, r16 ; Write 0x00 to port B. This sets all pins to 0. 
sbi portB, 0 ; Sets bit 0 on port B to 1.
ret

; Clear LED code subroutine - port D
ClearPortDLED:
ldi r16, 0xFF ; Load register 16 with 0xFF (all bits 1) 
out DDRD, r16 ; Write 0xFF to Data Direction Register for port B. This defines all pins on port B as output. 
ldi r16, 0x0 ; Load register 16 with 0x00 (all bits 0) 
out portD, r16 ; Write 0x00 to port B. This sets all pins to 0. 
sbi portD, 0 ; Sets bit 0 on port B to 1.
ret

; PLAYER ONE LED BLINKS
BlinkLEDPlayerOne:

; Based on order count we can map the LED bits and compare with
; the four LED bit configurations and blink appropriately.
cpi playerOneOrderCount, 0x00
breq is_firstChoiceBlink
isnt_firstChoiceBlink:
    jmp done_firstChoiceBlink
is_firstChoiceBlink:

    cpi playerOneFirstLEDChoice, 0x01
    breq is_redBlinking
    isnt_redBlinking:
        jmp done_redBlinking
    is_redBlinking:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_firstChoiceBlink
    done_redBlinking:

    cpi playerOneFirstLEDChoice, 0x02
    breq is_greenBlinking
    isnt_greenBlinking:
        jmp done_greenBlinking
    is_greenBlinking:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_firstChoiceBlink
    done_greenBlinking:

    cpi playerOneFirstLEDChoice, 0x04
    breq is_orangeBlinking
    isnt_orangeBlinking:
        jmp done_orangeBlinking
    is_orangeBlinking:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_firstChoiceBlink
    done_orangeBlinking:

    cpi playerOneFirstLEDChoice, 0x08
    breq is_whiteBlinking
    isnt_whiteBlinking:
        jmp done_whiteBlinking
    is_whiteBlinking:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_firstChoiceBlink
    done_whiteBlinking:

    cpi playerOneFirstLEDChoice, 0x10
    breq is_pinkBlinking
    isnt_pinkBlinking:
        jmp done_pinkBlinking
    is_pinkBlinking:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_firstChoiceBlink
    done_pinkBlinking:

    cpi playerOneFirstLEDChoice, 0x20
    breq is_blueBlinking
    isnt_blueBlinking:
        jmp done_blueBlinking
    is_blueBlinking:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_firstChoiceBlink
    done_blueBlinking:

done_firstChoiceBlink:

cpi playerOneOrderCount, 0x01
breq is_secondChoiceBlink
isnt_secondChoiceBlink:
    jmp done_secondChoiceBlink
is_secondChoiceBlink:

    cpi playerOneSecondLEDChoice, 0x01
    breq is_redBlinking2
    isnt_redBlinking2:
        jmp done_redBlinking2
    is_redBlinking2:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_secondChoiceBlink
    done_redBlinking2:

    cpi playerOneSecondLEDChoice, 0x02
    breq is_greenBlinking2
    isnt_greenBlinking2:
        jmp done_greenBlinking2
    is_greenBlinking2:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_secondChoiceBlink
    done_greenBlinking2:

    cpi playerOneSecondLEDChoice, 0x04
    breq is_orangeBlinking2
    isnt_orangeBlinking2:
        jmp done_orangeBlinking2
    is_orangeBlinking2:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_secondChoiceBlink
    done_orangeBlinking2:

    cpi playerOneSecondLEDChoice, 0x08
    breq is_whiteBlinking2
    isnt_whiteBlinking2:
        jmp done_whiteBlinking2
    is_whiteBlinking2:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_secondChoiceBlink
    done_whiteBlinking2:

    cpi playerOneSecondLEDChoice, 0x10
    breq is_pinkBlinking2
    isnt_pinkBlinking2:
        jmp done_pinkBlinking2
    is_pinkBlinking2:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_secondChoiceBlink
    done_pinkBlinking2:

    cpi playerOneSecondLEDChoice, 0x20
    breq is_blueBlinking2
    isnt_blueBlinking2:
        jmp done_blueBlinking2
    is_blueBlinking2:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_secondChoiceBlink
    done_blueBlinking2:

done_secondChoiceBlink:

cpi playerOneOrderCount, 0x02
breq is_thirdChoiceBlink
isnt_thirdChoiceBlink:
    jmp done_thirdChoiceBlink
is_thirdChoiceBlink:

    cpi playerOneThirdLEDChoice, 0x01
    breq is_redBlinking3
    isnt_redBlinking3:
        jmp done_redBlinking3
    is_redBlinking3:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_thirdChoiceBlink
    done_redBlinking3:

    cpi playerOneThirdLEDChoice, 0x02
    breq is_greenBlinking3
    isnt_greenBlinking3:
        jmp done_greenBlinking3
    is_greenBlinking3:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_thirdChoiceBlink
    done_greenBlinking3:

    cpi playerOneThirdLEDChoice, 0x04
    breq is_orangeBlinking3
    isnt_orangeBlinking3:
        jmp done_orangeBlinking3
    is_orangeBlinking3:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_thirdChoiceBlink
    done_orangeBlinking3:

    cpi playerOneThirdLEDChoice, 0x08
    breq is_whiteBlinking3
    isnt_whiteBlinking3:
        jmp done_whiteBlinking3
    is_whiteBlinking3:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_thirdChoiceBlink
    done_whiteBlinking3:

    cpi playerOneThirdLEDChoice, 0x10
    breq is_pinkBlinking3
    isnt_pinkBlinking3:
        jmp done_pinkBlinking3
    is_pinkBlinking3:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_thirdChoiceBlink
    done_pinkBlinking3:

    cpi playerOneThirdLEDChoice, 0x20
    breq is_blueBlinking3
    isnt_blueBlinking3:
        jmp done_blueBlinking3
    is_blueBlinking3:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_thirdChoiceBlink
    done_blueBlinking3:

done_thirdChoiceBlink:

ret

; PLAYER TWO LED BLINKS
BlinkLEDPlayerTwo:

; Based on order count we can map the LED bits and compare with
; the four LED bit configurations and blink appropriately.
cpi playerTwoOrderCount, 0x00
breq is_firstChoiceBlink2
isnt_firstChoiceBlink2:
    jmp done_firstChoiceBlink2
is_firstChoiceBlink2:

    cpi playerTwoFirstLEDChoice, 0x01
    breq is_redBlinking5
    isnt_redBlinking5:
        jmp done_redBlinking5
    is_redBlinking5:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_firstChoiceBlink2
    done_redBlinking5:

    cpi playerTwoFirstLEDChoice, 0x02
    breq is_greenBlinking5
    isnt_greenBlinking5:
        jmp done_greenBlinking5
    is_greenBlinking5:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_firstChoiceBlink2
    done_greenBlinking5:

    cpi playerTwoFirstLEDChoice, 0x04
    breq is_orangeBlinking5
    isnt_orangeBlinking5:
        jmp done_orangeBlinking5
    is_orangeBlinking5:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_firstChoiceBlink2
    done_orangeBlinking5:

    cpi playerTwoFirstLEDChoice, 0x08
    breq is_whiteBlinking5
    isnt_whiteBlinking5:
        jmp done_whiteBlinking5
    is_whiteBlinking5:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_firstChoiceBlink2
    done_whiteBlinking5:

    cpi playerTwoFirstLEDChoice, 0x10
    breq is_pinkBlinking5
    isnt_pinkBlinking5:
        jmp done_pinkBlinking5
    is_pinkBlinking5:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_firstChoiceBlink2
    done_pinkBlinking5:

    cpi playerTwoFirstLEDChoice, 0x20
    breq is_blueBlinking5
    isnt_blueBlinking5:
        jmp done_blueBlinking5
    is_blueBlinking5:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_firstChoiceBlink2
    done_blueBlinking5:

done_firstChoiceBlink2:

cpi playerTwoOrderCount, 0x01
breq is_secondChoiceBlink2
isnt_secondChoiceBlink2:
    jmp done_secondChoiceBlink2
is_secondChoiceBlink2:

    cpi playerTwoSecondLEDChoice, 0x01
    breq is_redBlinking6
    isnt_redBlinking6:
        jmp done_redBlinking6
    is_redBlinking6:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_secondChoiceBlink2
    done_redBlinking6:

    cpi playerTwoSecondLEDChoice, 0x02
    breq is_greenBlinking6
    isnt_greenBlinking6:
        jmp done_greenBlinking6
    is_greenBlinking6:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_secondChoiceBlink2
    done_greenBlinking6:

    cpi playerTwoSecondLEDChoice, 0x04
    breq is_orangeBlinking6
    isnt_orangeBlinking6:
        jmp done_orangeBlinking6
    is_orangeBlinking6:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_secondChoiceBlink2
    done_orangeBlinking6:

    cpi playerTwoSecondLEDChoice, 0x08
    breq is_whiteBlinking6
    isnt_whiteBlinking6:
        jmp done_whiteBlinking6
    is_whiteBlinking6:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_secondChoiceBlink2
    done_whiteBlinking6:

    cpi playerTwoSecondLEDChoice, 0x10
    breq is_pinkBlinking6
    isnt_pinkBlinking6:
        jmp done_pinkBlinking6
    is_pinkBlinking6:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_secondChoiceBlink2
    done_pinkBlinking6:

    cpi playerTwoSecondLEDChoice, 0x20
    breq is_blueBlinking6
    isnt_blueBlinking6:
        jmp done_blueBlinking6
    is_blueBlinking6:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_secondChoiceBlink2
    done_blueBlinking6:

done_secondChoiceBlink2:

cpi playerTwoOrderCount, 0x02
breq is_thirdChoiceBlink2
isnt_thirdChoiceBlink2:
    jmp done_thirdChoiceBlink2
is_thirdChoiceBlink2:

    cpi playerTwoThirdLEDChoice, 0x01
    breq is_redBlinking7
    isnt_redBlinking7:
        jmp done_redBlinking7
    is_redBlinking7:
        cbi portB, 0
        rcall Delay
        sbi portB, 0
        jmp done_thirdChoiceBlink2
    done_redBlinking7:

    cpi playerTwoThirdLEDChoice, 0x02
    breq is_greenBlinking7
    isnt_greenBlinking7:
        jmp done_greenBlinking7
    is_greenBlinking7:
        cbi portB, 1
        rcall Delay
        sbi portB, 1
        jmp done_thirdChoiceBlink2
    done_greenBlinking7:

    cpi playerTwoThirdLEDChoice, 0x04
    breq is_orangeBlinking7
    isnt_orangeBlinking7:
        jmp done_orangeBlinking7
    is_orangeBlinking7:
        cbi portB, 2
        rcall Delay
        sbi portB, 2
        jmp done_thirdChoiceBlink2
    done_orangeBlinking7:

    cpi playerTwoThirdLEDChoice, 0x08
    breq is_whiteBlinking7
    isnt_whiteBlinking7:
        jmp done_whiteBlinking7
    is_whiteBlinking7:
        cbi portB, 3
        rcall Delay
        sbi portB, 3
        jmp done_thirdChoiceBlink2
    done_whiteBlinking7:

    cpi playerTwoThirdLEDChoice, 0x10
    breq is_pinkBlinking7
    isnt_pinkBlinking7:
        jmp done_pinkBlinking7
    is_pinkBlinking7:
        cbi portB, 4
        rcall Delay
        sbi portB, 4
        jmp done_thirdChoiceBlink2
    done_pinkBlinking7:

    cpi playerTwoThirdLEDChoice, 0x20
    breq is_blueBlinking7
    isnt_blueBlinking7:
        jmp done_blueBlinking7
    is_blueBlinking7:
        cbi portB, 5
        rcall Delay
        sbi portB, 5
        jmp done_thirdChoiceBlink2
    done_blueBlinking7:

done_thirdChoiceBlink2:

ret

CheckResults:
rcall SetupPortDLED
sbi portD, 7

cp playerTwoFirstLEDChoice, playerOneFirstLEDChoice
breq is_firstLEDEqual
isnt_firstLEDEqual:
    jmp done_firstLEDEqual
is_firstLEDEqual:
    ;rcall SetupPortDLED
    sbi portD, 4
    jmp done_firstLEDEqual
done_firstLEDEqual:

cp playerTwoFirstLEDChoice, playerOneSecondLEDChoice
breq is_firstLEDChoiceCorrect
isnt_firstLEDChoiceCorrect:
    jmp done_firstLEDChoiceCorrect
is_firstLEDChoiceCorrect:
    ;rcall SetupPortDLED
    sbi portD, 4
    rcall Delay
    cbi portD, 4
    rcall Delay
    sbi portD, 4
    rcall Delay
    cbi portD, 4
    jmp done_firstLEDChoiceCorrect
done_firstLEDChoiceCorrect:

cp playerTwoFirstLEDChoice, playerOneThirdLEDChoice
breq is_firstLEDChoiceCorrect1
isnt_firstLEDChoiceCorrect1:
    jmp done_firstLEDChoiceCorrect1
is_firstLEDChoiceCorrect1:
    ;rcall SetupPortDLED
    sbi portD, 4
    rcall Delay
    cbi portD, 4
    rcall Delay
    sbi portD, 4
    rcall Delay
    cbi portD, 4
    jmp done_firstLEDChoiceCorrect1
done_firstLEDChoiceCorrect1:

cp playerTwoSecondLEDChoice, playerOneSecondLEDChoice
breq is_secondLEDEqual
isnt_secondLEDEqual:
    jmp done_secondLEDEqual
is_secondLEDEqual:
    ;rcall SetupPortDLED
    sbi portD, 5
    jmp done_secondLEDEqual
done_secondLEDEqual:

cp playerTwoSecondLEDChoice, playerOneFirstLEDChoice
breq is_secondLEDChoiceCorrect
isnt_secondLEDChoiceCorrect:
   jmp done_secondLEDChoiceCorrect
is_secondLEDChoiceCorrect:
    ;rcall SetupPortDLED
    sbi portD, 5
    rcall Delay
    cbi portD, 5
    rcall Delay
    sbi portD, 5
    rcall Delay
    cbi portD, 5
    jmp done_secondLEDChoiceCorrect
done_secondLEDChoiceCorrect:

cp playerTwoSecondLEDChoice, playerOneThirdLEDChoice
breq is_secondLEDChoiceCorrect1
isnt_secondLEDChoiceCorrect1:
   jmp done_secondLEDChoiceCorrect1
is_secondLEDChoiceCorrect1:
	;rcall SetupPortDLED
    sbi portD, 5
    rcall Delay
    cbi portD, 5
    rcall Delay
    sbi portD, 5
    rcall Delay
    cbi portD, 5
    jmp done_secondLEDChoiceCorrect1
done_secondLEDChoiceCorrect1:

cp playerTwoThirdLEDChoice, playerOneThirdLEDChoice
breq is_thirdLEDEqual
isnt_thirdLEDEqual:
    jmp done_thirdLEDEqual
is_thirdLEDEqual:
    ;rcall SetupPortDLED
    sbi portD, 6
    jmp done_thirdLEDEqual
done_thirdLEDEqual:

cp playerTwoThirdLEDChoice, playerOneFirstLEDChoice
breq is_thirdLEDChoiceCorrect
isnt_thirdLEDChoiceCorrect:
    jmp done_thirdLEDChoiceCorrect
is_thirdLEDChoiceCorrect:
	;rcall SetupPortDLED
    sbi portD, 6
    rcall Delay
    cbi portD, 6
    rcall Delay
    sbi portD, 6
    rcall Delay
    cbi portD, 6
    jmp done_thirdLEDChoiceCorrect
done_thirdLEDChoiceCorrect:

cp playerTwoThirdLEDChoice, playerOneSecondLEDChoice
breq is_thirdLEDChoiceCorrect1
isnt_thirdLEDChoiceCorrect1:
    jmp done_thirdLEDChoiceCorrect1
is_thirdLEDChoiceCorrect1:
    ;rcall SetupPortDLED
    sbi portD, 6
    rcall Delay
    cbi portD, 6
    rcall Delay
    sbi portD, 6
    rcall Delay
    cbi portD, 6
    jmp done_thirdLEDChoiceCorrect1
done_thirdLEDChoiceCorrect1:

ret

; Incorrect guess - start player 2 up again
ResetPlayerTwo:
ldi isPlayerOneTurn, 0x01
ldi playerTwoOrderCount, 0x00

rcall Delay
checkForEnterPress:

	in r17, pinD
	ANDI r17, 0x0C

    cpi r17, 0x08
    breq is_enterPressedAgain
    isnt_enteredPressedAgain:
        jmp checkForEnterPress
    is_enterPressedAgain:
        ; Reset LED choices
        ldi playerTwoFirstLEDChoice, 0x00
        ldi playerTwoSecondLEDChoice, 0x00
        ldi playerTwoThirdLEDChoice, 0x00

        ; Reset LEDs
        cbi portD, 4
        cbi portD, 5
        cbi portD, 6

        jmp loop
    done_enterPressedAgain:

jmp checkForEnterPress
ret

; Flash LEDs if player two gets all player one guesses correct
Celebration:
rcall ClearPortDLED
cbi portD, 7

celebrationLoop:

    ; Blink green LEDs
    cbi portD, 4
    cbi portD, 5
    cbi portD, 6
    rcall Delay
    sbi portD, 4
    sbi portD, 5
    sbi portD, 6

    ; Blink input LEDs
    cbi portB, 0
    cbi portB, 1
    cbi portB, 2
    cbi portB, 3
    cbi portB, 4
    cbi portB, 5
    rcall Delay
    sbi portB, 0
    sbi portB, 1
    sbi portB, 2
    sbi portB, 3
    sbi portB, 4
    sbi portB, 5

jmp celebrationLoop

ret