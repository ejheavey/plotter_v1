#include <Stepper.h>
#include <Servo.h>
const int stepsPerRev = 400;  // change this to fit the number of steps per revolution
// for your motor
Servo myservo;// create servo object to control a servo
Stepper xstepper(stepsPerRev, 8, 9); // initialize steppers and associated control
Stepper ystepper(stepsPerRev, 6, 7); // pins
int pos=0;  // variable to store the servo position
int posx = 0;   //variable storing the x position, stepper 1
int posy = 0;   //variable storing the y position, stepper 2

int disX=0;                  
int dis_Y=0;
int dirX=0; 
int dir_Y=0;
int initial=0;

// piece of code for establishing the com. between MATLAB and Arduino
const byte numChar=10;
char receivedChar[numChar];
boolean newData=false;



void setup() {
  // put your setup code here, to run once:
  // put your setup code here, to run once: 
  Serial.begin(9600);  // initialize the serial port
  xstepper.setSpeed(800);  // set xstepper parameters, maxspeed,accel,pos.
  ystepper.setSpeed(800);  // set ystepper parameters
  myservo.attach(11); // attaches the servo on pin 9 to the servo object
  myservo.write(7);

}


void loop() {
  // put your main code here, to run repeatedly:
 if (Serial.available()>0){
   record();
   execute();
   initial=1;
 }else{
   execute2();
 }
}

void record(){
   xstepper.setSpeed(800);
   ystepper.setSpeed(800);
   static byte ndx=0;
   char   endMarker='>';

   char rc;
   while (Serial.available()>0 && newData==false){
      rc=Serial.read();
      delay(1);
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
   char tmpX[4];
   char tmp_Y[4];
   char tmpChar_Y[2];
   char tmpCharX[2];
   if (newData==true){
       tmpCharX[0]=receivedChar[0]; 
       tmpCharX[1]='\0';   //establishes end of individual reading
       dirX = atoi(tmpCharX);  //assigns the direction as the first character in the reading
       for (int j=0; j<=2; j++){
           tmpX[j]=receivedChar[j+1];  //assigns the stepping distance to an 1D array of 3 digits  
       }
       tmpX[3]='\0'; 
       disX =atoi(tmpX);
       tmpChar_Y[0] = receivedChar[4];
       tmpChar_Y[1] = '\0';
       dir_Y = atoi(tmpChar_Y); //Determine Y direction with the 5th received character
                                 //and compute the # of steps to take
       for (int k=0;k<=2;k++){
           tmp_Y[k] = receivedChar[k+5];
          }  
       tmp_Y[3] = '\0';
       dis_Y = atoi(tmp_Y); //# of steps in Y direction
       if (dirX>0){
           xstepper.step(1*disX);
       }else{
           xstepper.step(-1*disX);
       }
       if (dir_Y>0){
           ystepper.step(dis_Y);
       }else{
           ystepper.step(-1*dis_Y);
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
  if (initial==1){
    if (disX>2){
      if (dirX>0){
          xstepper.step(10); //move small increments in between serial prints
      }else{
          xstepper.step(-10);
         }
    }else{
      xstepper.setSpeed(0); //if disX < 8, DON'T MOVE.
    }
    if (dis_Y>2){
      if (dir_Y>0){
          ystepper.step(dis_Y);
      }else{
          ystepper.step(-1*dis_Y);
          }
    }else{
        ystepper.setSpeed(0); //if dis_Y < 8, DON'T MOVE.
    }
  }
}
















