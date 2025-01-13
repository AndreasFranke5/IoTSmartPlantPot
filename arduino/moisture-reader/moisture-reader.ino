const int dryValue = 900;  // Replace with your calibrated dry value
const int wetValue = 450;  // Replace with your calibrated wet value

void setup() {
  Serial.begin(9600);
}

void loop() {
  int slot1MoistureVal = analogRead(A0);
  int slot2MoistureVal = analogRead(A1);
  int slot1TempVal = analogRead(A2);
  int slot2TempVal = analogRead(A3);

  int wetPercentageSlot1 = map(slot1MoistureVal, dryValue, wetValue, 0, 100);  // Map to percentage
  int wetPercentageSlot2 = map(slot2MoistureVal, dryValue, wetValue, 0, 100);  // Map to percentage
  
  // Constrain the percentage to avoid overflow or underflow
  wetPercentageSlot1 = constrain(wetPercentageSlot1, 0, 100);
  wetPercentageSlot2 = constrain(wetPercentageSlot2, 0, 100);

  float voltage = slot1TempVal * (5.0 / 1023.0);  // Convert to voltage (assuming 5V reference)
  float temperatureC = (voltage - 0.5) * 100.0;  // Convert to Celsius


  Serial.print(temperatureC);
  Serial.print(",0");

  Serial.print("|");
  Serial.print(wetPercentageSlot1);
  Serial.print(",");
  Serial.println(wetPercentageSlot2);
  delay(2000);
}
