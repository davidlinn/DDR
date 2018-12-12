from  gpiozero import LED, LEDBoard
from time import *
from omxplayer.player import OMXPlayer
from pathlib import Path
from OneThing import *

STEP3 = 19
STEP2 = 13
STEP1 = 6
STEP0 = 5
BPM_CLK = 26
RESET_PIN = 17

stepLeds = LEDBoard(STEP3, STEP2, STEP1, STEP0)
bpmClockLed = LED(BPM_CLK)
resetLed = LED(RESET_PIN)

def sendSteps():
	# pulse reset signal before sending over steps
	resetLed.on()
	resetLed.off()
	# calculate sleep amount outside loop
	sleepAmount = 30/OneThingBPM
	# asynchronously play audio
	player = OMXPlayer(Path(OneThingMP3Path))
	# send over steps
	for step in OneThingSteps:
		start = time()
		stepLeds.value = tuple(step)
		# pulse BPM clock 
		bpmClockLed.on()
		end = time()
		# sleep appropriately
		sleep(sleepAmount - (end - start))
		start = time()
		bpmClockLed.off()
		end = time()
		sleep(sleepAmount - (end - start))
	# make sure steps don't persist on led matrix
	stepLeds.value = tuple([0]*4)
