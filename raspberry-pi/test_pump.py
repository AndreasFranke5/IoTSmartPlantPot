#!/usr/bin/env python3

import time
import RPi.GPIO as GPIO

# Choose the BCM pin number that connects to the transistor gate
PUMP_PIN = 17  # physical pin #11 on the Pi's 40-pin header

# Setup
GPIO.setmode(GPIO.BCM)
GPIO.setup(PUMP_PIN, GPIO.OUT, initial=GPIO.LOW)

try:
    while True:
        # Turn pump ON
        print("Pump ON")
        GPIO.output(PUMP_PIN, GPIO.HIGH)
        time.sleep(2)

        # Turn pump OFF
        print("Pump OFF")
        GPIO.output(PUMP_PIN, GPIO.LOW)
        time.sleep(2)

except KeyboardInterrupt:
    print("Stopping test.")
finally:
    # Cleanup
    GPIO.cleanup()
