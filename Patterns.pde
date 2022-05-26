// In this file you can define your own custom patterns

// Here is a fairly basic example pattern that renders a plane that can be moved
// across one of the axes.
@LXCategory("Form")
public static class PlanePattern extends LXPattern {
  
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis =
    new EnumParameter<Axis>("Axis", Axis.X)
    .setDescription("Which axis the plane is drawn across");
  
  public final CompoundParameter pos = new CompoundParameter("Pos", 0, 1)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Thickness of the plane");
  
  public PlanePattern(LX lx) {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("pos", this.pos);
    addParameter("width", this.wth);
  }
  
  public void run(double deltaMs) {
    float pos = this.pos.getValuef();
    float falloff = 100 / this.wth.getValuef();
    float n = 0;
    for (LXPoint p : model.points) {
      switch (this.axis.getEnum()) {
      case X: n = p.xn; break;
      case Y: n = p.yn; break;
      case Z: n = p.zn; break;
      }
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*abs(n - pos))); 
    }
  }
}

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
}

@LXCategory("Form")
public static class SparklePattern extends LXPattern {

  public final CompoundParameter chance = new CompoundParameter("Chance", 0.01)
    .setDescription("The probability any pixel is lit on each run.");
  //public final DiscreteParameter number = new DiscreteParameter("Number", 128)
  //  .setDescription("The number of simultaneous points");

  public SparklePattern(LX lx) {
    super(lx);
    addParameter("chance", this.chance);
    //addParameter("number", this.number);
  }

  public void run(double deltaMs) {
      // for(int i=0; i<this.number.getValuei(); i++) {
      //   LXPoint p = model.points[int(applet.random(model.points.length))];
      //   colors[p.index] = LXColor.gray(100);
      // }
      for (LXPoint p : model.points) {
        colors[p.index] = applet.random(1) < this.chance.getValuef()/10 ? LXColor.gray(100) : LXColor.gray(0);
      }
  }
}

@LXCategory("Form")
public static class FirePattern extends LXPattern {
  double timeSinceChange = 0;
  int previous_red[];
  int previous_green[];
  int previous_blue[];
  int target_red[];
  int target_green[];
  int target_blue[];
  
  public final CompoundParameter height = new CompoundParameter("Height", 1, 100)
    .setDescription("The height of the fire");
    
  public final CompoundParameter heightModulation = new CompoundParameter("HeightModulation", 1, 100)
    .setDescription("Modulation of fire height");
    
  public final CompoundParameter targetCrackle = new CompoundParameter("Target Crackle", 1, 100)
    .setDescription("The crackle of the fire");
    
  public final CompoundParameter timeOffset = new CompoundParameter("Time Offset", 10, 100)
  .setDescription("\"Speed\" of the fire");
    
  public FirePattern(LX lx) {
    super(lx);
    addParameter("height", this.height);
    addParameter("modulation", this.heightModulation);
    addParameter("crackle", this.targetCrackle);
    addParameter("offset", this.timeOffset);
    
    timeOffset.setValue(10);
    
    previous_red = new int[colors.length];
    target_red = new int[colors.length];
    previous_green = new int[colors.length];
    target_green = new int[colors.length];
    previous_blue = new int[colors.length];
    target_blue = new int[colors.length];
    
    for (LXPoint p : model.points){
      previous_red[p.index] = 0;
      previous_green[p.index] = 0;
      previous_blue[p.index] = 0;
      target_red[p.index] = 0;
      target_green[p.index] = 0;
      target_blue[p.index] = 0;
    }
  }
  
  public void run(double deltaMs){
    timeSinceChange += deltaMs;
    
    if(timeSinceChange >= timeOffset.getValue() * 10){
      // If enough time has passed
      // Instant modulation reduces the height of the fire in the current frame
      int instantModulation = (int)(heightModulation.getValue() * applet.random(1));
      
      // Instatnt target height is the height of the fire this frame
      int instantTargetHeight = (int)(height.getValue() - applet.random(10)) - instantModulation;
      
      for (LXPoint p : model.points){
        if(p.z <= instantTargetHeight){
          //colors[p.index] = LXColor.lerp(LXColor.rgb(200, 0, 0), colors[p.index]);
          target_red[p.index] = 200;
          target_green[p.index] = (int)map(p.z, 0, instantTargetHeight, 0, 150);
          target_blue[p.index] = (int)map(p.z, 0, instantTargetHeight, 0, 30);
        }else if(p.z > instantTargetHeight && p.z <= instantTargetHeight + (applet.random(1) * targetCrackle.getValue() * 5)){
          target_red[p.index] = 200;
          target_green[p.index] = 150;
          target_blue[p.index] = 30;
        }else{
          target_red[p.index] = 0;
          target_green[p.index] = 0;
          target_blue[p.index] = 0;
        }
      }
      
      timeSinceChange = 0;
    }
    
    for (LXPoint p : model.points){
      int red = target_red[p.index];
      int green = target_green[p.index];
      int blue = target_blue[p.index];
      
      colors[p.index] = LXColor.rgb(red, green, blue);
    }
  }
}

@LXCategory("Form")
public static class ProbablyTooFlashyPattern extends LXPattern {
  double timeSinceChange = 0;
  int previous_red[];
  int previous_green[];
  int previous_blue[];
  int target_red[];
  int target_green[];
  int target_blue[];
  
  public final CompoundParameter height = new CompoundParameter("Height", 1, 100)
    .setDescription("The height of the pattern");
    
  public final CompoundParameter heightModulation = new CompoundParameter("HeightModulation", 1, 100)
    .setDescription("Modulation of pattern height");
    
  public final CompoundParameter targetCrackle = new CompoundParameter("Target Crackle", 1, 100)
    .setDescription("The crackle of the pattern");
    
  public final CompoundParameter timeOffset = new CompoundParameter("Time Offset", 10, 100)
  .setDescription("\"Speed\" of the pattern");
    
  public ProbablyTooFlashyPattern(LX lx) {
    super(lx);
    addParameter("height", this.height);
    addParameter("modulation", this.heightModulation);
    addParameter("crackle", this.targetCrackle);
    addParameter("offset", this.timeOffset);
    
    timeOffset.setValue(10);
    
    previous_red = new int[colors.length];
    target_red = new int[colors.length];
    previous_green = new int[colors.length];
    target_green = new int[colors.length];
    previous_blue = new int[colors.length];
    target_blue = new int[colors.length];
    
    for (LXPoint p : model.points){
      previous_red[p.index] = 0;
      previous_green[p.index] = 0;
      previous_blue[p.index] = 0;
      target_red[p.index] = 0;
      target_green[p.index] = 0;
      target_blue[p.index] = 0;
    }
  }
  
  public void run(double deltaMs){
    timeSinceChange += deltaMs;
    
    if(timeSinceChange >= timeOffset.getValue() * 10){
      // If enough time has passed
      // Instant modulation reduces the height of the fire in the current frame
      int instantModulation = (int)(heightModulation.getValue() * applet.random(1));
      
      // Instatnt target height is the height of the fire this frame
      int instantTargetHeight = (int)(height.getValue() - applet.random(10)) - instantModulation;
      
      for (LXPoint p : model.points){
        if(p.z <= instantTargetHeight){
          //colors[p.index] = LXColor.lerp(LXColor.rgb(200, 0, 0), colors[p.index]);
          target_red[p.index] = 200;
          target_green[p.index] = (int)map(p.z, 0, instantTargetHeight, 0, 150);
          target_blue[p.index] = (int)map(p.z, 0, instantTargetHeight, 0, 30);
        }else if(p.z > instantTargetHeight && p.z <= instantTargetHeight + (applet.random(1) * targetCrackle.getValue() * 5)){
          target_red[p.index] = 200;
          target_green[p.index] = 150;
          target_blue[p.index] = 30;
        }else{
          target_red[p.index] = 0;
          target_green[p.index] = 0;
          target_blue[p.index] = 0;
        }
      }
      
      timeSinceChange = 0;
    }
    
    for (LXPoint p : model.points){
      int red = (int)map((float)timeSinceChange, 0, (float)timeOffset.getValue(), (float)previous_red[p.index], (float)target_red[p.index]);
      int green = (int)map((float)timeSinceChange, 0, (float)timeOffset.getValue(), (float)previous_green[p.index], (float)target_green[p.index]);
      int blue = (int)map((float)timeSinceChange, 0, (float)timeOffset.getValue(), (float)previous_blue[p.index], (float)target_blue[p.index]);
      
      colors[p.index] = LXColor.rgb(red, green, blue);
    }
  }
}

@LXCategory("Form")
public static class BeaconPattern extends LXPattern {
  int timeSinceChange = 0;
  int previous_red = 0;
  int target_red = 0;
  
  public enum Axis {
    X, Y, Z
  };
  
  public final CompoundParameter time = new CompoundParameter("Time", 1, 100)
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
  }
}
