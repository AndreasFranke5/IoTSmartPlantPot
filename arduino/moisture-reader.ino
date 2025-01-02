void setup() {
  Serial.begin(9600); // 9600 baud for simple serial monitoring
}

void loop() {
  int moistureValue = analogRead(A0); // 0–1023 on Arduino Uno
  Serial.println(moistureValue);
  delay(1000); // wait 1 second
}
