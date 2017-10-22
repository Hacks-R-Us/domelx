/**
 * This file has a few example patterns, each illustrating the key
 * concepts and tools of the LX framework.
 */

// Very simple pattern, just has one parameter and one LFO
public class SimpleStripe extends LXPattern {
  
  public final CompoundParameter period = (CompoundParameter)
    new CompoundParameter("Period", 1000, 500, 10000)
    .setExponent(2)
    .setDescription("Period of oscillation of the stripe");
    
    public final CompoundParameter size = (CompoundParameter)
    new CompoundParameter("Size", 3*CENTIMETER, 1*CENTIMETER, 10*CENTIMETER)
    .setDescription("Size of the stripe");
  
  private final LXModulator xPos = startModulator(new SinLFO(model.xMin, model.xMax, period)); 
  
  public SimpleStripe(LX lx) {
    super(lx);
    
    // Parameters automatically appear in UI and are saved in project file
    addParameter("period", this.period);
    addParameter("size", this.size);
  }
  
  public void run(double deltaMs) {
    float xPos = this.xPos.getValuef();
    float falloff = 100 / this.size.getValuef();
    for (LXPoint p : model.points) {
      // Render each point based on its distance from a moving target position in the x axis 
      colors[p.index] = palette.getColor(p, max(0, 100 - falloff * abs(p.x - xPos)));
    }
  }
}
  
// This pattern makes use of the layer construct
public class LayerDemoPattern extends LXPattern {
  
  private final CompoundParameter numStars = (CompoundParameter)
    new CompoundParameter("Stars", 100, 0, 100)
    .setDescription("Number of star layers");
  
  public LayerDemoPattern(LX lx) {
    super(lx);
    addParameter("numStars", this.numStars);
    
    // Layers are automatically rendered on every pass
    addLayer(new CircleLayer(lx));
    addLayer(new RodLayer(lx));
    for (int i = 0; i < 200; ++i) {
      addLayer(new StarLayer(lx));
    }
  }
  
  public void run(double deltaMs) {
    // Blank everything out first
    setColors(#000000);
    
    // The added layers are automatically called after our
    // run() method, no need to manually call them
  }
  
  private class CircleLayer extends LXLayer {
    
    private final SinLFO xPeriod = new SinLFO(3400, 7900, 11000); 
    
    // Note how one LFO can be a parameter to another LFO!
    private final SinLFO brightnessX = new SinLFO(model.xMin, model.xMax, xPeriod);
  
    private CircleLayer(LX lx) {
      super(lx);
      startModulator(this.xPeriod);
      startModulator(this.brightnessX);
    }
    
    public void run(double deltaMs) {
      float falloff = 100 / (4*CENTIMETER);
      float brightnessX = this.brightnessX.getValuef();
      for (LXPoint p : model.points) {
        float yWave = model.yRange/2 * sin(p.x / model.xRange * PI); 
        float distanceFromBrightness = dist(p.x, abs(p.y - model.cy), brightnessX, yWave);
        colors[p.index] = palette.getColor(p, max(0, 100 - falloff*distanceFromBrightness));
      }
    }
  }
  
  private class RodLayer extends LXLayer {
    
    private final SinLFO zPeriod = new SinLFO(2000, 5000, 9000);
    private final SinLFO zPos = new SinLFO(model.zMin, model.zMax, zPeriod);
    
    private RodLayer(LX lx) {
      super(lx);
      startModulator(this.zPeriod);
      startModulator(this.zPos);
    }
    
    public void run(double deltaMs) {
      float zPos = this.zPos.getValuef();
      for (LXPoint p : model.points) {
        float b = 100 - dist(p.x, p.y, model.cx, model.cy) - abs(p.z - zPos);
        if (b > 0) {
          addColor(p.index, palette.getColor(p, b));
        }
      }
    }
  }
  
  private class StarLayer extends LXLayer {
    
    private final TriangleLFO maxBright = new TriangleLFO(0, numStars, random(2000, 8000));
    private final SinLFO brightness = new SinLFO(-1, maxBright, random(3000, 9000)); 
    
    private int index = 0;
    
    private StarLayer(LX lx) { 
      super(lx);
      startModulator(this.maxBright);
      startModulator(this.brightness);
      pickStar();
    }
    
    private void pickStar() {
      index = (int) random(0, model.size-1);
    }
    
    public void run(double deltaMs) {
      float brightness = this.brightness.getValuef(); 
      if (brightness <= 0) {
        pickStar();
      } else {
        addColor(index, palette.getColor(model.points[index], 50, brightness));
      }
    }
  }
}