# Imports for MQTT
import time,datetime,busio,board,serial,random,json,requests,time
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
import RPi.GPIO as GPIO
import adafruit_ltr390

# Using decimal to round the value for lux :)
from decimal import Decimal

# Use GPIO.BCM numbering
PUMP_PIN = 18  # Physical pin #11
GPIO.setmode(GPIO.BCM)
GPIO.setup(PUMP_PIN, GPIO.OUT, initial=GPIO.HIGH)

# I2C bus for LTR390
i2c = busio.I2C(board.SCL, board.SDA)
ltr = adafruit_ltr390.LTR390(i2c)

# Try opening Arduino's serial port
try:
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    ser.flush()
except:
    ser = None
    print("No Arduino found on /dev/ttyACM0. Continuing without arduino reading...")

broker = "broker.emqx.io"  # Broker
pub_topic = "SMART-PLANT-POT"  # send messages to this topic

device_id = "c2e3e3e4-40d6-4172-b8f2-91ae849d66f3"
slot_ids = [
    "ecb5f1b3-4cad-49cb-8d35-fc19a3c4ef3c", # slot 1
    "a5bfda2b-8095-454a-bbf7-d5c7de932529" # slot 2
]

############### MQTT section ##################

# when connecting to mqtt do this;
def on_connect(client, userdata, flags, rc):
    if rc==0:
        print("Connection established. Code: "+str(rc))
    else:
        print("Connection failed. Code: " + str(rc))

def on_publish(client, userdata, mid):
    print("Published: " + str(mid))

def on_disconnect(client, userdata, rc):
    if rc != 0:
        print ("Unexpected disonnection. Code: ", str(rc))
    else:
        print("Disconnected. Code: " + str(rc))

def on_log(client, userdata, level, buf): # Message is in buf
    print("MQTT Log: " + str(buf))


# Connect functions for MQTT
client = mqtt.Client()
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_publish = on_publish
client.on_log = on_log

# Connect to MQTT 
print("Attempting to connect to broker " + broker)
client.connect(broker) # Broker address, port and keepalive (maximum period in seconds allowed between communications with the broker)
client.loop_start()

tries_count = 0

def publishMqttData(data, slotId):
    client.publish(pub_topic+"-"+slotId, data)

        
def sendSlotDataToServer(data, slotId):
    data["slotId"] = slotId;
    response = requests.post(
        url = "https://us-central1-smart-plant-pot-iot.cloudfunctions.net/sendPlantUpdates",
        json = data,
    )
    # responseData = response.json()
    # print(json.dumps(responseData, indent=4, sort_keys=True))
    # print(data)
    print(response.json())
    # Simple logic to turn pump on if moisture is below a threshold
    if response.json() is not None and "startPump" in response.json() and response.json()["startPump"]:
        print("[Watering....]")
        GPIO.output(PUMP_PIN, GPIO.LOW)  # Pump on
        time.sleep(2)
        GPIO.output(PUMP_PIN, GPIO.HIGH)   # Pump off
        print("[Watering done.]")
        
try:
    while True:
        # Read moisture from Arduino
        arduino_values = None
        
        # Read UV sensor
        uv_values = [ltr.uvi, 0]
        lux_values = [ltr.lux, 0]
        
        temp_values = None
        moisture_values = None
        if ser and ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            # moisture_values = [int(x) for x in line.split(",")]
            temp_values_set, moist_values_set = line.split('|')
            if temp_values_set is not None and moist_values_set is not None:
                temp_values = temp_values_set.split(',')
                moisture_values = moist_values_set.split(',')
        
        
        currentSlotNumber = 1
        for slot_id in slot_ids:  # Loop through each slot_id
            if currentSlotNumber < len(slot_ids):
                currentSlotNumber += 1
            else:
                currentSlotNumber = 1

            # Print to console
            # print(f"UV: {uv_index:.2f}, LUX: {lux:.2f}, Moisture: {moisture}")
            # time.sleep(2)
            # data_to_send = "CALL-SENSOR-FUNCTION" # Here, call the correct function from the sensor section depending on sensor
            # client.publish(pub_topic, str(data_to_send))
            # client.publish(pub_topic, str(f"UV: {uv_index:.2f}, LUX: {lux:.2f}, Moisture: {moisture}"))
            # client.publish(pub_topic, {"id":"123"})
            # temperature = round(random.uniform(20.1, 22.2), 1)
            
            index = currentSlotNumber-1
            moist = None
            if moisture_values is not None:
                moist = float(moisture_values[index]);
            temperature = -100
            if temp_values is not None:
                temperature = float(temp_values[index]);
                
                # # Simple logic to turn pump on if moisture is below a threshold
                # if moist is not None and moist < 300:
                #     GPIO.output(PUMP_PIN, GPIO.HIGH)  # Pump on
                # else:
                #     GPIO.output(PUMP_PIN, GPIO.LOW)   # Pump off             
            payload = {
                "deviceId": device_id,
                "slotId": slot_id,
                "temperature": round(temperature,1),
                "moisture": moist,
                "uv": round(uv_values[index],2), # random.randint(10, 100),
                "lux": round(lux_values[index],2)
            }
            payload_str = json.dumps(payload)
            print(payload_str)
            if tries_count == 0:
                sendSlotDataToServer(payload, slot_id)
            publishMqttData(payload_str, slot_id)
        
        if tries_count < 15:
            tries_count += 1
        else:
            tries_count = 0
        time.sleep(2) # Set delay

except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()