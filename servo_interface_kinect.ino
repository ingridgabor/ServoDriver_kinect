#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

//#include <Servo.h>        // ------------------- mouseX, kinect code added

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

uint8_t motorNum = 8;

void setup() {
  Serial.begin(9600);
  Serial.println("Yes");

  pwm.begin();
  pwm.setPWMFreq(60);  // Analog servos run at ~60 Hz updates
}


void loop() {
  // message from processing might say
  // motorNumber, angle \n
  int angle = 0;
  double pulseLength;
  if (Serial.find("s")) {
    int motorNum = Serial.parseInt();
    angle = Serial.parseInt();
    Serial.print("I got: " );
    Serial.print(motorNum);
    Serial.print(" at ");
    Serial.println(angle);
    // map angle to pulselength
    int pulsewidth = map (angle, 0, 120, 160, 590);
    // set the motor:
    Serial.println(pulsewidth);
    pwm.setPWM(motorNum, 0, pulsewidth);
  }

}
