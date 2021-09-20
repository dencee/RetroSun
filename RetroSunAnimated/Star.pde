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
