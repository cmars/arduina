/**
 * Pointillism
 * by Daniel Shiffman. 
 * 
 * Mouse horizontal location controls size of dots. 
 * Creates a simple pointillist effect using ellipses colored
 * according to pixels in an image. 
 * 
 * Updated 27 February 2010.
 */
 
PImage img;

int smallPoint = 2;
int largePoint;
int top, left;

int[][] points = { { 300, 70 }, { 100, 270 }, { 500, 270 }, { 200, 530 }, { 400, 530 } };

float[] osc = { 0.0, 0.0, 0.0, 0.0, 0.0 };
float[] oscInc = { 0.02, 0.049, 0.0079, 0.0169, 0.03 };

void setup() {
  size(600, 600);
  noStroke();
  smooth();
  largePoint = 10;
  
  for (int i = 0; i < points.length; i++) {
    osc[i] = random(9000);
  }
  
// center the image on the screen
//  left = (width - img.width) / 2;
//  top = (height - img.height) / 2;
}

int valuePhase(float sine) {
  sine = (sine + 1.0) / 2.0;
  return (int)min(sine * 256, 255.0);
}

void draw() { 
  background(0);
  for (int pi = 0; pi < points.length; pi++) {
    float pointillize = 60;//map(mouseX, 0, width, smallPoint, largePoint);
    int x = points[pi][0];
    int y = points[pi][1];
    int r = (int)random(256);
    
    float rads = osc[pi];
    float phase = sin(pow(osc[pi], 0.9));
    if ((int)osc[pi] % 13 == 0) {
      phase = sin(tan(osc[pi]));
      osc[pi] += 0.8;
    }
    
    fill(valuePhase(phase));
    
    if (r % 23 == 0) {
      osc[pi] += oscInc[r % points.length];
    }
    else {
      osc[pi] += 0.0079;
    }
    
    ellipse(left + x, top + y, pointillize, pointillize);
  }
}

