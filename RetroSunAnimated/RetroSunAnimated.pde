PGraphics renderer;
color sunKeyColor = color(0, 255, 0, 255);
color bgColor = color(31, 0, 48);
color starColor = color(255);
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
color[] barColors = {
  color(45, 2, 59), 
  color(109, 0, 88), 
  color(154, 51, 86), 
  color(158, 79, 62), 
  color(154, 51, 86), 
  color(109, 0, 88), 
  color(45, 2, 59)
};
int sunRadius = 400;
int sunCenterX;
int sunCenterY;
int sunsetY;
int numBands = 6;
int numBars = 6;
int barsTopX;
int barsTopY;
int barsTopWidth;
int barsBottomY;
int barsMaxHeight;
int[] sunsetBandHeights;
int slitSpacePixels;
int slitTopBoundary;
ArrayList<Rectangle> slits;
ArrayList<Rectangle> lowerBars;
Star[] stars;
boolean[] grainTexturePixels;
int glowRadius = 50;

class Rectangle {
  int x, y, w, h;

  Rectangle(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

class Star {
  int x;
  int y;
  color starColor;
  float alpha;
  float diameter;

  Star(int x, int y, color col) {
    this.x = x;
    this.y = y;
    starColor = col;
    alpha = random(1, 255);
    diameter = random(0.1, 3);
  }

  void display() {
    noStroke();
    fill(starColor, alpha);
    float blink = random(0, 0.8);
    circle(x, y, diameter+blink);
  }
}

void setup() {
  size(1600, 1000);
  //fullScreen();
  sunCenterX = width / 2;
  sunCenterY = (height / 2) - 50;
  sunsetY = sunCenterY - (sunRadius / 4);
  slitSpacePixels = (sunCenterY + sunRadius - sunsetY ) / numBands;
  slitTopBoundary = sunCenterY - (sunRadius / 4);
  slits = new ArrayList<Rectangle>();
  lowerBars = new ArrayList<Rectangle>();
  barsTopX = sunCenterX - sunRadius - (sunRadius/4);
  barsTopY = sunCenterY + sunRadius + 15;
  barsTopWidth = 2 * (sunRadius + sunRadius/3);
  barsMaxHeight = 10;
  barsBottomY = barsTopY + (numBars * 2 * barsMaxHeight);
  stars = new Star[int(width * height * 0.00052)];
 //<>//
  for ( int i = 0; i < stars.length; i++) {
    stars[i] = new Star(int(random(10, width)), int(random(10, height)), starColor);
  }

  // Must be entire screen
  renderer = createGraphics(width, height);
  renderer.smooth(8);

  // Get which pixels will be part of the grainy texture //<>//
  grainTexturePixels = new boolean[width * height];

  for ( int i = 0; i < grainTexturePixels.length; i++) {
    if ( random(1) > 0.96 ) {
      //grainTexturePixels[i] = true;
    }
  }

  // Setup sunset slits
  int slitStartY = sunsetY;
  for ( int i = 0; i < numBands; i++ ) {
    float sunsetBandHeight = map(i+1, 1, 10, 1, sunRadius / numBands);

    int y = slitStartY;
    int h = (int)sunsetBandHeight;
    int x = int(sunCenterX - sqrt( sq(sunRadius + glowRadius) - sq(y - sunCenterY) )); 
    int w = int(sunCenterX + sqrt( sq(sunRadius + glowRadius) - sq(y - sunCenterY) )) - x;
    Rectangle r = new Rectangle(x, y, w, h);
    slits.add(r);

    slitStartY += slitSpacePixels;
  }

  // Setup bottom bars
  int x = barsTopX;
  int y = barsTopY;
  int w = barsTopWidth;
  int h = barsMaxHeight;
  for ( int i = 0; i < numBars; i++ ) {   
    y += (barsBottomY - barsTopY) / numBars;
    x += sunRadius / 16;
    w -= 2 * (sunRadius / 16);

    Rectangle r = new Rectangle(x, y, w, h);
    lowerBars.add(r);
  }

  frameRate(20);
}

void draw() {
  background(bgColor);

  drawSun(renderer);

  drawSlitsInSun(renderer);

  drawLowerBars(renderer);

  image(renderer, 0, 0);
  
  drawStars(renderer);
    
  renderer.clear();
}

void drawStars(PGraphics renderer) {
  renderer.loadPixels();
  
  for ( int i = 0; i < stars.length; i++ ) {
    Star s = stars[i];
    color pixel = renderer.pixels[(s.y * width) + s.x];
    if( red(pixel) > 220 || red(pixel) < 210){
      stars[i].display();
    }
  }
}

void drawLowerBars(PGraphics renderer) {
  renderer.beginDraw();
  renderer.strokeWeight(1);

  for ( Rectangle bar : lowerBars ) { //<>//
    for ( int i = bar.x; i < bar.x + bar.w; i++ ) {
      float alphaMax = -255 - ((bar.y - barsTopY));
      float alphaMin = 255 + ((bar.y - barsTopY));
      float alpha = map(i, bar.x, bar.x + bar.w, alphaMin, alphaMax);
      float step = map(i, bar.x, bar.x + bar.w, 0, 1);
      color lc = lerpColor(barColors, step, RGB);

      renderer.stroke(lc, 255 - abs(alpha));
      renderer.line(i, bar.y, i, bar.y + bar.h);
    }

    bar.y += 1;
    bar.x += 2;
    bar.w -= 2 * 2;

    if ( bar.y > barsBottomY) {
      bar.x = barsTopX;
      bar.y = barsTopY;
      bar.w = barsTopWidth;
      bar.h = barsMaxHeight;
    }
  }

  renderer.noStroke();
  renderer.fill(bgColor);
  renderer.rect(barsTopX, barsTopY - 1, barsTopWidth, barsMaxHeight);
  renderer.rect(barsTopX, barsBottomY + 1, barsTopWidth, barsMaxHeight);

  renderer.endDraw();
}

void drawSun(PGraphics renderer) {
  renderer.beginDraw();

  // Glow base
  renderer.noFill();
  renderer.strokeWeight(3);
  for ( int i = sunRadius; i < sunRadius + glowRadius; i++) {
    renderer.stroke(bgColor, map(i, sunRadius, sunRadius + glowRadius, 50, 1));
    renderer.ellipse(sunCenterX, sunCenterY, 2*i, 2*i);
  }

  // Sun base
  renderer.noStroke();
  renderer.fill(sunKeyColor);
  renderer.ellipse(sunCenterX, sunCenterY, 2*sunRadius, 2*sunRadius);
  renderer.fill(bgColor);
  renderer.rect(sunCenterX - sunRadius, sunCenterY + sunRadius - 20, 2 * sunRadius, 35);

  // Lindear gradient and glow effect
  renderer.loadPixels();
  int i = 0;
  for ( int y = 0; y < renderer.height; y++) {
    for ( int x = 0; x < renderer.width; x++) {
      if ( grainTexturePixels[i] ) {
        // Black grain
        renderer.pixels[i] = 0;
      } else {
        color sampleColor = renderer.pixels[i];

        // Only change the pixels with the color of the sun
        if ( sunKeyColor == (0xFF000000 | sampleColor) ) {
          float originY = sunCenterY - sunRadius;
          float endY = sunCenterY + sunRadius;
          float step = map(y, originY, endY, 0, 1);

          color lc = 0x00FFFFFF & lerpColor(sunColors, step, RGB);

          color alpha = sampleColor & 0xFF000000;
          color gradientColor = alpha | lc;
          renderer.pixels[i] = gradientColor;
        }
      }
      
      i++;
    }
  }
  renderer.updatePixels();
  renderer.endDraw();
}

void drawSlitsInSun(PGraphics renderer) {
  // All the rectangular slits--same color as background
  // to create the illusion of missing pieces in the sun
  renderer.beginDraw();
  renderer.noStroke();
  renderer.fill(bgColor);

  for( Rectangle r : slits ) {
    renderer.noStroke();
    renderer.fill(bgColor);
    renderer.rect(r.x, r.y, r.w, r.h);

    r.y--;

    if ( r.y < sunsetY ) {
      r.y = sunCenterY + sunRadius;
    }

    // Resize the height of the slits as they move up.
    // Y coordinate must be calculated first
    r.h = (int)map(r.y, sunsetY, (sunCenterY + sunRadius), 1, sunRadius / numBands);
    r.x = int(sunCenterX - sqrt( sq(sunRadius + glowRadius) - sq(r.y - sunCenterY) )); 
    r.w = int(sunCenterX + sqrt( sq(sunRadius + glowRadius) - sq(r.y - sunCenterY) )) - r.x;
  }

  renderer.endDraw();
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
