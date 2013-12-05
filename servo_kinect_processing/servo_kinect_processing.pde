/* Derived from Ingrid Gabor's thesis project "Light Waves" at ITP 2013.
Adaptation of Dan Shiffman's openkinect library's "Average Point Tracking".
Uses Kinect tracking to control movement of servo motors, connected through
the Adafruit 16-Channel 12-bit PWM/Servo Driver interface
found at http://www.adafruit.com/products/815#Learn
Use Adafruit's tutorial for assmebling and hooking up the driver to
Arduino & servos: http://learn.adafruit.com/16-channel-pwm-servo-driver/overview 
(Much thanks to Tom Igoe for help with programming during thesis studies).
*/

import processing.serial.*;
import org.openkinect.*;                  
import org.openkinect.processing.*;      
Serial myPort;

KinectTracker tracker;               
// Kinect Library object
Kinect kinect; 

void setup() {
  size(640,520);   
  
  kinect = new Kinect(this);            
  tracker = new KinectTracker();                        
 
  println(Serial.list());
  myPort = new Serial(this, "/dev/tty.usbmodem1421", 9600); // change to your serial port
}

void draw() {
  background(255);
  
  if (myPort.available() > 0 ) {
    print((char)myPort.read());
    
    PVector v3 = tracker.getLerpedPos();      // kinect-servo addition
    int angle = (int)v3.x/6;
   

// test with one servo at pin 8 on driver (hi-torque servo upto 120 degrees) ------------
      int servoNumber=8;           //test with one servo at 8
      myPort.write("s" + servoNumber + "," + angle + "\n");  
          
      if (angle > 110) {angle = 110;} // 10 degree buffer on both ends
      if (angle < 10) {angle = 10;}
// --------------------------------------------------------------------------------------


/*   
// multiple servos at pins 8-14 ---------------------------------------------------------
    for (int servoNumber = 8; servoNumber < 15; servoNumber++) {
      myPort.write("s" + servoNumber + "," + angle + "\n");
      angle = angle -10; // affsets each additional servo by 10 degrees
      
      if (angle > 110) {angle = 110;} // 10 degree buffer on both ends
      if (angle < 10) {angle = 10;}
      
      }
    
    delay(120);
// --------------------------------------------------------------------------------------
*/

  }
 //------------------------------------------ begin kinect code
            
  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  fill(50,100,250,200);
  noStroke();
  ellipse(v1.x,v1.y,20,20);

  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  fill(100,250,50,200);
  noStroke();
  ellipse(v2.x,v2.y,20,20);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold",10,500);  
  //------------------------------------------ end kinect code
} 

//------------------------------------------ begin kinect code
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=10;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=10;
      tracker.setThreshold(t);
    }
  }
}

void stop() {
  tracker.quit();
  super.stop();
}
//------------------------------------------ end kinect code

/* 
void keyReleased() {
  int angle = mouseX/4;
  int servoNumber=8;
  myPort.write("s" + servoNumber + "," + angle + "\n");
 
  for (int servoNumber = 8; servoNumber < 9; servoNumber++) {
    myPort.write("s" + servoNumber + "," + angle + "\n");
    angle = angle + 10;
  }
}*/
  

