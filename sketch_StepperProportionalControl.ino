//Include your libraries
#include <Stepper.h>
#include <SharpIR.h>

//Define any variables and devices that will be used
//Variables:
int stepsPerRev = 1600;
int previous = 0;
int endStop = 9;

float desired_distance = 35;
float sensorValue;
float distance;
float error;
float homePoint = 49;
float k1=21.4325; //filtered multiplier
//float k1=20.2200;
float k2=-0.9112; //filtered exponent
//float k2=-0.9007;

//Devices:
Stepper xStepper(stepsPerRev,8,9);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(A0, INPUT); //IR sensor input pin
  pinMode(8, OUTPUT); //Stepper pins
  pinMode(9, OUTPUT); 
  xStepper.setSpeed(1000);
  yStepper.setSpeed(150);
}

void loop(){
  // put your main code here, to run repeatedly:
  float sum=0;
  for (int i=0; i<100; i++)
  {
  sum=sum+analogRead(A0);  
  }
  
  sensorValue =sum/100;  //Reads sensor value from analog input
  sensorValue = 5*(sensorValue)/1023; //Converts sensor reading to voltage
  distance = pow(sensorValue/k1,1/k2);  // d = (V/k1)^(1/k2)
  error = desired_distance - distance; //Condition for proportional control
//  Serial.println(error);  //Writes error signal to serial monitor
  if(distance < desired_distance){
     xStepper.step(3*error);
     delay(0); 
  }else{
     xStepper.step(-3*error);
     delay(0);
  }
}



