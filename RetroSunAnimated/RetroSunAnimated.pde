import java.util.*;

int sunRadius = 150;
int sunCenterY;
int sunsetY;
int[] sunsetBandHeights = {3, 5, 7, 8, 9, 10, 10, 10, 10, 10};
int slitSpacePixels = sunRadius / sunsetBandHeights.length;
List<Rectangle> slits = new ArrayList<Rectangle>();

class Rectangle{
  int x, y, h;
  
  Rectangle(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  Rectangle(int x, int y, int h){
    this.x = x;
    this.y = y;
    this.h = h;
  }
}

void setup(){
  size(800, 600);
  sunCenterY = height/2;
  sunsetY = sunCenterY;
  
  for( int i = 0; i < 10; i++ ){
    int sunsetBandHeight = sunsetBandHeights[i];
    
    Rectangle r = new Rectangle(0, sunsetY, sunsetBandHeight);
    slits.add(r);
    
    sunsetY += slitSpacePixels;
  }
  
  frameRate(15);
}

void draw() {
  background(62, 11, 77);
  
  // Sun
  noStroke();
  fill(255, 211, 15); 
  ellipse(width/2, sunCenterY, 2*sunRadius, 2*sunRadius);
  
  // All the rectangular slits--same color as background
  // to create the illusion of missing pieces in the sun
  for( Rectangle r : slits ){
    fill(62, 11, 77);
    rect(r.x, r.y, width, r.h);
    r.y--;
    
    if( r.y < sunCenterY ){
      r.y = sunCenterY + sunRadius;
    }
    
    // Resize the height of the slits as they move up
    r.h = getNewBandHeight(r);
  }
}

// The closer the slit is to the center the smaller to make it
int getNewBandHeight(Rectangle r){
  int bandHeight = 0;

  int distBelowSunCenter = r.y - sunCenterY;
  
  if( distBelowSunCenter > 0 ){
    int index = distBelowSunCenter / slitSpacePixels;
    bandHeight = sunsetBandHeights[index % sunsetBandHeights.length];
  }
  
  return bandHeight;
}
