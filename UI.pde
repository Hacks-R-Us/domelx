/**
 * Example of a custom 3d UI component. This draws a box around
 * our custom matrix model.
 */
public class UIWalls extends UI3dComponent {
  
  private final float WALL_MARGIN = 2*CENTIMETER;
  private final float WALL_SIZE = model.xRange + 2*WALL_MARGIN;
  private final float WALL_THICKNESS = 1*CENTIMETER;
  
  @Override
  protected void beginDraw(UI ui, PGraphics pg) {
    //pg.pointLight(100, 100, 100, model.cx, model.cy, 0);
  }
  
  @Override
  protected void onDraw(UI ui, PGraphics pg) {
    /*pg.fill(#ffffff);
    pg.stroke(#000000);
    pg.pushMatrix();
    pg.translate(model.cx, model.cy, model.zMax + WALL_MARGIN);
    pg.box(WALL_SIZE, WALL_SIZE, WALL_THICKNESS);
    pg.translate(-model.xRange/2 - WALL_MARGIN, 0, -model.zRange/2 - WALL_MARGIN);
    pg.box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    pg.translate(model.xRange + 2*WALL_MARGIN, 0, 0);
    pg.box(WALL_THICKNESS, WALL_SIZE, WALL_SIZE);
    pg.translate(-model.xRange/2 - WALL_MARGIN, model.yRange/2 + WALL_MARGIN, 0);
    pg.box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    pg.translate(0, -model.yRange - 2*WALL_MARGIN, 0);
    pg.box(WALL_SIZE, WALL_THICKNESS, WALL_SIZE);
    pg.popMatrix();*/
  }
  
  @Override
  protected void endDraw(UI ui, PGraphics pg) {
    //pg.noLights();
  }
}

public class UIOutputControls extends UICollapsibleSection {
  public UIOutputControls(final LXStudio.UI ui) {
    super(ui, 0, 0, ui.leftPane.global.getContentWidth(), 200);
    setTitle("Output"); 
    setLayout(UI2dContainer.Layout.VERTICAL);
    setChildMargin(2);
    new UILabel(0, 0, getContentWidth(), 18).setLabel("Hello").addToContainer(this);
    new UIButton(0,0, getContentWidth(), 18).setLabel("Enabled").setEnabled(true).addToContainer(this);
    new UITextBox(0, 0, getContentWidth(), 18).setValue("Test").addToContainer(this);
  }
}