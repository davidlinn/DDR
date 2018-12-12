# Starter code taken from https://learn.adafruit.com/adafruit-mpr121-12-key-capacitive-touch-sensor-breakout-tutorial/python-circuitpython

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
TOUCH_LEFT = 12
TOUCH_DOWN = 16
TOUCH_UP = 20
TOUCH_RIGHT = 21

touchOut = LEDBoard(TOUCH_LEFT, TOUCH_DOWN, TOUCH_UP, TOUCH_RIGHT)

# Loop forever testing each input and printing when they're touched.
while True:
	print(mpr121[0].value, mpr121[2].value, mpr121[4].value, mpr121[6].value)
	touchOut.value = (mpr121[0].value, mpr121[2].value, mpr121[4].value, mpr121[6].value)

