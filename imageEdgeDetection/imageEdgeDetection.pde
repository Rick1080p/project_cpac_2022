import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
  

float[][] kernel1 = {{ -1, -1, -1},
                     { -1,  8, -1},
                     { -1, -1, -1}};
                      
                      
float [] [] kernel2 = {{0, -1, 0},
                      {-1, 4, -1},
                      {0, -1, 0}};
  
PImage img;
PImage edges;
ArrayList<Particle> particles;
ArrayList<Attractor> attractors;
Attractor attractor;
Attractor attractor2;
VerletPhysics2D physics;
  
  
  void setup() {
    fullScreen();
    smooth();
    img = loadImage("pisa.jpg"); // Load the original image
    particles = new ArrayList<Particle>();
    attractors = new ArrayList<Attractor>();
    physics = new VerletPhysics2D();
    edges = edgeDetection(img);
    addParticlesAndAttractorsOnPixels(edges);
  }
  
  PImage edgeDetection(PImage sourceImg){
    sourceImg.loadPixels();
    img.loadPixels();
    // Edge detection should be done on a grayscale image.
    //  Create a copy of the source image, and convert to gray.
   
    PImage grayImg = img.copy();
    grayImg.filter(GRAY);
    grayImg.filter(BLUR);
  
    // Create an opaque image of the same size as the original
    PImage edgeImg = createImage(grayImg.width, grayImg.height, RGB);
  
    // Loop through every pixel in the image
    for (int y = 1; y < grayImg.height-1; y++) {   // Skip top and bottom edges
      for (int x = 1; x < grayImg.width-1; x++) {  // Skip left and right edges
      
      
        // Output of this filter is shown as offset from 50% gray.
        // This preserves transitions from low (dark) to high (light) value.
        // Starting from zero will show only high edges on black instead.
        float sum = 128;
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            // Calculate the adjacent pixel for this kernel point
            int pos = (y + ky) * grayImg.width + (x + kx);
  
            // Image is grayscale, red/green/blue are identical
            float val = blue(grayImg.pixels[pos]);
            
            // Multiply adjacent pixels based on the kernel values
            sum += kernel2[ky+1][kx+1] * val;
          }
        }
        // For this pixel in the new image, set the output value
        // based on the sum from the kernel
        edgeImg.pixels[y*edgeImg.width + x] = color(sum);
      }
    }
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels();
    
    edgeImg.filter(THRESHOLD, 0.47);
    edgeImg.loadPixels();
    
    PImage maskImg = edgeImg.copy();
    maskImg.loadPixels();
    for (int y = 1; y < edgeImg.height-1; y++) {   // Skip top and bottom edges
      for (int x = 1; x < edgeImg.width-1; x++) {
        int pixel = edgeImg.pixels[y*edgeImg.width + x];
        color black = color(0);
        color white = color(255);
        switch(pixel){
          case -1:
          maskImg.set(x,y,white);
          break;
          
          default:
          maskImg.set(x,y,black);
          break;
        }
      }
    }
    return maskImg;
  }
  
  void addParticlesAndAttractorsOnPixels(PImage edges){
    for (int y = 1; y < edges.height-1; y+=6) {    //<>//
      for (int x = 1; x < edges.width-1; x+=6) {
        switch(edges.get(x,y)){
          case -16777216:
            particles.add(new Particle(new Vec2D(x,y)));
            attractors.add(new Attractor(new Vec2D(x,y), 5, 0.1));
          break;
          
          default:
          break;
        }
      }
    }
  }
  
  void draw() {
    background(0);
    physics.update();
    
    for(Particle p: particles) {
      p.display();
    }
    
    for(Attractor a: attractors) {
      a.lock();
    }
  }
