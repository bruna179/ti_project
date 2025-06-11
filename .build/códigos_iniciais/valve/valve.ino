int valvula = 8;  

void setup() {
  pinMode(valvula, OUTPUT);
  digitalWrite(valvula, HIGH); 
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    char comando = Serial.read();

    if (comando == 'd') {
      digitalWrite(valvula, LOW); 
      Serial.println("Válvula Fechada");
    } else if (comando == 'r') {
      digitalWrite(valvula, HIGH); 
      Serial.println("Válvula Aberta");
    } 
  }
}






