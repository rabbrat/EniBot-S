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

// RADAR CONFIG
const int RADAR_STEPS = 15;
const int RADAR_READINGS = 12;
const int RADAR_READINGS_DELAY = 120;

// H-BRIDGE CONFIG
// ACELERATION
const int FORWARD_ACELERATION = 10;
const int BRAKE_ACELERATION = 10;
const int TURN_LEFT_ACELERATION = 10;
const int TURN_RIGHT_ACELERATION = 10;
// ACELERATION DELAY (µs)
const int FORWARD_ACELERATION_DELAY = 5;
const int BRAKE_ACELERATION_DELAY = 5;
const int TURN_LEFT_ACELERATION_DELAY = 5;
const int TURN_RIGHT_ACELERATION_DELAY = 5;
// MAX VELOCITY
const int MAX_FORWARD_VELOCITY = 100;
const int MAX_TURN_LEFT_VELOCITY = 100;
const int MAX_TURN_RIGHT_VELOCITY = 100;

// DEVICES
Servo radarServo;

// GLOBAL VARIABLES
int velocity;

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
  pinMode(ENABLE_B_PIN, OUTPUT);
  pinMode(IN_A1_PIN, OUTPUT);
  pinMode(IN_A2_PIN, OUTPUT);
  pinMode(IN_B1_PIN, OUTPUT);
  pinMode(IN_B2_PIN, OUTPUT);
  pinMode(ENABLE_A_PIN, OUTPUT);
    
  // INITIALIZATION
  radarServo.write(0);
  
  // SERIAL COM
  Serial.begin(9600);
}

void loop() {
  float distances[RADAR_READINGS];
  float distances1[RADAR_READINGS];

  getRadar(0, 180, distances);
  printRadar(0, 180, distances, RADAR_READINGS);
  getRadar(180, 0, distances1);
  printRadar(180, 0, distances1, RADAR_READINGS);
}

float* getRadar(int startAngle, int endAngle, float* distances) {
  int pos;
  int i;

  if(startAngle < endAngle) {
    for(pos = startAngle; pos <= endAngle; pos+=RADAR_STEPS) {
      distances[i] = getUltrasonicDistance();
      radarServo.write(pos);
      i++;
      delay(RADAR_READINGS_DELAY);
    }    
  } else {
    for(pos = startAngle; pos >= endAngle; pos-=RADAR_STEPS) {
      distances[i] = getUltrasonicDistance();
      radarServo.write(pos);
      i++;
      delay(RADAR_READINGS_DELAY);
    }
  }

  return distances;
}

float getUltrasonicDistance() {
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  return pulseIn(ECHO_PIN, HIGH) / 58.2;
}

void moveForward() {
  for(int i = 0; i <= MAX_FORWARD_VELOCITY; i+=FORWARD_ACELERATION) {
    velocity = i;
    moveForward(velocity);
    delayMicroseconds(FORWARD_ACELERATION_DELAY);
  }
}

void brake() {
  for(int i = velocity; i > 0; i-=BRAKE_ACELERATION) {
    velocity = i;
    brake(velocity);
    delayMicroseconds(BRAKE_ACELERATION_DELAY);
  }
}

void turnLeft() {
  for(int i = 0; velocity <= MAX_TURN_LEFT_VELOCITY; velocity+=TURN_LEFT_ACELERATION) { 
    velocity = i;
    turnLeft(velocity);
    delayMicroseconds(TURN_LEFT_ACELERATION_DELAY);
  }
}

void turnRight() {
  for(int i = 0; velocity <= MAX_TURN_RIGHT_VELOCITY; velocity+=TURN_RIGHT_ACELERATION) {
    velocity = i;
    turnRight(velocity);
    delayMicroseconds(TURN_RIGHT_ACELERATION_DELAY);
  }
}

void moveForward(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, HIGH);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, HIGH);
  digitalWrite(IN_B2_PIN, LOW);
}

void brake(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, LOW);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, LOW);
  digitalWrite(IN_B2_PIN, LOW);
}

void turnLeft(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, HIGH);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, LOW);
  digitalWrite(IN_B2_PIN, HIGH);
}

void turnRight(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, LOW);
  digitalWrite(IN_A2_PIN, HIGH);
  digitalWrite(IN_B1_PIN, HIGH);
  digitalWrite(IN_B2_PIN, LOW);
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
