//Include your libraries
#include <Stepper.h>
#include <SharpIR.h>

//Define any variables and devices that will be used
//Variables:
int stepsPerRev = 400;
int previous = 0;
int endStop = 9;

float desired_distance = 30;
float sensorValue;
float distance;
float error;
float homePoint = 49;

float k1=21.4325; //filtered multiplier
// float k1=20.2200;
float k2=-0.9112; //filtered exponent
//float k2=-0.9007;

//Devices:
Stepper xStepper(stepsPerRev,4,5);


void setup() {  // put your setup code here, to run once:
	Serial.begin(9600);
	pinMode(A0, INPUT); // IR sensor input
	pinMode(endStop, INPUT); //End stop
  	pinMode(4, OUTPUT); //Stepper pins
	pinMode(5, OUTPUT);
	xStepper.setSpeed(250);
}


void loop(){  
// put your main code here, to run repeatedly:
	float sum = 0;
	int samples = 50;  
	for (int i = 0; i < samples; i++){ // Begin sampling for moving average...
	      sensorValue = analogRead(A0); //Reads sensor value from analog input
	      sensorValue = 5*(sensorValue)/1023; //Converts sensor reading to voltage
	      distance = pow(sensorValue/k1,1/k2);  // V = k1*exp(k2)
	      sum = sum + distance;
	      delay(1);
	  }

	distance = sum/samples;  // Take average of samples as distance value
	error = desired_distance - distance; //Condition for proportional control
	Serial.println(error);  //Writes error signal to serial monitor
  
	if (distance < desired_distance){
	      xStepper.step(error);	
	      delay(1);
	}else{
	      xStepper.step(error);
	      delay(1);
	}
}























