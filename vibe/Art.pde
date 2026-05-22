class ArtLevel {
  PImage image;
  String name;

  ArtLevel(PImage img, String levelName) {
    image = img;
    name = levelName;
  }
}

class Art {
  String name;
  Art[] effects;
  String[] effectText;
  boolean isTaught;
  int currentLevel;
  ArtLevel[] levels;

  Art(String artName, ArtLevel[] artLevels) {
    name = artName;
    levels = artLevels;
    currentLevel = 0;
    effects = new Art[0];
    effectText = new String[0];
    isTaught = false;
  }

  void setEffects(Art[] requiredArts, String[] texts) {
    effects = requiredArts;
    effectText = texts;
  }

  Art[] getEffects() {
    return effects;
  }

  void teach() {
    isTaught = true;
    
    for (int i = 0; i < effects.length; i++) {
      Art effectArt = effects[i];
      if (effectArt.isTaught && effectArt.isMaxLevel() && !isMaxLevel()) {
        upgrade();
        println(name + " 因 " + effectArt.name + " 已达到最高等级而获得额外升级: " + effectText[i]);
      }
    }
  }

  void upgrade() {
    if (currentLevel < levels.length - 1) {
      currentLevel++;
    }
  }

  ArtLevel getCurrentLevel() {
    return levels[currentLevel];
  }

  boolean isMaxLevel() {
    return currentLevel >= levels.length - 1;
  }
}
