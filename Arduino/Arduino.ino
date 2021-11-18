#include<Servo.h>

// TURN-ON/OFF BUTTON
#define TURN_BTN_PIN 2
// TCRT5000 MODULES
#define TCRT_LEFT_PIN 3
#define TCRT_RIGHT_PIN 4
// HC-SR04
#define ECHO_PIN 5
#define TRIG_PIN 6
// SG90
#define RADAR_SERVO_PIN 7
// L298N
#define ENABLE_B_PIN 8
#define IN_A1_PIN 9
#define IN_A2_PIN 10
#define IN_B1_PIN 11
#define IN_B2_PIN 12
#define ENABLE_A_PIN 13

Servo radarServo;

void setup() {
    // ATTACH
  radarServo.attach(RADAR_SERVO_PIN);

  // INPUT PIN DEFINITION
  pinMode(TURN_BTN_PIN, INPUT);
  pinMode(TCRT_LEFT_PIN, INPUT);
  pinMode(TCRT_RIGHT_PIN, INPUT);
  pinMode(ECHO_PIN, INPUT);

  // OUTPUT PIN DEFINITION
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(RADAR_SERVO_PIN, OUTPUT);
    
  // INITIALIZATION
  radarServo.write(0);
  
  // SERIAL COM
  Serial.begin(9600);
}

void loop() {
}

float* getRadar(int startAngle, int endAngle, float* distances) {
  int pos;
  int i;

  if(startAngle < endAngle) {
    for(pos = startAngle; pos <= endAngle; pos+=15) {
      distances[i] = getUltrasonicDistance();
      radarServo.write(pos);
      i++;
      delay(150);
    }    
  } else {
    for(pos = startAngle; pos >= endAngle; pos-=15) {
      distances[i] = getUltrasonicDistance();
      radarServo.write(pos);
      i++;
      delay(150);
    }
  }

  return distances;
}

float getUltrasonicDistance() {
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  // Calculating the distance in cm
  return pulseIn(ECHO_PIN, HIGH) / 58.2;
}

void printRadar(int startAngle, int endAngle, float* distances, int arrSize) {
  Serial.print("Radar");
  Serial.print("(");
  Serial.print(startAngle);
  Serial.print("°");
  Serial.print(" to ");
  Serial.print(endAngle);
  Serial.print("°");
  Serial.print(")");

  Serial.print("[");
  for(int i = 0; i < arrSize; i++) {
    Serial.print(distances[i]);
    if(i < arrSize - 1) Serial.print(" cm, ");
    else Serial.print(" cm");
  }
  Serial.println("]");
}
