import java.util.HashMap;
import java.awt.Font;

ArtLoader loader;
Art[] arts;
int buttonWidth = 120;
int buttonHeight = 60;
int startX = 50;
int startY = 50;
int gapX = 140;
int gapY = 80;
PFont chineseFont;

void setup() {
  size(800, 500);
  
  chineseFont = createFont("SimHei", 16);
  textFont(chineseFont);
  
  loader = new ArtLoader();
  loader.loadArtsFromCSV("data/arts.csv");
  
  arts = loader.getAllArts();
}

void draw() {
  background(240);
  
  int row = 0;
  int col = 0;
  
  for (int i = 0; i < arts.length; i++) {
    Art art = arts[i];
    int x = startX + col * gapX;
    int y = startY + row * gapY;
    
    fill(art.isTaught ? 150 : 200);
    stroke(0);
    rect(x, y, buttonWidth, buttonHeight, 10);
    
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(art.name, x + buttonWidth/2, y + buttonHeight/3);
    
    String levelText = "Lv." + art.currentLevel + " " + art.getCurrentLevel().name;
    textSize(12);
    text(levelText, x + buttonWidth/2, y + buttonHeight*2/3);
    
    col++;
    if (col >= 3) {
      col = 0;
      row++;
    }
  }
  
  fill(0);
  textSize(14);
  textAlign(LEFT, TOP);
  text("点击艺术形式进行传授！", 50, 400);
}

void mousePressed() {
  int row = 0;
  int col = 0;
  
  for (int i = 0; i < arts.length; i++) {
    Art art = arts[i];
    int x = startX + col * gapX;
    int y = startY + row * gapY;
    
    if (mouseX >= x && mouseX <= x + buttonWidth &&
        mouseY >= y && mouseY <= y + buttonHeight) {
      if (!art.isTaught) {
        art.teach();
        println("教授了: " + art.name + " -> " + art.getCurrentLevel().name);
        
        for (int j = 0; j < art.effects.length; j++) {
          Art effectArt = art.effects[j];
          if (effectArt.isTaught && effectArt.isMaxLevel() && !art.isMaxLevel()) {
            println("影响触发: " + effectArt.name + " -> " + art.name + ": " + art.effectText[j]);
          }
        }
      } else {
        println(art.name + " 已经被教授过了");
      }
      break;
    }
    
    col++;
    if (col >= 3) {
      col = 0;
      row++;
    }
  }
}