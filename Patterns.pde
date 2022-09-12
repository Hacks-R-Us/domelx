public static class DomePattern extends LXPattern {
  public final static int PATHS_IN_SEGMENT = 5;
  public final static int STRUTS_IN_PATH = 10;
  
  public DomePattern(LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {}
  
  public List<LXFixture> GetStrutsInSegment(int segmentIndex) {
    return this.model.fixtures.subList(segmentIndex * PATHS_IN_SEGMENT * STRUTS_IN_PATH, (segmentIndex + 1) * PATHS_IN_SEGMENT * STRUTS_IN_PATH);
  }

  public List<LXFixture> GetStrutsInPath(int segmentIndex, int pathIndex) {
    return this.model.fixtures.subList((segmentIndex * PATHS_IN_SEGMENT * STRUTS_IN_PATH) + (pathIndex * STRUTS_IN_PATH), (segmentIndex * PATHS_IN_SEGMENT * STRUTS_IN_PATH) + ((pathIndex + 1) * STRUTS_IN_PATH));
  }
  
  public List<LXFixture> GetUplights() {
    return this.model.fixtures.subList((5 * PATHS_IN_SEGMENT * STRUTS_IN_PATH), this.model.fixtures.size());
  }
}

public static class RGBPattern extends LXPattern {
  public RGBPattern (LX lx) {
    super(lx);
  }
  
  public void run(double deltaMs) {
    
  }
}

@LXCategory("Form")
public static class SparklePattern extends LXPattern {
  
  private double timeSinceStep = 0;
  private byte[][] steps = {
    
  };

  public final CompoundParameter chance = new CompoundParameter("Chance", 0.01)
    .setDescription("The probability any pixel is lit on each run.");

  public SparklePattern(LX lx) {
    super(lx);
    addParameter("chance", this.chance);
  }

  public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        colors[p.index] = applet.random(1) < this.chance.getValuef()/10 ? LXColor.gray(100) : LXColor.gray(0);
      }
  }
}

@LXCategory("Form")
public static class StrutVisualizerPattern extends DomePattern {
  public final CompoundParameter audioLevel = new CompoundParameter("Audio Level", model.yMin - 0.1, model.yMin - 0.1, model.yMax);
  public final CompoundParameter clipHigh = new CompoundParameter("Clip High", model.yMax, model.yMin - 0.1, model.yMax);
  public final CompoundParameter clipLow = new CompoundParameter("Clip Low", model.yMin - 0.1, model.yMin - 0.1, model.yMax);
  public final CompoundParameter uplightThreshold = new CompoundParameter("Uplight Threshold", 0.0, 0.0, 1.0);
  
  private int[] previousValues = new int[model.points.length];
  private double[] timeSinceFade = new double[model.points.length];

  private static final int baseColor = LXColor.rgb(255, 255, 255);
  private static final int uplightStartIndex = 5 * 2092;

  public StrutVisualizerPattern(LX lx) {
    super(lx);
    addParameter("audioLevel", this.audioLevel);
    addParameter("clipHigh", this.clipHigh);
    addParameter("clipLow", this.clipLow);
    addParameter("uplightThreshold", this.uplightThreshold);
  }

  public void run(double deltaMs) {
    float currentValue = (float)this.audioLevel.getValue();
    float cHigh = (float)this.clipHigh.getValue();
    float cLow = (float)this.clipLow.getValue();
    float targetY = map(currentValue, min(cLow, currentValue), max(cHigh, currentValue), model.yMin - 0.1, model.yMax);
  
    for (int segmentIndex = 0; segmentIndex < 5; segmentIndex++) {
      for (int pathIndex = 0; pathIndex < 5; pathIndex++) {
        for (LXFixture strut : this.GetStrutsInPath(segmentIndex, pathIndex)) {
          for (LXPoint p : strut.getPoints()) {
            if (p.y <= targetY) {
              this.timeSinceFade[p.index] = 0;
              previousValues[p.index] = StrutVisualizerPattern.baseColor;
              colors[p.index] = StrutVisualizerPattern.baseColor;
            } else {
              this.timeSinceFade[p.index] += deltaMs;
              float totalFadeTime = (1 - (p.y / model.yMax)) * 2000;
              float fadePosition = (min(totalFadeTime, (float)this.timeSinceFade[p.index])) / totalFadeTime;
              if (fadePosition > 0.95) {
                this.timeSinceFade[p.index] = 0;
                previousValues[p.index] = 0;
                colors[p.index] = 0;
              } else {
                int prev = LXColor.scaleBrightness(previousValues[p.index], 1 - fadePosition);
                colors[p.index] = prev;
              }
            }
          }
        }
      }
    }
    
    float fadeAmount = map(targetY, model.yMin - 0.1, model.yMax, 0.0, 1.0);
    float threshold = (float)this.uplightThreshold.getValue();
    for (int uplightIndex = 0; uplightIndex < 5; uplightIndex++) {
      int index = this.uplightStartIndex + uplightIndex;
      if (fadeAmount > threshold) {
        this.timeSinceFade[index] = 0;
        previousValues[index] = StrutVisualizerPattern.baseColor;
      } else {
        this.timeSinceFade[index] += deltaMs;
        float totalFadeTime = 2000;
        float fadePosition = (min(totalFadeTime, (float)this.timeSinceFade[index])) / totalFadeTime;
        if (fadePosition > 0.95) {
          this.timeSinceFade[index] = 0;
          previousValues[index] = 0;
          colors[index] = 0;
        } else {
          int prev = LXColor.scaleBrightness(previousValues[index], 1 - fadePosition);
          colors[index] = prev;
        }
      }
    }
  }
}

@LXCategory("Form")
public static class BeaconPattern extends LXPattern {
  int timeSinceChange = 0;
  int previous_red = 0;
  int target_red = 0;

  public final CompoundParameter time = new CompoundParameter("Time", 50, 100)
    .setDescription("The flash rate");
  
  public BeaconPattern(LX lx) {
    super(lx);
    addParameter("time", this.time);
    target_red = 200;
  }
  
  public void run(double deltaMs) {
    timeSinceChange += deltaMs;
    
    if(timeSinceChange >= time.getValue() * 100){
      timeSinceChange = 0;
      
      for (LXPoint p : model.points){
        colors[p.index] = LXColor.rgb(target_red, 0, 0);
      }
      
      int temp = previous_red;
      previous_red = target_red;
      target_red = temp;
    }else{
      for (LXPoint p : model.points){
        int red = (int)map((float)timeSinceChange, 0, (float)time.getValue() * 100, (float)previous_red, (float)target_red);
        colors[p.index] = LXColor.rgb(red, 0, 0);
      }
    }
  }
}

@LXCategory("Form")
public static class StrutSparklePattern extends LXPattern {

  public final CompoundParameter chance = new CompoundParameter("Chance", 0.01)
    .setDescription("The probability any strut is lit on each run.");
  public final CompoundParameter time = new CompoundParameter("Time", 0.5, 60)
    .setDescription("Time between new states (seconds)");

  private int[] lastColors;
  private int[] targetColors;
  private int timeSinceChange = 0;

  public StrutSparklePattern(LX lx) {
    super(lx);
    addParameter("chance", this.chance);
    addParameter("time", this.time);

    this.lastColors = new int[colors.length];
    this.targetColors = new int[colors.length];
  }

  public void run(double deltaMs) {
      this.timeSinceChange += deltaMs;
      if (this.timeSinceChange >= this.time.getValue() * 1000) {
        this.lastColors = this.colors.clone();
        for (LXFixture s : model.fixtures) {
          int c = applet.random(1) < this.chance.getValuef() ? LXColor.gray(100) : LXColor.gray(0);
          setColor(s, c);
        }
        this.timeSinceChange = 0;
      }
  }
}

@LXCategory("Form")
public static class PathTestPattern extends DomePattern {
  private static final int[] pathColors = {
    LXColor.rgb(244, 102, 102),
    LXColor.rgb(246, 178, 107),
    LXColor.rgb(255, 229, 153),
    LXColor.rgb(182, 215, 168),
    LXColor.rgb(164, 194, 244),
  };
  
  public PathTestPattern(LX lx) {
    super(lx);
  }

  public void run(double deltaMs) {
    for (int segmentIndex = 0; segmentIndex < 5; segmentIndex++) {
      for (int pathIndex = 0; pathIndex < 5; pathIndex++) {
        for (LXFixture strut : this.GetStrutsInPath(segmentIndex, pathIndex)) {
          setColor(strut, PathTestPattern.pathColors[pathIndex]);
        }
      }
    }
    
    for (LXFixture uplight : this.GetUplights()) {
      setColor(uplight, LXColor.rgb(127, 255, 212));
    }
  }
}
