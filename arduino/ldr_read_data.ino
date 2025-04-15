#include <Arduino.h>
#include <ArduinoBLE.h>

BLEService ledService("19b10000-e8f2-537e-4f6c-d104768a1214");
BLEService buzzerService("19b10010-e8f2-537e-4f6c-d104768a1214");
BLEService ldrService("19b10020-e8f2-537e-4f6c-d104768a1214");
BLEByteCharacteristic ledCharacteristic("19b10001-e8f2-537e-4f6c-d104768a1214", BLEWrite);
BLEByteCharacteristic buzzerCharacteristic("19b10011-e8f2-537e-4f6c-d104768a1214", BLEWrite);
BLEIntCharacteristic ldrCharacteristic("19b10021-e8f2-537e-4f6c-d104768a1214", BLERead | BLENotify);

const int butonLedPin = 8;
const int butonBuzzerPin = 9;
const int ANALOG_READ_PIN = 2;
const int RED_LED_PIN = 3;  
const int RESOLUTION = 12;
const int BUZZER_PIN = 10;

byte ledMode = 0; 
byte buzzerMode = 0;

void setup() {
  Serial.begin(9600); 
  pinMode(RED_LED_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(butonLedPin, INPUT_PULLUP);
  pinMode(butonBuzzerPin, INPUT_PULLUP);


  analogReadResolution(RESOLUTION); 

  BLE.begin();                      
  BLE.setLocalName("ESP32C3-BLE-LED");
  BLE.setDeviceName("ESP32C3-BLE-LED");
  BLE.setAdvertisedService(ledService);
  BLE.setAdvertisedService(buzzerService);
  BLE.setAdvertisedService(ldrService);

  ledService.addCharacteristic(ledCharacteristic);
  buzzerService.addCharacteristic(buzzerCharacteristic);
  ldrService.addCharacteristic(ldrCharacteristic);
  BLE.addService(ledService);
  BLE.addService(buzzerService);
  BLE.addService(ldrService);

  BLE.advertise();                 
}

void sound(int time){
  digitalWrite(BUZZER_PIN, HIGH);
  delay(time);
  digitalWrite(BUZZER_PIN, LOW);
  delay(time);
}

void sosSoundForBuzzer(){
  delay(1500);
  int i = 0;
  for(i = 0; i < 3; i++){
    sound(100);
  }
  for(i = 0; i < 3; i++){
    sound(300);
  }
  for(i = 0; i < 3; i++){
    sound(100);
  }
}


void controleazaBuzzerButon(){
  if(buzzerMode == 0){
    buzzerMode = 1;
  }else{
    buzzerMode = 0;
  }
}

bool stareCurenta = HIGH;
bool stareAnterioara = HIGH;
bool butonApasat = false;
bool ledState = false;
bool buzzerState = false;

void loop() {

  if (digitalRead(butonLedPin) == LOW) { 
      delay(50);              
      ledState = !ledState;               
      digitalWrite(RED_LED_PIN, ledState);             
  } 

  if (digitalRead(butonBuzzerPin) == LOW) { 
      delay(50);              
      buzzerState = !buzzerState; 
      if(buzzerState){
        sosSoundForBuzzer();
      }else{
        digitalWrite(BUZZER_PIN, LOW);           
      }
  } 

  BLEDevice central = BLE.central(); 

    if (central) {                     
      while (central.connected()) {   
    
      if (ledCharacteristic.written()) { 
        ledMode = ledCharacteristic.value(); 
      }

      if (buzzerCharacteristic.written()) { 
        buzzerMode = buzzerCharacteristic.value(); 
      }

      if (ledMode == 0) {
        digitalWrite(RED_LED_PIN, LOW);
      } 
      else if (ledMode == 1) {
        digitalWrite(RED_LED_PIN, HIGH);
        ledState = !ledState;
      } 
      else if (ledMode == 2) {
        int ldrVal = analogRead(ANALOG_READ_PIN);
        ldrCharacteristic.writeValue(ldrVal);
        
        Serial.print("LDR Value: ");
        Serial.println(ldrVal);

        if (ldrVal > 2000) {
          digitalWrite(RED_LED_PIN, HIGH);
        } else {
          digitalWrite(RED_LED_PIN, LOW);
        }
      }

      if(buzzerMode == 1){
        sosSoundForBuzzer();
      }else{
        digitalWrite(BUZZER_PIN, LOW);
      }

      delay(100); 
    }

    digitalWrite(RED_LED_PIN, LOW);
    ledMode = 0; 
  }
}