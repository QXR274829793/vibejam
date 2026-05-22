import java.util.HashMap;

class ArtLoader {
  HashMap<String, Art> artMap;

  ArtLoader() {
    artMap = new HashMap<String, Art>();
  }

  void loadArtsFromCSV(String filePath) {
    String[] lines = loadStrings(filePath);
    
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty()) continue;
      
      String[] parts = line.split(",");
      if (parts.length >= 3) {
        String artName = parts[0].trim();
        int maxLevel = Integer.parseInt(parts[1].trim());
        String[] levelNames = parts[2].trim().split(";");
        
        ArtLevel[] levels = new ArtLevel[maxLevel];
        for (int j = 0; j < Math.min(maxLevel, levelNames.length); j++) {
          String imagePath = "data/" + artName + "/" + (j + 1) + ".png";
          PImage img = loadImage(imagePath);
          levels[j] = new ArtLevel(img, levelNames[j].trim());
        }
        
        Art art = new Art(artName, levels);
        artMap.put(artName, art);
      }
    }
    
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty()) continue;
      
      String[] parts = line.split(",");
      if (parts.length >= 4 && !parts[3].trim().isEmpty()) {
        String artName = parts[0].trim();
        String[] prerequisiteNames = parts[3].trim().split(";");
        String[] effectTexts = new String[0];
        
        if (parts.length >= 5 && !parts[4].trim().isEmpty()) {
          effectTexts = parts[4].trim().split(";");
        }
        
        Art targetArt = artMap.get(artName);
        if (targetArt != null) {
          Art[] prerequisites = new Art[prerequisiteNames.length];
          String[] texts = new String[prerequisiteNames.length];
          
          for (int j = 0; j < prerequisiteNames.length; j++) {
            prerequisites[j] = artMap.get(prerequisiteNames[j].trim());
            if (j < effectTexts.length) {
              texts[j] = effectTexts[j].trim();
            } else {
              texts[j] = prerequisiteNames[j].trim() + " 启发了 " + artName;
            }
          }
          
          targetArt.effects = prerequisites;
          targetArt.effectText = texts;
        }
      }
    }
  }

  Art getArt(String name) {
    return artMap.get(name);
  }

  Art[] getAllArts() {
    return artMap.values().toArray(new Art[0]);
  }
}
