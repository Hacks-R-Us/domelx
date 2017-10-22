/**
 * LXStudio demo. This is a simple project which gets the LX harness
 * up and running. Copy this off or fork it for your own project!
 */

// Let's work in sensible units
final static float CENTIMETER = 1;
final static float METER = 100*CENTIMETER;

// Top-level, we have a model and an LXStudio instance
Model model;
LXStudio lx;

UIOutputControls uiOutputControls;

// Setup establishes the windowing and LX constructs
void setup() {
  size(1280, 960, P3D);
  
  // Create the model, which describes where our light points are
  model = new Model();
  
  // Create the P3LX engine
  lx = new LXStudio(this, model)  {
    @Override
    protected void initialize(LXStudio lx, LXStudio.UI ui) {
      // Add custom LXComponents or LXOutput objects to the engine here,
      // before the UI is constructed
      OPCOutput opcoutput = new OPCOutput(lx, "192.168.0.10", 7890, model.fixtures.get(0));
      lx.engine.output.addChild(opcoutput);
    }
    
    @Override
    protected void onUIReady(LXStudio lx, LXStudio.UI ui) {
      // The UI is now ready, can add custom UI components if desired
      ui.preview.addComponent(new UIWalls());
      uiOutputControls = (UIOutputControls) new UIOutputControls(ui).setExpanded(false).addToContainer(ui.leftPane.global);
    }
  };

}

void draw() {
  // Empty placeholder... LX handles everything for us!
}