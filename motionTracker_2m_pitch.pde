// LEAP libraries
import de.voidplus.leapmotion.*;
LeapMotion leap;

// Serial Port Output
import processing.serial.*; // Serial libraries, send OUTPUT through USB
Serial myPort;

private static final int DELTABUF = 5;
private static final int LOWUNIT = 50;
private static final int HIGHUNIT = 400;
private static final int STEPRATIO = 1;
private static final int ROLLRATIO = 1;
private static final int PITCHRATIO = 1;

boolean initial =true;

private static final int NUMDELTA = 4;
private static final int INT_SIZE = 4;
private static final int BYTE_LENGTH = 8;


int height = 0;
int pitch = 0;
int roll = 0;
Hand hand;
int doDraw;

int[] deltas = new int[NUMDELTA];


void setup() {
    size(1000, 500, P3D);
    background(255);
    noStroke();
    fill(50);
    // New port object
    println(Serial.list());

    myPort = new Serial(this, Serial.list()[0], 9600);
    
    // New leap object
    leap = new LeapMotion(this);
    doDraw = 1000;
    delay(200);
    
}




void assignDeltas(){
  PVector pos = hand.getPalmPosition();

  //Assign height change
  int oldHeight = height;
  height = (int)pos.y;
  
  int deltaY = (oldHeight - height) * STEPRATIO;
  
  for(int i = 0; i < NUMDELTA; i++){
    if((abs(deltaY)> DELTABUF) && (LOWUNIT< height && height < HIGHUNIT)){
      deltas[i] = deltaY;
    }
    else
      deltas[i] = 0;
  }
  
  //Assign pitch
  int oldPitch = pitch;
  pitch = (int)hand.getPitch();
  int deltaPitch= (oldPitch - pitch) *STEPRATIO; //May need to adjust
  
  //Make sure pitch is within bounds and assign changes to appropriate motors
  if((abs(deltaPitch)> DELTABUF)){
    deltas[1] += deltaPitch;
    deltas[3] += deltaPitch;
    deltas[0] -= deltaPitch;
    deltas[2] -= deltaPitch;
    
    
  }
  //Assign roll
  int oldRoll = roll;
  roll = (int)hand.getRoll();
  int deltaRoll= (oldRoll - roll) * STEPRATIO;  
  
  //Make sure pitch is within bounds and assign changes to appropriate motors
  if((abs(deltaRoll)> DELTABUF)){
    deltas[0] += deltaRoll;
    deltas[1] += deltaRoll;
    deltas[2] -= deltaRoll;
    deltas[3] -= deltaRoll;
  } 
  
}


char[] bytes = new char[INT_SIZE];


char[] intToByteArr(int input){
  for(int i = 0; i<INT_SIZE; i++){
    bytes[i] = (char)((input>>(i*8)) & 0xFF);
    //println("sac"+ bytes[i]);
  }
  return bytes;
   
}

void draw() {
    if(leap.getHands().size() > 0){
            hand = leap.getHands().get(0);
            hand.draw();
            
            //Height   
            PVector pos = hand.getPalmPosition();
            int oldHeight = height;
            height = (int)pos.y;
            int deltaY = oldHeight - height;
            println("detlaY: "+deltaY);
            
            //Pitch
            int oldPitch = pitch;
            pitch = (int)hand.getPitch();
            int deltaPitch= (oldPitch - pitch);
            println("detlaPitch: "+deltaPitch);
            
            if((abs(deltaY)> DELTABUF)){
              
                myPort.clear();
                if(deltaY<0)
                   myPort.write('n'); 
                else
                  myPort.write('p');
                
                delay(2);

            }
        }

/*
void draw() {
       if(leap.getHands().size() > 0){
            hand = leap.getHands().get(0);
            hand.draw();
            //Height   
            PVector pos = hand.getPalmPosition();
            int oldHeight = height;
            height = (int)pos.y;
            int deltaY = oldHeight - height;
            //Pitch
            int oldPitch = pitch;
            pitch = (int)hand.getPitch();
            int deltaPitch= (oldPitch - pitch);
            
            println("detlaPitch: "+deltaPitch);
            myPort.clear();
           
                if(abs(deltaPitch) > 4)
                { 
                  if(deltaPitch > 0)
                  {
                    myPort.write('p');
                    myPort.clear();
                    println("SERIAL");
                    delay(10);

                   // myPort.write('n');
                  }
                  else if(deltaPitch < 0)
                  {
                    myPort.write('n');
                    myPort.clear();
                    delay(10);

                    myPort.write('p');
                  }
                }
                delay(20);

            
        }


      
      
      
     */ 
      
//       //myPort.write(255);
//
////       for(int i = 0; i < 4; i++){
////         //println("now writeing: "+(int)bytes[i]);
////         myPort.write(bytes[i]);
////       }
//
//       
//     // int result1 = myPort.read();
//     // println("result1: "+(int)result1);
//
//
// 
//      myPort.clear();
//       myPort.write('p'); 
//      // myPort.write(255);
//
////       for(int i = 0; i < 4; i++){
////         //println("now writeing: "+(int)bytes[i]);
////         myPort.write(bytes[i]);
////       }
//
//       
//      delay(2000);
//       //result1 = myPort.read();
//      //println("result1: "+(int)result1);
//     /*myPort.clear();
//       myPort.write('p'); 
//       myPort.write(255);
//
//      delay(2000);
//      result1 = myPort.read();
////      println("result1: "+result1);*/
//      
////      int result2 = myPort.read();
////      println("result2: "+(int)result2);
////      int result3 = myPort.read();
////      println("result3: "+(int)result3);
////      int result4 = myPort.read();
////      println("result4: "+(int)result4);
//
//
////    
////    // Leap magic
////    //int fps = leap.getFrameRate();
////    // Clean LEAP Hand position
////    if(leap.getHands().size() > 0){
////        hand = leap.getHands().get(0);
////        hand.draw();
////        
////        float pitch = hand.getPitch();
////        float roll = hand.getRoll();
////        //println("pitch: " + pitch);
////        //println("yaw: " + yaw);
////        
////        PVector pos = hand.getPalmPosition();
////        int oldHeight = height;
////        height = (int)pos.y;
////        int deltaY = oldHeight - height;
////        
////        
////        if((abs(deltaY)> DELTABUF) && (LOWUNIT< height && height < HIGHUNIT)){
////           int numSteps = deltaY*STEPRATIO;
////           //int got = myPort.read();
////
////           //if((myPort.available()==42) || initial){
////             initial = false;
////             //println("recieved from arduino: " + got);
////             println(numSteps);
////             myPort.clear();
////             myPort.write(numSteps);
//           //}
//           //myPort.write(numSteps);
//           //myPort.write(numSteps);
//           //myPort.write(numSteps);
//        }
//    }
}

