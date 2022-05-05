public class DomeOutput {
  private boolean enabled;
  private LXDatagramOutput theOutput;
  public void initOutput(final heronarts.lx.studio.LXStudio lx) {
    try {
      theOutput = new LXDatagram(lx);
      LXDatagram dg = new DomeDatagram();
      try {
        theOutput.addDatagram(dg.setAddress("192.168.0.201").setPort(1337));
      } catch (Exception e) {
        println(e);
      }
      theOutput.enabled.setValue(enabled);
      lx.engine.output.addChild(theOutput);
    } catch (java.net.SocketException e) {
      println(e);
    }
  }

  public void initUI(final LXStudio.UI ui) {
    new UIOutputControls(ui, this).setExpanded(true).addToContainer(ui.leftPane.global);
  }

  private void setEnabled(boolean e) {
    enabled = e;
    theOutput.enabled.setValue(e);
  }
}

public class UIOutputControls extends UICollapsibleSection {
  public UIOutputControls(final LXStudio.UI ui, final DomeOutput domeOutput) {
    super(ui, 0, 0, ui.leftPane.global.getContentWidth(), 200);
    setTitle("Output"); 
    setLayout(UI2dContainer.Layout.VERTICAL);
    setChildMargin(2);
    new UILabel(0, 0, getContentWidth(), 18).setLabel("Hello").addToContainer(this);
    new UIButton(0,0, getContentWidth(), 18) {
      public void onToggle(boolean state) {
        domeOutput.setEnabled(state);
      }
    }.setLabel("Enabled").setEnabled(true).setActive(domeOutput.enabled).addToContainer(this);
    new UITextBox(0, 0, getContentWidth(), 18).setValue("Test").addToContainer(this);
  }
}

public class DomeDatagram extends LXDatagram  {
  public DomeDatagram() {
    super(300*3);
  }
  public void onSend(int[] colors) {
    for(int i=0; i<min(colors.length, this.buffer.length/3); i++) { //TODO: be more smart
      this.buffer[i*3] = (byte) (0xff & (colors[i]>>16));
      this.buffer[(i*3)+1] = (byte) (0xff & (colors[i]>>8));
      this.buffer[(i*3)+2] = (byte) (0xff & (colors[i]));
    }
  }
}
