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
public static class BeaconPattern extends LXPattern {
  int previous_red = 0;
  int timeSinceChange = 0;
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
    }else{
      target_red = temp;
        int red = (int)map((float)timeSinceChange, 0, (float)time.getValue() * 100, (float)previous_red, (float)target_red);
      for (LXPoint p : model.points){
        colors[p.index] = LXColor.rgb(red, 0, 0);
      }
    }
  }
}
