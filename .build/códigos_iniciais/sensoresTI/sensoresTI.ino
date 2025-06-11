#include "DHT.h"
#define DHTPIN 2
#define DHTTYPE DHT22
#define ldrPin A2

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin(); 
  pinMode(ldrPin, INPUT); 
}

void loop() {
  
  delay(2000);

  // read air humidity
  float humi  = dht.readHumidity();
  // read temperature as Celsius
  float tempC = dht.readTemperature();
  // read temperature as Fahrenheit
  float tempF = dht.readTemperature(true);
  // read soil humidity
  int soilHumi = analogRead(A0);
  //read light intensity
  int light = analogRead(ldrPin); 

  
  if (isnan(humi) || isnan(tempC) || isnan(tempF)) {
    Serial.println("Failed to read from DHT sensor!");
  } else {
    Serial.print(humi);
    Serial.print(",");
    Serial.print(tempC);
    Serial.print(",");

  }
    Serial.print(soilHumi);
    Serial.print(",");

    Serial.println(light);
}
