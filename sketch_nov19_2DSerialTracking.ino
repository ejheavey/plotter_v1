#include <Stepper.h>
#include <Servo.h>
//#include <string.h>
const int stepsPerRev = 400;  // change this to fit the number of steps per revolution
                              // for your motor
//Servo myservo;  // create servo object to control a servo
Stepper xstepper(stepsPerRev, 8, 9); // initialize steppers and associated control
Stepper ystepper(stepsPerRev, 6, 7); // pins on the microcontroller
int pos_S = 0;   // variable to store the servo position
int pos_X = 0;   // variable storing the x position, stepper 1
int pos_Y = 0;   // variable storing the y position, stepper 2

int dis_X=0;     // Initialize the directions and distance variables
int dis_Y=0;     // Distance is measured in steps
int dir_X=0;     // Direction is either 0 or 1
int dir_Y=0;
float dt = 0.5;
int vel_X = 750;
int vel_Y = 750;
// piece of code for establishing the com. between MATLAB and Arduino
const byte numChar=12;
char receivedChar[numChar]; //Takes a chunk of data in an array of size numChar
boolean newData=false;



void setup() { //Run your one-time initializations here
  Serial.begin(9600);  // Set Serial Baudrate
  xstepper.setSpeed(750);  // set xstepper parameters, maxspeed,accel,pos.
  ystepper.setSpeed(750);  // set ystepper parameters
  //myservo.attach(11);  // attaches the servo on pin 11 to the servo object
}

void loop() {
  // put your main code here, to run repeatedly:
 
 record();
 //delay(100);
 execute();
}

int record(){ //Segments the serial stream by bit. When the received character is the
               //indicated endMarker, continue to exectute() subroutine.
  
  static byte ndx=0;
  char   endMarker='>';
  char rc;

    while (Serial.available()>0 && newData==false){
          rc=Serial.read(); //reads one bit at a time
          delay(1);
          
          if (rc!=endMarker){ //if we have not reached the endmarker
              receivedChar[ndx]=rc; //store rc in receivedChar index
              ndx++; //increment the index and store another character in receivedChar
          }else{
              receivedChar[ndx]='\0';  //terminate the string when the endmarker
              ndx=0;                   //has been detected.
              newData=true; //we have the new data, move to execute()
             }
         }// end of the while loop

    return 1;
    }// end of the function for receiving the data.
    


void execute(){ //Manipulates the data into a useable structure
                //receivedChar[] will be something like '01591526'
                //The first 4 chars define X, the second 4 define
                //Y, and the last bit is the endMarker. After the
                //endMarker, the subroutine is terminated and the
                //process loops back to record().
                
    char tmp_X[4]; //array for x distance
    char tmp_Y[4]; //array for y distance
    char tmpChar_X[2]; //will store x direction
    char tmpChar_Y[2]; //will store y direction
    
    if (newData==true){    //if we are here, newData is true.
        
        tmpChar_X[0]=receivedChar[0]; //Assigns dir_X as first received character 
        tmpChar_X[1]='\0';        
        dir_X = atoi(tmpChar_X);  //The atoi() function converts ASCII chars to integers
   
        for (int j=0; j<=2; j++){ //Assigns the stepping distance to a 1x3 array
            tmp_X[j]=receivedChar[j+1];   
           }
        
        tmp_X[3]='\0'; 
        dis_X =atoi(tmp_X); //Determined # of steps to take in X direction

        tmpChar_Y[0] = receivedChar[4];
        tmpChar_Y[1] = '\0';
        dir_Y = atoi(tmpChar_Y); //Determine Y direction with the 5th received character
                                 //and compute the # of steps to take
        for (int k=0;k<=2;k++){
            tmp_Y[k] = receivedChar[k+5];
           }
        
        tmp_Y[3] = '\0';
        dis_Y = atoi(tmp_Y); //# of steps in Y direction

        //Depending on the values of dir_X and dir_Y, step accordingly.
        //If dir = 1, step positive; if dir = 0, step negative.
        if (dir_X>0){
            xstepper.step(5*dis_X);
        }else{
            xstepper.step(-5*dis_X);
           }
        if (dir_Y>0){
            ystepper.step(5*dis_Y);
        }else{
            ystepper.step(-5*dis_Y);
           }

        newData=false;  
        delay(1);

    // to free the buffer  
       while (Serial.available()>0){
            Serial.read();
           }  
      } 
  
}


