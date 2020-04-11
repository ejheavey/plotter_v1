#include <Stepper.h>
//#include <Servo.h>
const int stepsPerRev = 400;  // change this to fit the number of steps per revolution
// for your motor
// Servo myservo;  // create servo object to control a servo
//Stepper xstepper(stepsPerRev, 8, 9); // initialize steppers and associated control
Stepper ystepper(stepsPerRev, 6, 7); // pins
int pos = 0;    // variable to store the servo position
int posx = 0;   //variable storing the x position, stepper 1
int posy = 0;   //variable storing the y position, stepper 2

int dis=0;                  
int dir=0;                  
int dir2=0;
int initial=0;

// piece of code for establishing the com. between MATLAB and Arduino
const byte numChar=10;
char receivedChar[numChar];
boolean newData=false;



void setup() {
  Serial.begin(9600);  // initialize the serial port
 // xstepper.setSpeed(800);  // set xstepper parameters, maxspeed,accel,pos.
  ystepper.setSpeed(750);  // set ystepper parameters
 // myservo.attach(9);  // attaches the servo on pin 9 to the servo object

}


void loop() {
   if(Serial.available()>0){
      record();
      execute();
      initial=1;
   }
   else{
      execute2();
   }
}



void record()
{
 static byte ndx=0;
 char   endMarker='>';
 char rc;
 while (Serial.available()>0 && newData==false){
      rc=Serial.read();
      delay(2);
      if (rc!=endMarker){
           receivedChar[ndx]=rc;
           ndx++;                 
      }
      else{
          receivedChar[ndx]='\0';  //terminate the string
          ndx=0;
          newData=true;
      }

}
// end of the while loop

// end of the function for receiving the data
}


void execute(){
  char tmp[4];
  char tmpChar[2];
  if (newData==true){
      tmpChar[0]=receivedChar[0]; 
      tmpChar[1]='\0';   //establishes end of individual reading
      dir = atoi(tmpChar);  //assigns the direction as the first character in the reading
      for (int j=0; j<=2; j++){
        tmp[j]=receivedChar[j+1];  //assigns the stepping distance to an 1D array of 3 digits
      }
    tmp[3]='\0'; 
    dis =atoi(tmp);

    if (dir>0){
      //xstepper.step(dis);
       ystepper.step(dis);
    }
    else{
      //xstepper.step(-1*dis);
       ystepper.step(-1*dis);
      }

      delay(1);
    //  ystepper.step(4*stepsPerRev);
    newData=false;  
    
    // to free the buffer  
     while (Serial.available()>0){
        Serial.read();
        }  
 } 
  
}

void execute2(){
  if (dis>5){
     if (initial==1){
        if (dir>0){
           //xstepper.step(50);
           ystepper.step(dis);
          }
        else{
           //xstepper.step(-1*50);
           ystepper.step(-1*dis);
          }
        }
     }
}
















