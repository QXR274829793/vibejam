class Particle {
  PVector position;
  PVector velocity;
  float life;
  float maxLife;
  color c;
  PVector target;
  float acceleration;
  
  Particle(PVector pos, PVector targetPos) {
    float offsetX = random(-30, 30);
    float offsetY = random(-30, 30);
    position = new PVector(pos.x + offsetX, pos.y + offsetY);
    target = targetPos.copy();
    
    float dx = target.x - position.x;
    float dy = target.y - position.y;
    float dist = sqrt(dx * dx + dy * dy);
    
    velocity = new PVector(dx / dist, dy / dist);
    velocity.mult(random(2, 4));
    
    acceleration = random(1.02, 1.05);
    
    life = 1.0;
    maxLife = random(60, 90);
    
    float hue = random(30, 50);
    c = color(hue, 255, 255);
  }
  
  boolean update() {
    velocity.mult(acceleration);
    position.add(velocity);
    
    float dx = target.x - position.x;
    float dy = target.y - position.y;
    float dist = sqrt(dx * dx + dy * dy);
    
    if (dist < 5 || dist > 500) {
      return false;
    }
    
    life -= 1.0 / maxLife;
    return life > 0;
  }
  
  void draw() {
    float size = life * 8;
    float alpha = life * 255;
    
    fill(255, 215, 0, alpha);
    noStroke();
    ellipse(position.x, position.y, size * 2, size * 2);
    
    fill(c, alpha);
    ellipse(position.x, position.y, size, size);
  }
}
