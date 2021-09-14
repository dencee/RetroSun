PGraphics renderer;
color sunKeyColor = 0xff00ff00;
color[] sunColors = {
  color(212, 202, 11),
  color(214, 198, 30),
  color(211, 170, 26),
  color(216, 157, 51),
  color(217, 124, 64),
  color(213, 104, 81),
  color(212, 51, 98),
  color(215, 29, 121),
  color(217, 11, 139),
  color(217, 0, 151)
};
color bgColor = color(62, 11, 77);
int sunRadius = 450;
int sunCenterX;
int sunCenterY;
int sunsetY;
int numBands = 6;
int[] sunsetBandHeights;
int slitSpacePixels;
int slitTopBoundary;
ArrayList<Rectangle> slits;

class Rectangle {
  int x, y, h;
  
  Rectangle(int x, int y, int h){
    this.x = x;
    this.y = y;
    this.h = h;
  }
}

void setup(){
  size(1200, 1000);
  //fullScreen();
  sunCenterX = width / 2;
  sunCenterY = height / 2;
  sunsetY = sunCenterY;
  slitSpacePixels = sunRadius / numBands;
  slitTopBoundary = sunCenterY - (sunRadius / 4);
  slits = new ArrayList<Rectangle>();
  
  // Must be entire screen
  renderer = createGraphics(width, height);
  renderer.noSmooth();
  
  for( int i = 0; i < numBands; i++ ){
    float sunsetBandHeight = map(i+1, 1, 10, 1, sunRadius / numBands);
    
    Rectangle r = new Rectangle(0, sunsetY, (int)sunsetBandHeight);
    slits.add(r);
    
    sunsetY += slitSpacePixels;
  }
  
  frameRate(15);
}

void draw() {
  background(bgColor);
  
  drawSun(renderer);
  
  drawSlitsInSun(renderer);
  
  image(renderer, 0, 0);
}

void drawSun(PGraphics renderer){
  renderer.beginDraw();
  renderer.beginShape(ELLIPSE);
  renderer.noStroke();
  renderer.fill(sunKeyColor);
  
  renderer.ellipse(sunCenterX, sunCenterY, 2*sunRadius, 2*sunRadius);
  renderer.endShape(CLOSE);
  renderer.endDraw();
  
  renderer.beginDraw();
  renderer.loadPixels();
  
  int i = 0;
  
  for( int y = 0; y < renderer.height; y++){
    for( int x = 0; x < renderer.width; x++){
      
      color sampleColor = renderer.pixels[i];
      
      if( sunKeyColor == (0xFF000000 | sampleColor) ){
        float originX = sunCenterX;
        float originY = sunCenterY - sunRadius;
        float endX = sunCenterX;
        float endY = sunCenterY + sunRadius;
        float step = project(originX, originY, endX, endY, x, y);
        
        step = map(y, originY, endY, 0, 1);
        
        color lc = 0x00FFFFFF & lerpColor(sunColors, step, RGB);
        
        color alpha = sampleColor & 0xFF000000;
        renderer.pixels[i] = alpha | lc; 
      }
      
      i++;
    }
  }
  renderer.updatePixels();
  renderer.endDraw();
}

void drawSlitsInSun(PGraphics renderer){
  // All the rectangular slits--same color as background
  // to create the illusion of missing pieces in the sun
  renderer.beginDraw();
  renderer.noStroke();
  renderer.fill(bgColor);
    
  for( Rectangle r : slits ){
    
    renderer.beginShape(RECT);
    renderer.rect(r.x, r.y, width, r.h);
    renderer.endShape(CLOSE);
    
    
    r.y--;

    if( r.y < sunCenterY ){
      r.y = sunCenterY + sunRadius;
    }
    
    // Resize the height of the slits as they move up
    r.h = getNewBandHeight(r);
  }
  
  renderer.endDraw();
}

// The closer the slit is to the center the smaller to make it
int getNewBandHeight(Rectangle r){
  int bandHeight = 0;
  
  bandHeight = (int)map(r.y, sunCenterY, (sunCenterY + sunRadius), 1, sunRadius / numBands);
  
  return bandHeight;
}

color lerpColor(color[] arr, float step, int colorMode) {
  int sz = arr.length;
  if (sz == 1 || step <= 0.0) {
    return arr[0];
  } else if (step >= 1.0) {
    return arr[sz - 1];
  }
  float scl = step * (sz - 1);
  int i = int(scl);
  return lerpColor(arr[i], arr[i + 1], scl - i, colorMode);
}

float project(float originX, float originY,
  float destX, float destY,
  int pointX, int pointY) {
  // Rise and run of line.
  float odX = destX - originX;
  float odY = destY - originY;

  // Distance-squared of line.
  float odSq = odX * odX + odY * odY;

  // Rise and run of projection.
  float opX = pointX - originX;
  float opY = pointY - originY;
  float opXod = opX * odX + opY * odY;

  // Normalize and clamp range.
  return constrain(opXod / odSq, 0.0, 1.0);
}
