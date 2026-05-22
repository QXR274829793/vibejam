import java.util.HashMap;

class ArtLoader {
  HashMap<String, Art> artMap;

  ArtLoader() {
    artMap = new HashMap<String, Art>();
  }

  void addArt(Art art) {
    artMap.put(art.name, art);
  }

  Art getArt(String name) {
    return artMap.get(name);
  }

  void loadEffectsFromCSV(String filePath) {
    String[] lines = loadStrings(filePath);
    
    for (int i = 1; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty()) continue;
      
      String[] parts = line.split(",");
      if (parts.length >= 3) {
        String artName = parts[0].trim();
        String effectName = parts[1].trim();
        String effectText = parts[2].trim();
        
        Art art = artMap.get(artName);
        Art effectArt = artMap.get(effectName);
        
        if (art != null && effectArt != null) {
          Art[] currentEffects = art.effects;
          String[] currentTexts = art.effectText;
          
          Art[] newEffects = new Art[currentEffects.length + 1];
          String[] newTexts = new String[currentTexts.length + 1];
          
          for (int j = 0; j < currentEffects.length; j++) {
            newEffects[j] = currentEffects[j];
            newTexts[j] = currentTexts[j];
          }
          
          newEffects[currentEffects.length] = effectArt;
          newTexts[currentTexts.length] = effectText;
          
          art.effects = newEffects;
          art.effectText = newTexts;
        }
      }
    }
  }

  Art[] getAllArts() {
    return artMap.values().toArray(new Art[0]);
  }
}
