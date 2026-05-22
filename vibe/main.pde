import java.util.HashMap;
import java.awt.Font;
import processing.sound.*;

ArtLoader loader;
Art[] arts;
ArtObject[] artObjects;
PVector[] positions;
int objectSize = 120;
PFont chineseFont;
int gameIndex = -1;
UpgradeAnimation upgradeAnim;
boolean isUpgrading;
int upgradeArtIndex;
ShapeBackground bg;
boolean gameCompleted;
boolean gameCompletedSoundPlayed;
SoundFile gameOverSound;
SoundFile upgradeSound;
SoundFile bgm;

void setup() {
  size(800, 600);
  
  chineseFont = createFont("SimHei", 16);
  textFont(chineseFont);
  
  gameCompleted = false;
  gameCompletedSoundPlayed = false;
  
  try {
    bgm = new SoundFile(this, "data/背景音乐.mp3");
    bgm.loop();
  } catch (Exception e) {
    println("背景音乐文件不存在，跳过播放");
  }
  
  loader = new ArtLoader();
    loader.loadArtsFromCSV("data/arts.csv");
    
    arts = loader.getAllArts();
    artObjects = new ArtObject[arts.length];
    positions = new PVector[arts.length];
    upgradeAnim = new UpgradeAnimation(this);
    bg = new ShapeBackground(width, height);
  
  for (int i = 0; i < arts.length; i++) {
    artObjects[i] = new ArtObject(arts[i]);
    if (arts[i].name.equals("游戏")) {
      gameIndex = i;
    }
  }
  
  float centerX = width / 2;
  float centerY = height / 2;
  float radius = 200;
  
  int nonGameCount = 0;
  for (int i = 0; i < arts.length; i++) {
    if (i != gameIndex) nonGameCount++;
  }
  
  int index = 0;
  for (int i = 0; i < arts.length; i++) {
    if (i == gameIndex) {
      positions[i] = new PVector(centerX, centerY);
    } else {
      float angle = TWO_PI * index / nonGameCount - HALF_PI;
      float x = centerX + cos(angle) * radius;
      float y = centerY + sin(angle) * radius;
      positions[i] = new PVector(x, y);
      index++;
    }
  }
}

void draw() {
  bg.update();
  bg.draw();
  
  if (gameCompleted) {
    drawGameCompletedScreen();
    return;
  }
  
  PVector mousePos = new PVector(mouseX, mouseY);
  
  for (int i = 0; i < arts.length; i++) {
    if (i != gameIndex) {
      artObjects[i].draw(positions[i], 1.0, 0, mousePos);
      fill(255);
      textSize(14);
      textAlign(CENTER, TOP);
      text(arts[i].getCurrentLevel().name, positions[i].x, positions[i].y + 60);
    }
  }
  
  if (gameIndex >= 0) {
    artObjects[gameIndex].draw(positions[gameIndex], 1.2, 0, mousePos);
    fill(255);
    textSize(14);
    textAlign(CENTER, TOP);
    text(arts[gameIndex].getCurrentLevel().name, positions[gameIndex].x, positions[gameIndex].y + 70);
  }
  
  if (upgradeAnim.isActive()) {
    upgradeAnim.update(positions[upgradeArtIndex], arts, positions);
    upgradeAnim.draw();
    
    if (!upgradeAnim.isActive() && isUpgrading) {
      isUpgrading = false;
      checkGameCompleted();
    }
  }
  
  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  text("点击艺术形式进行传授！", 50, height - 60);
  text("选择正确的顺序等级会更高", 50, height - 40);
  text("挑战做出最厉害的游戏吧！", 50, height - 20);
}

void checkGameCompleted() {
  for (Art art : arts) {
    if (!art.isTaught) {
      return;
    }
  }
  gameCompleted = true;
}

void drawGameCompletedScreen() {
  background(0);
  
  if (!gameCompletedSoundPlayed) {
    gameOverSound = new SoundFile(this, "data/音效/游戏结束.mp3");
    gameOverSound.play();
    gameCompletedSoundPlayed = true;
  }
  
  fill(255);
  textSize(36);
  textAlign(CENTER, TOP);
  text("恭喜！所有艺术已传授完成！", width/2, 100);
  
  if (gameIndex >= 0) {
    Art gameArt = arts[gameIndex];
    ArtLevel currentLevel = gameArt.getCurrentLevel();
    
    pushMatrix();
    translate(width/2, height/2 - 50);
    
    float imgScale = min(200.0 / currentLevel.image.width, 200.0 / currentLevel.image.height);
    imageMode(CENTER);
    image(currentLevel.image, 0, 0, currentLevel.image.width * imgScale, currentLevel.image.height * imgScale);
    
    popMatrix();
    
    fill(255);
    textSize(24);
    textAlign(CENTER, TOP);
    text(gameArt.name + ": " + currentLevel.name, width/2, height/2 + 80);
  }
  
  float buttonWidth = 200;
  float buttonHeight = 50;
  float buttonX = width/2 - buttonWidth/2;
  float buttonY = height/2 + 150;
  
  if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    fill(150, 200, 255);
  } else {
    fill(100, 150, 255);
  }
  
  rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
  
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("重新开始游戏", buttonX + buttonWidth/2, buttonY + buttonHeight/2);
}

void mousePressed() {
  if (gameCompleted) {
    float buttonWidth = 200;
    float buttonHeight = 50;
    float buttonX = width/2 - buttonWidth/2;
    float buttonY = height/2 + 150;
    
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      restartGame();
      return;
    }
    return;
  }
  
  if (isUpgrading || upgradeAnim.isActive()) return;
  
  for (int i = 0; i < arts.length; i++) {
    PVector pos = positions[i];
    float dist = dist(mouseX, mouseY, pos.x, pos.y);
    
    if (dist < objectSize/2) {
      Art art = arts[i];
      if (!art.isTaught) {
        upgradeArtIndex = i;
        isUpgrading = true;
        
        art.isTaught = true;
        upgradeAnim.start(art, i);
        
        println("教授了: " + art.name + " -> " + art.getCurrentLevel().name);
      } else {
        println(art.name + " 已经被教授过了");
      }
      break;
    }
  }
}

void restartGame() {
  gameCompleted = false;
  gameCompletedSoundPlayed = false;
  isUpgrading = false;
  
  loader = new ArtLoader();
  loader.loadArtsFromCSV("data/arts.csv");
  
  arts = loader.getAllArts();
  artObjects = new ArtObject[arts.length];
  
  for (int i = 0; i < arts.length; i++) {
    artObjects[i] = new ArtObject(arts[i]);
    if (arts[i].name.equals("游戏")) {
      gameIndex = i;
    }
  }
}
