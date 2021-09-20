int numReflectionBands = 6;
int sunRadius = 400;
color sunKeyColor = color(0, 255, 0, 255);
color bgColor = color(31, 0, 48);
color starColor = color(255);

Sun sun;
Reflection reflection;
Star[] stars;
boolean[] grainTexturePixels;

class Rectangle {
  int x, y, w, h;

  Rectangle(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}


void setup() {
  size(1600, 1000);

  // Setup Sun
  sun = new Sun(sunRadius);
  
  // Setup Reflection bars
  int topX = sun.sunCenterX - sun.sunRadius - (sun.sunRadius/4);
  int topY = sun.sunCenterY + sun.sunRadius + 15;
  reflection = new Reflection(numReflectionBands, topX, topY);

  // Setup stars
  stars = new Star[int(width * height * 0.00052)]; //<>//
  for ( int i = 0; i < stars.length; i++) {
    stars[i] = new Star(int(random(10, width)), int(random(10, height)), starColor);
  }

  // Setup pixels for grainy texture //<>//
  grainTexturePixels = new boolean[width * height];

  for ( int i = 0; i < grainTexturePixels.length; i++) {
    if ( random(1) > 0.96 ) {
      //grainTexturePixels[i] = true;
    }
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
    if( red(pixel) > 220 || red(pixel) < 210){
      stars[i].display();
    }
  }
} //<>//

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
