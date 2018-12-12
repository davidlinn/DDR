# DDR
Custom hardware version of Dance Dance Revolution that takes player input with capacitive touch sensors. Dance pad must have 4 conductive pads and user must play barefoot or with thin socks. Benefits of this approach over commonly-used limit switch contact sensors include avoidance of switch bounce, mechanical robustness of sensing, and the ability to register light taps.

Raspberry Pi accepts player input from capacitive touch sensor breakout via I2C and continually outputs binary pressed/not pressed over GPIO. Pi simultaneously plays music and sends steps via GPIO to FPGA. FPGA displays steps on a 8x8 LED matrix, performs scoring algorithm, provides instant feedback via red and green LEDs, and displays HEX score on a double 7-segment display.
