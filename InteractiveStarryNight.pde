final int STAGE_WIDTH = 1200;
final int STAGE_HEIGHT = 950;
final int NB_PARTICLES = 60000;
final float MAX_PARTICLE_SPEED = 2.5;
final float PARTICULE_SIZE = 2;
final int MIN_LIFE_TIME = 10;
final int MAX_LIFE_TIME = 20;
final String IMAGE_PATH = "starrynight.jpg";
myVector tabParticles[];
PImage myImage;
int imageW;
int imageH;
color myPixels[];
FlowField ff;

void setup()
{
  size(1200, 950, P3D);
  background(0);
  initializeImage();
  initializeParticles();
  ff = new FlowField(5);
}

void initializeImage()
{
  myImage = loadImage(IMAGE_PATH);
  imageW = myImage.width;
  imageH = myImage.height;
  myPixels = new color[imageW * imageH];
  myImage.loadPixels();
  myPixels = myImage.pixels;
  image(myImage, 0, 0);
}

void setParticle(int i) {
  tabParticles[i] = new myVector((int)random(imageW), (int)random(imageH));
  tabParticles[i].prevX = tabParticles[i].x;
  tabParticles[i].prevY = tabParticles[i].y;
  tabParticles[i].count = (int)random(MIN_LIFE_TIME, MAX_LIFE_TIME);
  tabParticles[i].myColor = myPixels[(int)(tabParticles[i].y)*imageW + (int)(tabParticles[i].x)];
}

void initializeParticles()
{
  tabParticles = new myVector[NB_PARTICLES];
  for (int i = 0; i < NB_PARTICLES; i++)
  {
    setParticle(i);
  }
}

void draw()
{
  float vx;
  float vy;
  PVector v;
  for (int i = 0; i < NB_PARTICLES; i++)
  {
    tabParticles[i].prevX = tabParticles[i].x;
    tabParticles[i].prevY = tabParticles[i].y;
    v = ff.lookup(tabParticles[i].x, tabParticles[i].y);
    vx = v.x;
    vy = v.y;
    vx = constrain(vx, -MAX_PARTICLE_SPEED, MAX_PARTICLE_SPEED);
    vy = constrain(vy, -MAX_PARTICLE_SPEED, MAX_PARTICLE_SPEED);
    tabParticles[i].x += vx;
    tabParticles[i].y += vy;
    tabParticles[i].count--;
    if ((tabParticles[i].x < 0) || (tabParticles[i].x > imageW-1) ||
      (tabParticles[i].y < 0) || (tabParticles[i].y > imageH-1) ||
      tabParticles[i].count < 0) {
      setParticle(i);
    }
    strokeWeight(sqrt(vx*vx + vy*vy)*1.5*PARTICULE_SIZE);
    stroke(tabParticles[i].myColor, 200);
    line(tabParticles[i].prevX, tabParticles[i].prevY, tabParticles[i].x, tabParticles[i].y);
  }
}

void mouseDragged() {
  ff.onMouseDrag();
}

void keyPressed() {
  if (key =='s' || key == 'S') {
    //ff.saveField();
  }
}

class myVector extends PVector
{
  myVector (float p_x, float p_y) {
    super(p_x, p_y);
  }
  float prevX;
  float prevY;
  int count;
  color myColor;
}