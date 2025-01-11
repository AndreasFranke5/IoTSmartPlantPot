import time
import serial
import board
import busio
import RPi.GPIO as GPIO
import adafruit_ltr390

# Use GPIO.BCM numbering
PUMP_PIN = 17  # Physical pin #11
GPIO.setmode(GPIO.BCM)
GPIO.setup(PUMP_PIN, GPIO.OUT, initial=GPIO.LOW)

# I2C bus for LTR390
i2c = busio.I2C(board.SCL, board.SDA)
ltr = adafruit_ltr390.LTR390(i2c)

# Try opening Arduino's serial port
try:
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    ser.flush()
except:
    ser = None
    print("No Arduino found on /dev/ttyACM0. Continuing without moisture reading...")

try:
    while True:
        # Read UV sensor
        uv_index = ltr.uv_index
        lux = ltr.lux

        # Read moisture from Arduino
        moisture = None
        if ser and ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            if line.isdigit():
                moisture = int(line)

        # Simple logic to turn pump on if moisture is below a threshold
        if moisture is not None and moisture < 300:
            GPIO.output(PUMP_PIN, GPIO.HIGH)  # Pump on
        else:
            GPIO.output(PUMP_PIN, GPIO.LOW)   # Pump off

        # Print to console
        print(f"UV: {uv_index:.2f}, LUX: {lux:.2f}, Moisture: {moisture}")
        time.sleep(2)

except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()