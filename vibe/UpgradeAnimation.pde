import java.util.ArrayList;

class UpgradeAnimation {
  ArrayList<Particle> particles;
  Art targetArt;
  int targetIndex;
  int currentEffectIndex;
  String currentText;
  int textTimer;
  float glowAlpha;
  boolean isAnimating;
  boolean isFusing;
  int fuseTimer;
  PApplet parent;
  
  UpgradeAnimation(PApplet p) {
    parent = p;
    particles = new ArrayList<Particle>();
    isAnimating = false;
  }
  
  void start(Art art, int index) {
    targetArt = art;
    targetIndex = index;
    currentEffectIndex = -1;
    currentText = "";
    textTimer = 0;
    glowAlpha = 0;
    isAnimating = true;
    isFusing = false;
    fuseTimer = 0;
  }
  
  void update(PVector targetPos, Art[] allArts, PVector[] positions) {
    if (!isAnimating) return;
    
    if (currentEffectIndex < 0) {
      currentEffectIndex = 0;
      if (targetArt.effects.length == 0) {
        isAnimating = false;
        return;
      }
    }
    
    if (particles.isEmpty()) {
      if (currentEffectIndex < targetArt.effects.length) {
        Art effectArt = targetArt.effects[currentEffectIndex];
        
        if (effectArt.isTaught && effectArt.isMaxLevel()) {
          int effectIndex = -1;
          for (int i = 0; i < allArts.length; i++) {
            if (allArts[i].name.equals(effectArt.name)) {
              effectIndex = i;
              break;
            }
          }
          
          if (effectIndex >= 0) {
            PVector sourcePos = positions[effectIndex];
            
            for (int i = 0; i < 20; i++) {
              particles.add(new Particle(sourcePos, targetPos));
            }
            
            currentText = targetArt.effectText[currentEffectIndex];
            textTimer = 180;
            
            currentEffectIndex++;
          }
        } else {
          currentEffectIndex++;
        }
      } else {
        isAnimating = false;
      }
    }
    
    boolean wasEmpty = particles.isEmpty();
    
    for (int i = particles.size() - 1; i >= 0; i--) {
      if (!particles.get(i).update()) {
        particles.remove(i);
      }
    }
    
    if (!wasEmpty && particles.isEmpty() && currentEffectIndex > 0 && currentEffectIndex <= targetArt.effects.length) {
      if (!targetArt.isMaxLevel()) {
        targetArt.upgrade();
        println(targetArt.name + " 升级了！");
        SoundFile upgradeSound = new SoundFile(parent, "data/音效/升级.mp3");
        upgradeSound.play();
      }
    }
    
    if (textTimer > 0) {
      textTimer--;
    }
  }
  
  void draw() {
    if (!isAnimating) return;
    
    for (Particle p : particles) {
      p.draw();
    }
    
    if (textTimer > 0) {
      float progress = textTimer / 180.0;
      float alpha = progress * 255;
      float scale = 0.8 + (1 - progress) * 0.4;
      
      pushMatrix();
      translate(width/2, height/2);
      scale(scale);
      
      fill(255, 255, 255, alpha);
      textSize(32);
      textAlign(CENTER, CENTER);
      text(currentText, 0, 0);
      
      popMatrix();
    }
  }
  
  boolean isActive() {
    return isAnimating;
  }
}