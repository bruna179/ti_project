#include "DHT.h"
#define DHTPIN 2
#define DHTTYPE DHT22
#define ldrPin A2
//#define relePin 8
#define redPin 3
#define greenPin 4
#define bluePin 5

DHT dht(DHTPIN, DHTTYPE);
String comando = "";

int valvula = 8;
bool valvulaAberta = false;

void setup() {
  Serial.begin(9600);
  dht.begin(); 
  pinMode(ldrPin, INPUT); 
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  //pinMode(relePin, OUTPUT);
  //digitalWrite(relePin, HIGH); 
  pinMode(valvula, OUTPUT);
  digitalWrite(valvula, HIGH);  
}
void loop() {
  delay(2000);


  float humi = dht.readHumidity();
  float tempC = dht.readTemperature();
  int soilHumi = analogRead(A0);
  int light = analogRead(ldrPin);


  
 if (Serial.available()) {
    char comand = Serial.read();

    if (comand == 'd' && valvulaAberta) {
      digitalWrite(valvula, LOW); 
      Serial.println("Válvula Fechada");
      valvulaAberta = false;
    } else if (comand == 'r' && !valvulaAberta) {
      digitalWrite(valvula, HIGH); 
      Serial.println("Válvula Aberta");
      valvulaAberta = true;
    } 
  }

  while (Serial.available()) {
    char c = Serial.read();
    if (c == '\n') {
      comando.trim();
      if (comando == "verde") {
        digitalWrite(redPin, LOW);
        digitalWrite(greenPin, HIGH);
        digitalWrite(bluePin, LOW);
      } else if (comando == "vermelho") {
        digitalWrite(redPin, HIGH);
        digitalWrite(greenPin, LOW);
        digitalWrite(bluePin, LOW);
      }
      comando = "";
    } else {
      comando += c;
    }
  }


  if (!isnan(humi) && !isnan(tempC)) {
    if (soilHumi > 550 && !valvulaAberta) {  
      digitalWrite(valvula, HIGH);
      valvulaAberta = true;
      Serial.println("Abre válvula (solo seco)");
    }
    else if (soilHumi < 450 && valvulaAberta) { 
      digitalWrite(valvula, LOW);
      valvulaAberta = false;
      Serial.println("Fechou válvula (solo adequado)");
    }
    
  
    Serial.print(humi); Serial.print(",");
    Serial.print(tempC); Serial.print(",");
    Serial.print(soilHumi); Serial.print(",");
    Serial.println(light);
  }
  else {
    Serial.println("Erro na leitura do DHT!");
  }
}