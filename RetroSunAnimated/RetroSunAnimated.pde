int sunRadius = 400;
int numSunBands = 5;
int numReflectionBands = 6;
float sunSlitSpeed = 0.8;
float reflectionSpeed = 0.8;
color bgColor = color(31, 0, 48);
color starColor = color(255);

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
  size(1600, 1000);

  // Setup Sun
  sun = new Sun(sunRadius, numSunBands, sunSlitSpeed);
  
  // Setup Reflection bars
  int topX = sun.sunCenterX - sun.sunRadius - (sun.sunRadius/4);
  int topY = sun.sunCenterY + sun.sunRadius - (sun.sunRadius/6);
  reflection = new Reflection(numReflectionBands, topX, topY, reflectionSpeed);

  // Setup stars
  stars = new Star[int(width * height * 0.00052)];
  for ( int i = 0; i < stars.length; i++) {
    stars[i] = new Star(int(random(10, width)), int(random(10, height)), starColor);
  }
}

void draw() {
  background(bgColor);

  sun.draw();

  reflection.draw();

  drawStars();
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
