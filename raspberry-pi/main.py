#!/usr/bin/env python3

import time
import board
import busio
import RPi.GPIO as GPIO
import adafruit_ltr390

# Set up the GPIO pin for the water pump
PUMP_PIN = 17  # using BCM numbering for GPIO17

GPIO.setmode(GPIO.BCM)
GPIO.setup(PUMP_PIN, GPIO.OUT, initial=GPIO.LOW)

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)

# Initialize the LTR390 sensor
ltr = adafruit_ltr390.LTR390(i2c)

try:
    while True:
        # Read from the UV sensor
        uv_index = ltr.uv_index     # Approximate UV index
        lux = ltr.lux               # Ambient light in Lux (approx)

        # Example decision: If UV index is above some threshold, turn pump ON for a second
        # (In reality, your logic might use moisture or time-of-day, etc.)
        if uv_index > 1.0:
            GPIO.output(PUMP_PIN, GPIO.HIGH)
            time.sleep(1)
            GPIO.output(PUMP_PIN, GPIO.LOW)

        # Print sensor data to console
        print(f"UV Index: {uv_index:.2f}, Lux: {lux:.2f}")

        time.sleep(2)

except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()
