#include<LowPower.h>
#include<Servo.h>

// TURN-ON/OFF BUTTON
#define TURN_BTN_PIN 3
// HC-SR04
#define ECHO_PIN 4
#define TRIG_PIN 5
// SG90
#define RADAR_SERVO_PIN 6
// TCRT5000 MODULES
#define TCRT_LEFT_PIN 20
#define TCRT_RIGHT_PIN 21
// L298N
#define ENABLE_B_PIN 8
#define IN_A1_PIN 9
#define IN_A2_PIN 10
#define IN_B1_PIN 11
#define IN_B2_PIN 12
#define ENABLE_A_PIN 13

// TURN-ON/OFF BUTTON CONFIG
const int TURN_THRESHOLD = 250;

// RADAR CONFIG
const int RADAR_STEPS = 15;
const int RADAR_READINGS = 12;
const int RADAR_READINGS_DELAY = 120;
const int MAX_RADAR_DISTANCE = 120;

// TCRT CONFIG
const int LEFT_TCRT_THRESHOLD = 150;
const int RIGHT_TCRT_THRESHOLD = 150;

// H-BRIDGE CONFIG
// ACELERATION
const int BRAKE_ACELERATION = 10;
const int BACKWARD_ACELERATION = 10;
const int FORWARD_ACELERATION = 10;
const int TURN_LEFT_ACELERATION = 10;
const int TURN_RIGHT_ACELERATION = 10;
// ACELERATION DELAY (µs)
const int BRAKE_ACELERATION_DELAY = 5;
const int BACKWARD_ACELERATION_DELAY = 5;
const int FORWARD_ACELERATION_DELAY = 5;
const int TURN_LEFT_ACELERATION_DELAY = 5;
const int TURN_RIGHT_ACELERATION_DELAY = 5;
// MAX VELOCITY
const int MAX_BACKWARD_VELOCITY = 100;
const int MAX_FORWARD_VELOCITY = 100;
const int MAX_TURN_LEFT_VELOCITY = 100;
const int MAX_TURN_RIGHT_VELOCITY = 100;

// DEVICES
Servo radarServo;

// GLOBAL VARIABLES
volatile boolean canceled = true;
volatile boolean leftTCRT = false;
volatile boolean rightTCRT = false;
long leftTCRTMillis = 0;
long rightTCRTMillis = 0;
long turnMillis = 0;
int velocity = 0;

void setup() {
  // INPUT PIN DEFINITION
  pinMode(TURN_BTN_PIN, INPUT_PULLUP);
  pinMode(TCRT_LEFT_PIN, INPUT_PULLUP);
  pinMode(TCRT_RIGHT_PIN, INPUT_PULLUP);
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

  // ATTACH INTERRUPT
  attachInterrupt(digitalPinToInterrupt(TURN_BTN_PIN), updateTurn, FALLING);
  attachInterrupt(digitalPinToInterrupt(TCRT_LEFT_PIN), updateLeftTCRT, RISING);
  attachInterrupt(digitalPinToInterrupt(TCRT_RIGHT_PIN), updateRightTCRT, RISING);
    
  // INITIALIZATION
  radarServo.attach(RADAR_SERVO_PIN);
  radarServo.write(0);

  // SERIAL COM
  Serial.begin(9600);
}

void loop() {
  
  if(canceled) {
    // Warning: Compatible only with ARDUINO MEGA 2560
    LowPower.idle(SLEEP_FOREVER, ADC_OFF, TIMER5_ON, TIMER4_OFF, TIMER3_ON, TIMER2_ON, TIMER1_ON, TIMER0_ON, SPI_OFF, USART3_OFF, USART2_OFF, USART1_OFF, USART0_OFF, TWI_OFF);
  } else {
    float distances[RADAR_READINGS] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    getRadar(0, 180, distances);
    printRadar(0, 180, distances, RADAR_READINGS);

    int index = -1;
    float least = -1;
    for(int i = 0; i < RADAR_READINGS; i++) {
      float distance = distances[i];
      if(distance > MAX_RADAR_DISTANCE) continue;
      else if(least = -1 || distance < least) {
        index = i;
        least = distance;
      }
    }
    Serial.print("Least at index ");
    Serial.print("(");
    Serial.print(index);
    Serial.print("): ");
    Serial.println(least);

    if(index == -1 && least == -1) {
      moveRight();
      delay(500);
    } else if(index >= 5 || index <= 7) {
      moveForward();
      delay(150);
    } else if(index < 5) {
      moveRight();
      delay(150);
    } else if(index > 7) {
      moveLeft();
      delay(150);
    } 
  }
}

float* getRadar(int startAngle, int endAngle, float* distances) {
  int pos;
  int i;

  if(startAngle < endAngle) {
    for(pos = startAngle; pos <= endAngle; pos+=RADAR_STEPS) {
      if(canceled) break;
      distances[i] = getUltrasonicDistance();
      radarServo.write(pos);
      i++;
      delay(RADAR_READINGS_DELAY);
    }    
  } else {
    for(pos = startAngle; pos >= endAngle; pos-=RADAR_STEPS) {
      if(canceled) break;
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

void brake() {
  for(int i = velocity; i > 0; i-=BRAKE_ACELERATION) {
    velocity = i;
    brake(velocity);
    delayMicroseconds(BRAKE_ACELERATION_DELAY);
  }
}

void moveBackward() {
  for(int i = 0; i <= MAX_BACKWARD_VELOCITY; i+=BACKWARD_ACELERATION) {
    velocity = i;
    moveBackward(velocity);
    delayMicroseconds(BACKWARD_ACELERATION_DELAY);
  }
}

void moveForward() {
  for(int i = 0; i <= MAX_FORWARD_VELOCITY; i+=FORWARD_ACELERATION) {
    velocity = i;
    moveForward(velocity);
    delayMicroseconds(FORWARD_ACELERATION_DELAY);
  }
}

void moveLeft() {
  for(int i = 0; velocity <= MAX_TURN_LEFT_VELOCITY; velocity+=TURN_LEFT_ACELERATION) { 
    velocity = i;
    moveLeft(velocity);
    delayMicroseconds(TURN_LEFT_ACELERATION_DELAY);
  }
}

void moveRight() {
  for(int i = 0; velocity <= MAX_TURN_RIGHT_VELOCITY; velocity+=TURN_RIGHT_ACELERATION) {
    velocity = i;
    moveRight(velocity);
    delayMicroseconds(TURN_RIGHT_ACELERATION_DELAY);
  }
}

void brake(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, LOW);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, LOW);
  digitalWrite(IN_B2_PIN, LOW);
}

void moveBackward(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, LOW);
  digitalWrite(IN_A2_PIN, HIGH);
  digitalWrite(IN_B1_PIN, LOW);
  digitalWrite(IN_B2_PIN, HIGH);
}

void moveForward(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, HIGH);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, HIGH);
  digitalWrite(IN_B2_PIN, LOW);
}

void moveLeft(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, HIGH);
  digitalWrite(IN_A2_PIN, LOW);
  digitalWrite(IN_B1_PIN, LOW);
  digitalWrite(IN_B2_PIN, HIGH);
}

void moveRight(int velocity) {
  analogWrite(ENABLE_A_PIN, velocity);
  analogWrite(ENABLE_B_PIN, velocity);
  digitalWrite(IN_A1_PIN, LOW);
  digitalWrite(IN_A2_PIN, HIGH);
  digitalWrite(IN_B1_PIN, HIGH);
  digitalWrite(IN_B2_PIN, LOW);
}

void printRadar(int startAngle, int endAngle, float* distances, int arrSize) {

  if(canceled) return;
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

void updateLeftTCRT() {
  if(millis() - leftTCRTMillis > LEFT_TCRT_THRESHOLD) {
    leftTCRT = true;
    leftTCRTMillis = millis();
  }
}

void updateRightTCRT() {
  if(millis() - rightTCRTMillis > RIGHT_TCRT_THRESHOLD) {
    rightTCRT = true;
    rightTCRTMillis = millis();
  }
}

void updateTurn() {
  if(millis() - turnMillis > TURN_THRESHOLD) {
    canceled = !canceled;
    turnMillis = millis();
  }
}
