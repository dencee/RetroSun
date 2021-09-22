int sunRadius = 400;
int numSunBands = 5;
int numReflectionBands = 6;
int shoreY;
float sunSlitSpeed = 0.8;
float reflectionSpeed = 0.8;
color starColor = color(255);
color bgColor;                // RGB color is color(31, 0, 48)
float bgHue = 279;
float bgSat = 100;
float bgBrightDefault = 18.8;
float bgBright = bgBrightDefault;

Sun sun;
Reflection reflection;
Star[] stars;

class Rectangle {
  float x, y, w, h;

  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

void setup() {
  size(1600, 900);
  
  colorMode(HSB, 360, 100, 100);
  bgColor = color(bgHue, bgSat, bgBright);

  // Setup Sun a little below the top of the window
  int sunCenterX = width / 2;
  int sunCenterY = (height / 2) - 50;
  sun = new Sun(sunCenterX, sunCenterY, sunRadius - 25, numSunBands, sunSlitSpeed);
  
  // Setup Reflection bars
  int topX = sunCenterX - sunRadius - (sunRadius / 4);
  int topY = sunCenterY + sunRadius - (sunRadius / 6);
  reflection = new Reflection(numReflectionBands, topX, topY, reflectionSpeed);

  // Setup shore
  shoreY = topY;

  // Setup stars
  stars = new Star[int(width * height * 0.00052)];
  for ( int i = 0; i < stars.length; i++) {
    stars[i] = new Star(int(random(10, width)), int(random(10, topY)), starColor);
  }
}

void draw() {
  background(bgColor);

  sun.draw();

  drawShore();

  reflection.draw();

  drawStars();
}

void mouseDragged(){
  // Darken the background when the sun goes below the shore
  bgBright = map(mouseY, sunRadius, shoreY + sunRadius, bgBrightDefault, 0);
  bgColor = color(bgHue, bgSat, constrain(bgBright, 0, bgBrightDefault));
    
  // Reset the top of the sun to the mouseY posiiton 
  sun.initialize(sun.sunCenterX, mouseY + sunRadius);
    
  // Fewer reflection bars when the sun is lower
  int bars = int(map(sun.sunCenterY, sunRadius, shoreY + sunRadius, numReflectionBands, 0));
  reflection.initialize(constrain(bars, 0, numReflectionBands));
  
  // Set star brightness
  int alpha = int(map(sun.sunCenterY, sunRadius, shoreY + sunRadius, 0, 255));
  for( Star s : stars ){
    s.setAlpha(alpha);
  }
}

void drawShore(){
  fill(bgColor);
  rect(0, shoreY, width, height - shoreY);
}

void drawStars() {
  loadPixels();
  
  for ( int i = 0; i < stars.length; i++ ) {
    Star s = stars[i];
    color pixel = pixels[(s.y * width) + s.x];
    
    if( pixel == bgColor ){  
      stars[i].draw();
    }
  }
} //<>//

// Placed here so it can be used by all classes
// Variable step should be between 0 and 1, inclusive
color interpolateColor(color[] arr, float step, int colorMode) {
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
