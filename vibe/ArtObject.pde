class ArtObject extends GameObject {
  Art art;
  float maxSize;

  ArtObject(Art artInstance) {
    art = artInstance;
    maxSize = 100;
  }

  ArtObject(Art artInstance, float size) {
    art = artInstance;
    maxSize = size;
  }

  void draw(PVector position, float scale, float rotate) {
    draw(position, scale, rotate, null);
  }

  void draw(PVector position, float scale, float rotate, PVector mousePos) {
    ArtLevel currentLevel = art.getCurrentLevel();
    PImage sprite = currentLevel.image;

    pushMatrix();
    translate(position.x, position.y);
    rotate(rotate);
    
    float hoverScale = scale;
    boolean isHovered = false;
    
    if (mousePos != null && !art.isTaught) {
      float dist = dist(mousePos.x, mousePos.y, position.x, position.y);
      if (dist < maxSize) {
        hoverScale = scale * 1.1;
        isHovered = true;
      }
    }
    
    scale(hoverScale);
    
    imageMode(CENTER);
    
    float imgScale = 1;
    float displaySize = maxSize;
    
    if (sprite != null) {
      imgScale = min(maxSize / sprite.width, maxSize / sprite.height);
      displaySize = max(maxSize * imgScale, maxSize);
    }
    
    if (art.isTaught && art.isMaxLevel()) {
      for (int i = 0; i < 3; i++) {
        noFill();
        stroke(255, 215, 0, (3 - i) * 50);
        strokeWeight(4 + i * 2);
        ellipse(0, 0, displaySize + 20 + i * 10, displaySize + 20 + i * 10);
      }
    }
    
    if (isHovered) {
      noFill();
      stroke(0, 150, 255);
      strokeWeight(3);
      ellipse(0, 0, displaySize + 10, displaySize + 10);
    }
    
    if (sprite != null) {
      if (!art.isTaught) {
        PImage graySprite = sprite.get();
        graySprite.filter(GRAY);
        image(graySprite, 0, 0, sprite.width * imgScale, sprite.height * imgScale);
      } else {
        image(sprite, 0, 0, sprite.width * imgScale, sprite.height * imgScale);
      }
    }
    
    popMatrix();
  }
}
