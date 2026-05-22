import java.util.ArrayList;

class Shape {
  int type;
  float x, y;
  float size;
  float life;
  float maxLife;
  float speed;
  color c;
  
  Shape(float w, float h) {
    type = (int)random(3);
    x = random(w);
    y = random(h);
    size = random(10, 40);
    life = 0;
    maxLife = random(120, 200);
    speed = random(0.01, 0.03);
    
    float hue = random(260, 300);
    c = color(hue, 180, 200);
  }
  
  boolean update() {
    life += speed;
    
    if (life >= 1) {
      life = 1;
      speed = -random(0.01, 0.03);
    }
    
    if (life <= 0) {
      return false;
    }
    
    return true;
  }
  
  void draw() {
    float alpha = life * 150;
    fill(c, alpha);
    noStroke();
    
    pushMatrix();
    translate(x, y);
    rotate(life * TWO_PI);
    scale(life);
    
    if (type == 0) {
      ellipse(0, 0, size, size);
    } else if (type == 1) {
      triangle(0, -size/2, -size/2, size/2, size/2, size/2);
    } else {
      rect(-size/2, -size/2, size, size);
    }
    
    popMatrix();
  }
}

class ShapeBackground {
  ArrayList<Shape> shapes;
  float width, height;
  int maxShapes;
  
  ShapeBackground(float w, float h) {
    width = w;
    height = h;
    maxShapes = 20;
    shapes = new ArrayList<Shape>();
    
    for (int i = 0; i < 10; i++) {
      shapes.add(new Shape(width, height));
      shapes.get(i).life = random(1);
    }
  }
  
  void update() {
    for (int i = shapes.size() - 1; i >= 0; i--) {
      if (!shapes.get(i).update()) {
        shapes.remove(i);
      }
    }
    
    while (shapes.size() < maxShapes && random(1) < 0.02) {
      shapes.add(new Shape(width, height));
    }
  }
  
  void draw() {
    background(0);
    
    for (Shape s : shapes) {
      s.draw();
    }
  }
}