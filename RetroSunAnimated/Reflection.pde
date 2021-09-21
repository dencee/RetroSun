class Reflection {
  color[] barColors = {
    color(45, 2, 59), 
    color(109, 0, 88), 
    color(154, 51, 86), 
    color(158, 79, 62), 
    color(154, 51, 86), 
    color(109, 0, 88), 
    color(45, 2, 59)
  };
  
  int numReflectionBars;
  int topX;
  int topY;
  int topWidth;
  int bottomY;
  int maxHeight;
  float speed;
  ArrayList<Rectangle> lowerBars;
  
  Reflection(int numBars, int topX, int topY, float speed){
    this.numReflectionBars = numBars;
    this.topX = topX;
    this.topY = topY;
    this.speed = speed;
    topWidth = 2 * (sunRadius + sunRadius/3);
    maxHeight = 10;
    bottomY = topY + (numBars * 2 * maxHeight);
    lowerBars = new ArrayList<Rectangle>();
    
    // Setup bottom relection bars
    int x = topX;
    int y = topY;
    int w = topWidth;
    int h = maxHeight;
    for ( int i = 0; i < numReflectionBars; i++ ) {   
      y += (bottomY - topY) / numBars;
      x += sunRadius / 16;
      w -= 2 * (sunRadius / 16);

      Rectangle r = new Rectangle(x, y, w, h);
      lowerBars.add(r);
    }
  }
  
  void draw(){
    strokeWeight(1);
    
    for ( Rectangle bar : lowerBars ) {
      for ( int i = (int)bar.x; i < bar.x + bar.w; i++ ) {
        float alphaMax = -255 - ((bar.y - topY));
        float alphaMin = 255 + ((bar.y - topY));
        float alpha = map(i, bar.x, bar.x + bar.w, alphaMin, alphaMax);
        float step = map(i, bar.x, bar.x + bar.w, 0, 1);
        color lc = interpolateColor(barColors, step, RGB);
    
        stroke(lc, 255 - abs(alpha));
        line(i, bar.y, i, bar.y + bar.h);
      }
      
      bar.y += speed;
      bar.x += 2 * speed;
      bar.w -= 2 * (2 * speed);

      if( bar.y > bottomY ) {
        // Bar at bottom, reset to top
        
        bar.x = topX;
        bar.y = topY + maxHeight;
        bar.w = topWidth;
        bar.h = 1;
      } else if( bar.y > bottomY - maxHeight ) {
        // Bar near bottom
        
        bar.h -= speed;
      } else if( bar.h < maxHeight ) {
        // Bar height just reset and at top
        
        bar.y -= speed;
        bar.h += speed;
      }
    }
  }
}
