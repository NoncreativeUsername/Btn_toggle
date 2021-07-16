.text
.global main

//switch and led addresses
.set LED_CTL, 0x41210000
.set BTN_DATA, 0x41200000

main:
	ldr r1,=BTN_DATA			//button address in r1
	ldr r2,=LED_CTL				//led address in r2
	mov r3, #0					//counter for debounce
	mov r5, #0					//previous button state
	mov r6, #0					//toggle value

loop:
	ldr r4, [r1]				//load button data into r4
	and r4, #0x1				//mask all buttons except 1

	cmp r4, #0
	moveq r3, #0				//if button 0 clear debounce counter
	moveq r5, #0				//set last button state to 0
	beq loop					//if button is 0, do nothing, go to start

	cmp r3, #0xA
	addlt r3, r3, #1			//increment counter if r3 less than 10
	blt loop					//do nothing untill debounce counter is filled

	cmp r4, r5
	movgt r5, #1				//set previous state to 1 if button is pressed
	eorgt r6, #0b1				//xor toggle value with 1 to toggle if button is one and previosly was 0

	str r6, [r2]				//store toggle value to led address

	b loop						//restart loop at end

.end
