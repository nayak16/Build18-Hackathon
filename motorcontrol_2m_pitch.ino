/* 
This is a test sketch for the Adafruit assembled Motor Shield for Arduino v2
It won't work with v1.x motor shields! Only for the v2's with built in PWM
control

For use with the Adafruit Motor Shield v2 
---->        http://www.adafruit.com/products/1438
*/


#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

#define NUM_MOTORS 4
#define INT_SIZE 4
#define BYTE_SIZE 8

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMSbot = Adafruit_MotorShield(); 
// Or, create it with a different I2C address (say for stacking)
Adafruit_MotorShield AFMStop = Adafruit_MotorShield(0x61); 

// Connect a stepper motor with 200 steps per revolution (1.8 degree)
// to motor port #2 (M3 and M4)
Adafruit_StepperMotor *motors[NUM_MOTORS] = {AFMSbot.getStepper(200, 1),
                                    AFMSbot.getStepper(200, 2),
                                    AFMStop.getStepper(200, 1),
                                    AFMStop.getStepper(200, 2)};

volatile int steps;
volatile int steps1;
volatile int steps2;
char serial_bytes[4];
int height;
int count = 0;
int stepc = 1000;
char num[4];
boolean ext = false;
int stps = 100;
boolean backward = false;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
   Serial.println("Connection established");
  AFMSbot.begin();
  AFMStop.begin(); 
  for (int i = 0; i < NUM_MOTORS; i++)
    motors[i]->setSpeed(300); 
  
  steps=0;
//  TWBR = ((F_CPU /400000l) - 16) /2;
}
void loop(){
  //Serial.write(steps);
  if(steps1 > 0){
     motors[0]->onestep(FORWARD,DOUBLE);
       //Serial.flush();
      //Serial.write(42);
     steps1--;
  }
  else if (steps1 < 0) {
    motors[0]->onestep(BACKWARD, DOUBLE);
         // /Serial.flush();
      //Serial.write(43);
    steps1++;
  }
  else{
      //  Serial.write(44);
  }
    if(steps2 > 0){
    motors[1]->onestep(FORWARD,DOUBLE);
    steps2--;
  }
  else if (steps2 < 0) {
    motors[1]->onestep(BACKWARD, DOUBLE);
    steps2++;
  }
  else {
  }

}
/*
void loop(){
  //motors[0]->onestep(FORWARD, DOUBLE);
  
  if(steps1 > 0){
    motors[0]->onestep(FORWARD,DOUBLE);
    steps1--;
  }
  else if (steps1 < 0) {
    motors[0]->onestep(BACKWARD, DOUBLE);
    steps1++;
  }
  if(steps2 > 0){
    motors[1]->onestep(FORWARD,DOUBLE);
    steps2--;
  }
  else if (steps2 < 0) {
    motors[1]->onestep(BACKWARD, DOUBLE);
    steps2++;
  }
  
  //else motors[0]->release();
  
}*/


int byteToInt(){
   int result = 0;
   for(int i = 0; i<INT_SIZE; i++){
      result = result | ((serial_bytes[i])<<(i*(BYTE_SIZE)));
   }
   
   return result;
   
}
  
void serialEvent() {
 
 if(Serial.available()>0){
 /* 
     char n = Serial.read();
     if(first == 'n'){
       //negative case
       steps1 -= 20;// (10*Serial.read
       steps2 -= 20;

     }
     else if(n == 'p'){
       //positive case
       steps1 += 20;//(10*Serial.read());
       steps2 += 20;

     }
 */    
     char first = Serial.read();
     char sec = Serial.read();
 /*    if(first == 'n' && sec == 'n'){
      
       //negative case
       steps1 -= 20;
       steps2 -=20;
     }
     else if(first == 'p' && sec == 'p'){
       //positive case
       steps1 += 20;
       steps2 += 20;
     }*/
     if(first == 'p' && sec == 'n'){
       //positive case
       steps1 += 20;
       steps2 -= 20;
     }
     else if(first == 'n' && sec == 'p'){
       //positive case
       steps1 -= 20;
       steps2 += 20;
     }
       
       
       
  }
}
/*
void serialEvent() {
 
  
//  if(Serial.available()>0){
//   
//     Serial.readBytes(num,4);
//     stps = atoi(num);
//     steps=stps;    
//  }
 if(Serial.available()>0){
     
     char first = Serial.read();
     char sec = Serial.read();
     if(first == 'n' && sec == 'n'){
      
       //negative case
       steps1 -= 20;
       steps2 -=20;
     }
     else if(first == 'p' && sec == 'p'){
       //positive case
       steps1 += 20;
       steps2 += 20;
     }
     else if(first == 'p' && sec == 'n'){
       //positive case
       steps1 += 20;
       steps2 -= 20;
     }
     else if(first == 'n' && sec == 'p'){
       //positive case
       steps1 -= 20;
       steps2 += 20;
     }
 }
//       ;;
//       
//       
//  }
}*/


