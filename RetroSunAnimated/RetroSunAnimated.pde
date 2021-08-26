import java.util.*;

int sunRadius = 150;
int sunCenterY;
int sunsetY;
int slitSpacePixels = sunRadius / 10;
int[] sunsetBandHeights = {3, 5, 7, 8, 9, 10, 10, 10, 10, 10};
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
}

void draw() {
  background(62, 11, 77);
  
  noStroke();
  fill(255, 211, 15); 
  ellipse(width/2, sunCenterY, 2*sunRadius, 2*sunRadius);
  
  sunsetY = sunCenterY;
  fill(62, 11, 77);
  for( Rectangle r : slits ){
    rect(r.x, r.y, width, r.h);
    r.y--;
    
    if( r.y < sunCenterY ){
      r.y = sunCenterY + sunRadius;
      r.h = sunsetBandHeights[r.h / slitSpacePixels];
    }
  }
}

int getNewBandHeight(Rectangle r){
  int sunsetBandHeight = 0;

  
  return 0;
}
