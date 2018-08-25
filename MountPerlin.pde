import ddf.minim.*;
//import ddf.minim.analysis.*;
//Minim minim;

//AudioPlayer player;
int cols, rows;
int scl = 20;
float[][] terrain;
int w, h;
float flyint = 0;
float[] bias;
float roll, pitch, yaw;
int count = -1;
int scale = 300;
float colorSeed;
float[] levels;
float[] dcSeed = {
  random(100), 
  random(100), 
  random(100)
};
void setup() {
  size(displayWidth, displayHeight, P3D);
  loadLevels();
  w = width+1000;
  h = height+900;
  cols = w/scl;
  rows = h/scl;
  float yoff=0;
  terrain = new float[rows][cols];
  for (int y=0; y<rows; y++) {
    float xoff=0;
    for (int x=0; x<cols; x++) {
      terrain[y][x] = map(noise(xoff, yoff), 0, 1, -150, 150);
      xoff+=0.1;
    }
    yoff+=0.1;
  }
  //minim = new Minim(this);
  //player = minim.loadFile("bgm.mp3", 512);
  bias = new float[cols];
  print(cols);
  for (int i=0; i<cols; i++) {
    if ( i < 2*cols/5 || 3*cols/5 < i) {
      bias[i] = 1.0;
    } else {
      bias[i] = 1.0;
    }
  }
  //player.play();
  colorSeed = random(100);
}

void draw() {
  //if (!player.isPlaying()) {
  //  println("is: fin");
  //  noLoop();
  //}
  //float level = player.mix.level();
  if(frameCount>=14068) {
    println("finish RENDERING in ", frameCount, " counts");
    exit();
  }
  float level = levels[frameCount];
  //fft.forward(player.mix);
  flyint-=0.05;
  for (int i=0; i<3; i++) {
    dcSeed[i] += level*0.001;
  }
  float yoff=flyint;
  terrain = new float[rows][cols];
  for (int y=0; y<rows; y++) {
    float xoff=0;
    for (int x=0; x<cols; x++) {
      if (count>2 || count<0) {
        //int index = (int)map(x,0,cols, 0, fft.specSize());
        terrain[y][x] = map(noise(xoff, yoff), 0, 1, -scale*level, scale*level);
        //terrain[y][x] = map(noise(xoff,yoff), 0, 1, -200*fft.getBand(index), 200*fft.getBand(index));
        //terrain[y][x] = map(noise(xoff,yoff), 0, 1, -200*bias[x], 200*bias[x]);
      } else {
        terrain[y][x] = map(noise(xoff, yoff), 0, 1, -150, 150);
      }
      xoff+=0.1;
    }
    yoff+=0.1;
  }
  translate(width/2, height/2-200,100);
  if (count>3 || count<0) {
    rotateZ((noise(frameCount/51.0)-0.5)*0.2);
    //rotateZ(map(roll, -1, 1, -PI, PI));
    rotateX(PI/3 + (noise(frameCount/47.0-0.5)*0.15));
    //rotateX(map(pitch, 1, -1, PI/2, PI/4));
    //rotateX(PI/3);
  } else {
    rotateX(PI/3);
  }
  background(0);
  stroke(255);
  noFill();
  translate(-w/2, -h/2);
  for (int y=0; y<rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<cols; x++) {
      if (count>1||count<0) {
        if (scale*level*(0.2*(noise(frameCount/10.0)-0.5))< terrain[y][x]) {
          float f_l_noise = colorSeed + noise(flyint+noise(level));
          float ynoise = noise(y/5.0+f_l_noise);
          float xnoise = noise(ynoise+x/5.0);
          float c1 = ((float)frameRate)/noise(dcSeed[0])+ynoise+xnoise;
          float c2 = ((float)frameRate)/noise(dcSeed[1])+ynoise+xnoise;
          float c3 = ((float)frameRate)/noise(dcSeed[2])+ynoise+xnoise;
          stroke(100+155*noise(c1), 100+155*noise(c2), 100+155*noise(c3));
        } else {
          stroke(255, 255, 255);
        }
      } else {
        stroke(255, 255, 255);
      }
      if (count>0||count<0) {
        vertex(x*scl, y*scl, terrain[y][x]);
        vertex(x*scl, (y+1)*scl, terrain[y+1][x]);
      } else {
        vertex(x*scl, y*scl);
        vertex(x*scl, (y+1)*scl);
      }
    }

    endShape();
  }
 saveFrame("frames/######.tif");
}
//void stop() {
//  player.close();
//  minim.stop();
//  super.stop();
//}
//void webSocketServerEvent(String msg){
//  float[] data = new float[3];
//  String[] msgs = msg.split(",");
//  for(int i=0; i<3; i++) {
//    data[i] = float(msgs[i].split(":")[1]);
//  }
//  roll = data[0];
//  pitch = data[0];
//  yaw = data[0];
//}

void keyPressed() {
  switch(keyCode) {
  case 38:
    scale += 50;
    break;
  case 40:
    scale -= 50;
    break;
  case 10:
    count += 1;
    break;
  }
}
void loadLevels() {
  String[] strs = loadStrings( "output.txt" );
  if( strs == null ){
    //読み込み失敗
    println( " 読み込み失敗" );
    exit();
  }
  levels = new float[strs.length-2];
  for(int i=0; i<strs.length-2; i++) {
    levels[i] = float(strs[i]);
  }
}
class saveFrameThread implements Runnable {  
  public synchronized void run() {  
    
  }  
}  