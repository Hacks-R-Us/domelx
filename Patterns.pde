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
  
  public final CompoundParameter height = new CompoundParameter("Height", 1, 100)
    .setDescription("The height of the fire");
    
  public final CompoundParameter heightModulation = new CompoundParameter("HeightModulation", 1, 100)
    .setDescription("Modulation of fire height");
    
  public final CompoundParameter targetCrackle = new CompoundParameter("Target Crackle", 1, 100)
    .setDescription("The crackle of the fire");
    
  public final CompoundParameter timeOffset = new CompoundParameter("Time Offset", 1, 100)
  .setDescription("\"Speed\" of the fire");
    
  public FirePattern(LX lx) {
    super(lx);
    addParameter("height", this.height);
    addParameter("modulation", this.heightModulation);
    addParameter("crackle", this.targetCrackle);
    addParameter("offset", this.timeOffset);
  }
  
  public void run(double deltaMs){
    timeSinceChange += deltaMs;
    
    // If enough time has passed
    if(timeSinceChange >= timeOffset.getValue() * 10){
      // Instant modulation reduces the height of the fire in the current frame
      int instantModulation = (int)(heightModulation.getValue() * applet.random(1));
      
      // Instatnt target height is the height of the fire this frame
      int instantTargetHeight = (int)(height.getValue() - applet.random(10)) - instantModulation;
      
      for (LXPoint p : model.points){
        if(p.z <= instantTargetHeight){
          //colors[p.index] = LXColor.lerp(LXColor.rgb(200, 0, 0), colors[p.index]);
          int green = (int)map(p.z, 0, instantTargetHeight, 0, 150);
          int blue = (int)map(p.z, 0, instantTargetHeight, 0, 30);
          colors[p.index] = LXColor.rgb(200, green, blue);
        }else if(p.z > instantTargetHeight && p.z <= instantTargetHeight + (applet.random(1) * targetCrackle.getValue() * 5)){
          colors[p.index] = LXColor.rgb(200, 150, 30);
        }else{
          colors[p.index] = LXColor.rgb(0, 0, 0);
        }
      }
      
      timeSinceChange = 0;
    }
  }
}
