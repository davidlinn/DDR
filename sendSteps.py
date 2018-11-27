from  gpiozero import LED, LEDBoard
from time import sleep

STEP3 = 19
STEP2 = 13
STEP1 = 6
STEP0 = 5
BPM_CLK = 26
BPM = 128
RESET_PIN = 17

stepLeds = LEDBoard(STEP3, STEP2, STEP1, STEP0)
bpmClockLed = LED(BPM_CLK)
steps = [
	[0, 1, 1, 0],
	[1, 1, 1, 1],
	[0, 0, 0, 1],
	[1, 0, 1, 0],
	[0, 1, 1, 0]
]
testStep = [
[1,0,0,0],
[0,0,0,0],
[0,0,0,0],
[0,0,0,0],
[0,0,0,0]]
resetLed = LED(RESET_PIN)

def sendSteps():
	# pulse reset signal before sending over steps
	resetLed.on()
	resetLed.off()
	# send over steps
	for step in steps:
		stepLeds.value = tuple(step)
		bpmClockLed.on()
		sleep(60/128)
		bpmClockLed.off()
		sleep(60/128)
	stepLeds.value = tuple([0]*4)
