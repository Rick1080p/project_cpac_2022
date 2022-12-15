// An ArrayList is used to manage the list of Particles

class Attractor extends VerletParticle2D {

  float r;
  float strength;
  Attractor(Vec2D loc, float r, float strength) {
    super(loc);
    this.r = r;
    this.strength = strength;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior2D(this, r*2, strength));
  }
  
  void updateRadius(float r){
    this.r = r;
  }
  
    void updateStrength(float strength){
    this.strength = strength;
  }
}
