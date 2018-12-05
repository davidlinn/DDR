# Starter code taken from https://learn.adafruit.com/adafruit-mpr121-12-key-capacitive-touch-sensor-breakout-tutorial/python-circuitpython

# Simple test of the MPR121 capacitive touch sensor library.
# Will print out a message when any of the 12 capacitive touch inputs of the
# board are touched.  Open the serial REPL after running to see the output.
# Author: Tony DiCola
import time
import board
import busio
# Import MPR121 module.
import adafruit_mpr121

from gpiozero import LED, LEDBoard

# Create I2C bus.
i2c = busio.I2C(board.SCL, board.SDA)

# Create MPR121 class.
mpr121 = adafruit_mpr121.MPR121(i2c)

# we will output touches on GPIO Pins of the Pi
TOUCH3 = 21
TOUCH2 = 20
TOUCH1 = 16
TOUCH0 = 12

touchOut = LEDBoard(TOUCH3, TOUCH2, TOUCH1, TOUCH0)

# Loop forever testing each input and printing when they're touched.
while True:
	print(mpr121[6].value, mpr121[4].value, mpr121[2].value, mpr121[0].value)
	touchOut.value = (mpr121[6].value, mpr121[4].value, mpr121[2].value, mpr121[0].value)

