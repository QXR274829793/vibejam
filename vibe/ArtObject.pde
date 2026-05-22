class ArtObject extends GameObject {
  Art art;

  ArtObject(Art artInstance) {
    art = artInstance;
  }

  void draw(PVector position, float scale, float rotate) {
    ArtLevel currentLevel = art.getCurrentLevel();
    PImage sprite = currentLevel.image;

    pushMatrix();
    translate(position.x, position.y);
    rotate(rotate);
    scale(scale);
    
    imageMode(CENTER);
    image(sprite, 0, 0);
    
    popMatrix();
  }
}
