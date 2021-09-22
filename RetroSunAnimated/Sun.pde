public class Sun {
  // HSB colors
  color[] sunColors = {
    color(57, 94.8, 83.1), 
    color(55, 86, 83.9), 
    color(47, 87.7, 82.7), 
    color(39, 76.4, 84.7), 
    color(24, 71, 85.1), 
    color(10, 62, 83.5), 
    color(342, 75.9, 83.1), 
    color(330, 86.5, 84.3), 
    color(323, 94.9, 85.1), 
    color(318, 100, 85.1)
  };
/*
  // RGB colors
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
*/
  color sunKeyColor;
  int sunRadius;
  int sunCenterX;
  int sunCenterY;
  int sunsetY;
  float speed;;
  
  int numBands;
  int[] sunsetBandHeights;
  int slitSpacePixels;
  int slitTopBoundary;
  ArrayList<Rectangle> slits;
  
  Sun(int radius, int numBands, float speed) {
    this.sunRadius = radius;
    this.numBands = numBands;
    this.speed = speed;
    
    // Green
    sunKeyColor = color(120, 100, 100, 255);
    
    // Setup sun position
    initialize(width / 2, (height / 2) - 50);
  }

  void initialize(int sunWidth, int sunHeight){
    this.sunCenterX = sunWidth;
    this.sunCenterY = sunHeight;
    sunsetY = sunCenterY - (sunRadius / 4);
    
    slitSpacePixels = (sunCenterY + sunRadius - sunsetY ) / numBands;
    slitTopBoundary = sunCenterY - (sunRadius / 4);
    slits = new ArrayList<Rectangle>();
    
    // Setup sunset slits
    int slitStartY = sunsetY;
    for ( int i = 0; i < numBands; i++ ) {
      float sunsetBandHeight = map(i+1, 1, 10, 1, sunRadius / numBands);

      float y = slitStartY;
      int h = (int)sunsetBandHeight;
      int x = int(sunCenterX - sqrt( sq(sunRadius) - sq(y - sunCenterY) )); 
      int w = int(sunCenterX + sqrt( sq(sunRadius) - sq(y - sunCenterY) )) - x;
      Rectangle r = new Rectangle(x, y, w, h);
      slits.add(r);

      slitStartY += slitSpacePixels;
    }
  }
  
  void draw(){
    drawSun();
    drawSlitsInSun();
  }
  
  void drawSun() {
    // Sun base
    noStroke();
    fill(sunKeyColor);
    ellipse(sunCenterX, sunCenterY, 2*sunRadius, 2*sunRadius);

    // Cover the bottom of the circle to make it look like a sunrise/sunset
    int rY = sunCenterY + sunRadius - (sunRadius / 5);
    int rX = int(sunCenterX - sqrt( sq(sunRadius) - sq(rY - sunCenterY) ));
    int rW = int(sunCenterX + sqrt( sq(sunRadius) - sq(rY - sunCenterY) )) - rX;
    int rH = sunRadius / 5;
    fill(bgColor);
    rect( rX, rY, rW, rH );

    // Lindear color gradient
    loadPixels();
    int i = 0;
    for( int y = 0; y < height; y++ ) {
      for( int x = 0; x < width; x++ ) {
        color sampleColor = pixels[i];
    
        // Only change the pixels with the color of the sun
        if( sunKeyColor == (0xFF000000 | sampleColor) ) {
          float originY = sunCenterY - sunRadius;
          float endY = sunCenterY + sunRadius;
          float step = map(y, originY, endY, 0, 1);
    
          color lc = interpolateColor(sunColors, step, RGB);
    
          // alpha set to full opacity
          color alpha = 0xFF000000;
          color gradientColor = alpha | lc;
          pixels[i] = gradientColor;
        }
        
        i++;
      }
    }
    
    // Must call after all changes to the pixels array
    updatePixels();
  }
  
  void drawSlitsInSun(){
    // All the rectangular slits--same color as background
    // to create the illusion of missing pieces in the sun
    noStroke();
    fill(bgColor);

    for( Rectangle r : slits ) {
 //<>//
      noStroke();
      fill(bgColor);
      rect(r.x, r.y, r.w, r.h);

      r.y -= speed; //<>//

      if ( r.y < sunsetY ) {
        r.y = sunCenterY + sunRadius;
      }

      // Resize the height of the slits as they move up.
      // Y coordinate must be calculated first
      r.h = (int)map(r.y, sunsetY, (sunCenterY + sunRadius), 1, sunRadius / numBands);
      r.x = int(sunCenterX - sqrt( sq(sunRadius) - sq(r.y - sunCenterY) ));
      r.w = int(sunCenterX + sqrt( sq(sunRadius) - sq(r.y - sunCenterY) )) - r.x;
      r.w += 2;   // 2-pixel padding looks better near the top
    }
  }
}
