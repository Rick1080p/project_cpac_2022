// A simple Particle class
class Particle extends VerletParticle2D {
  
  float r;

  Particle(Vec2D loc) {
    super(loc);
    r = 2;
    physics.addParticle(this);
    //physics.addBehavior(new AttractionBehavior2D(this, r, -0.5));
  }

  // Method to display
  void display() {
    fill(255, 100);
    stroke(0);
    ellipse(x, y, r*2, r*2);
  }
}
