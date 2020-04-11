#include <Stepper.h>

//Here we define any variables and devices that will be used
const int stepsPerRev = 400;
int error;
int counter = 0;
int currentState;
int lastState;
Stepper myStepper(stepsPerRev,5,6);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  pinMode(12, INPUT); //Encoder input pin
  pinMode(13, INPUT); //Encoder input pin

  digitalWrite(12, HIGH); //When a pulse is received, write HIGH
  digitalWrite(13, HIGH); //Same as above
  
  myStepper.setSpeed(50);
  lastState = digitalRead(12); //Setting the previous state. At this point, there is none.
}

void loop(){
  // put your main code here, to run repeatedly:
  currentState = digitalRead(12); 
  if(currentState != lastState){ //At this point, the current state IS the last state. Nothing will happen until the encoder shaft turns.     
      if(digitalRead(13) != currentState){ //Once the encoder turns, the current state will either be written to 12 or 13 
        counter++; //The counter will change accordingly      
      }else{
        counter--; 
  }
  Serial.print("Position: "); //In the serial monitor, "Position: counter" is displayed
  Serial.println(counter);    //and writes a new line for each increment of the encoder.

  }
  lastState = currentState;
}








