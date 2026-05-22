class NoiseBackground {
  float offsetX;
  float offsetY;
  float speed;
  
  NoiseBackground() {
    offsetX = random(1000);
    offsetY = random(1000);
    speed = 0.002;
  }
  
  void update() {
    offsetX += speed;
    offsetY += speed * 0.7;
  }
  
  void draw() {
    loadPixels();
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        float noiseValue = noise(x * 0.01 + offsetX, y * 0.01 + offsetY);
        float noiseValue2 = noise(x * 0.005 + offsetY, y * 0.005 + offsetX);
        
        float combinedNoise = (noiseValue + noiseValue2) * 0.5;
        
        float blue = map(combinedNoise, 0, 1, 0, 80);
        float darkBlue = map(combinedNoise, 0, 1, 0, 30);
        float alpha = map(combinedNoise, 0, 1, 50, 150);
        
        color c = color(darkBlue, darkBlue + 20, blue, alpha);
        pixels[y * width + x] = c;
      }
    }
    
    updatePixels();
    
    for (int i = 0; i < 5; i++) {
      float streakX = noise(offsetX * 2 + i) * width;
      float streakY = noise(offsetY * 2 + i) * height;
      float streakLength = noise(offsetX * 3 + i) * 100 + 50;
      float streakAngle = noise(offsetY * 3 + i) * TWO_PI;
      
      stroke(80, 100, 150, 30);
      strokeWeight(2);
      line(
        streakX, 
        streakY, 
        streakX + cos(streakAngle) * streakLength, 
        streakY + sin(streakAngle) * streakLength
      );
    }
  }
}