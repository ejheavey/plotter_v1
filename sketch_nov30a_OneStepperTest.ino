#include <Stepper.h>
//#include <Servo.h>
const int stepsPerRev = 400;  // change this to fit the number of steps per revolution
                              // for your motor
//Servo myservo;  // create servo object to control a servo
Stepper xstepper(stepsPerRev, 6, 7); // initialize steppers and associated control

void setup() {
  // put your setup code here, to run once:
 Serial.begin(9600);  // Set Serial Baudrate
 xstepper.setSpeed(0);  // set xstepper parameters, maxspeed,accel,pos.
 //xstepper.step(-1000);

}

void loop() {
  // put your main code here, to run repeatedly:
  xstepper.step(stepsPerRev);
  xstepper.step(-1*stepsPerRev);
}
