int cols, rows;
int scl = 20;
float[][] terrain;
int w,h;
float flyint = 0;

void setup() {
  size(displayWidth, displayHeight, P3D);
  w = width+1000;
  h = height+900;
  cols = w/scl;
  rows = h/scl;
  float yoff=0;
  terrain = new float[rows][cols];
  for (int y=0; y<rows; y++) {
    float xoff=0;
    for (int x=0; x<cols; x++) {
      terrain[y][x] = map(noise(xoff,yoff), 0, 1, -150, 150);
      xoff+=0.1;
    }
    yoff+=0.1;
  }
}

void draw() {
  flyint-=0.05;
  float yoff=flyint;
  terrain = new float[rows][cols];
  for (int y=0; y<rows; y++) {
    float xoff=0;
    for (int x=0; x<cols; x++) {
      terrain[y][x] = map(noise(xoff,yoff), 0, 1, -150, 150);
      xoff+=0.1;
    }
    yoff+=0.1;
  }
  translate(width/2, height/2-100);
  rotateX(PI/3);
  background(0);
  stroke(255);
  noFill();
  translate(-w/2, -h/2);
  for (int y=0; y<rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<cols; x++) {
      vertex(x*scl, y*scl, terrain[y][x]);
      vertex(x*scl, (y+1)*scl, terrain[y+1][x]);
    }
    endShape();
  }
}