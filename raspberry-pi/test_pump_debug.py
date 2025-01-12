#!/usr/bin/env python3

import time
import RPi.GPIO as GPIO

# -------------------------
# CONFIGURATION
# -------------------------
PUMP_PIN = 17       # BCM numbering. Physical pin #11 on the Pi's 40-pin header.
TOGGLE_INTERVAL = 2  # Seconds ON, then OFF, etc.

# If you want to mute "channel is already in use" warnings:
GPIO.setwarnings(False)

def setup_gpio():
    """
    Sets up the Raspberry Pi GPIO mode and the pump control pin as output.
    """
    print("[DEBUG] Setting GPIO mode to BCM.")
    GPIO.setmode(GPIO.BCM)
    
    print(f"[DEBUG] Setting pin BCM {PUMP_PIN} as OUTPUT, initial=LOW.")
    GPIO.setup(PUMP_PIN, GPIO.OUT, initial=GPIO.LOW)
    print("[DEBUG] GPIO setup complete.\n")

def main_loop():
    """
    Main loop that toggles the pump ON for TOGGLE_INTERVAL seconds,
    then OFF for TOGGLE_INTERVAL seconds, repeatedly.
    """
    state = False  # track whether the pump should be ON (True) or OFF (False)

    print("[DEBUG] Entering main toggle loop.")
    print("[DEBUG] Use CTRL+C to exit.\n")

    while True:
        # Toggle state
        state = not state
        
        # If state is True -> set pin HIGH, else LOW
        if state:
            print(f"[DEBUG] Setting pump pin {PUMP_PIN} HIGH => Attempting to turn pump ON.")
            GPIO.output(PUMP_PIN, GPIO.HIGH)
        else:
            print(f"[DEBUG] Setting pump pin {PUMP_PIN} LOW => Attempting to turn pump OFF.")
            GPIO.output(PUMP_PIN, GPIO.LOW)

        # Debugging delay
        print(f"[DEBUG] Waiting {TOGGLE_INTERVAL} seconds. "
              "Measure transistor Gate & Drain, check pump physically.\n")
        time.sleep(TOGGLE_INTERVAL)

def cleanup():
    """
    Cleans up the GPIO to avoid warnings or channel-in-use errors if re-run.
    """
    print("\n[DEBUG] Cleaning up GPIO and exiting.")
    GPIO.cleanup()

if __name__ == "__main__":
    try:
        print("[DEBUG] Starting test_pump_debug script...")
        setup_gpio()
        main_loop()
    except KeyboardInterrupt:
        print("\n[DEBUG] Caught CTRL+C, stopping main loop.")
    finally:
        cleanup()
