public class DomeOutput {
  private boolean enabled;
  private ArrayList<LXDatagramOutput> outputs = new ArrayList<LXDatagramOutput>();
  public void initOutput(final heronarts.lx.studio.LXStudio lx) {
    JSONObject domeConf = applet.loadJSONObject("dome.json");

    JSONArray jsonSegments = domeConf.getJSONArray("segments");
    for (int segmentIndex = 0; segmentIndex < jsonSegments.size(); segmentIndex++) {
      JSONObject jsonSegment = jsonSegments.getJSONObject(segmentIndex);
      JSONArray jsonPaths = jsonSegment.getJSONArray("paths");
      int numleds = 0;
      for (int pathIndex = 0; pathIndex < jsonPaths.size(); pathIndex++) {
        JSONObject jsonPath = jsonPaths.getJSONObject(pathIndex);
        JSONArray jsonStruts = jsonPath.getJSONArray("struts");
        for (int strutIndex = 0; strutIndex < jsonStruts.size(); strutIndex++) {
          JSONObject strutconf = jsonStruts.getJSONObject(strutIndex);
          JSONArray leds = strutconf.getJSONArray("leds");
          numleds += leds.size();
        }
      }

      try {
        LXDatagramOutput segmentOutput = new LXDatagramOutput(lx);
        LXDatagram dg = new DomeDatagram(numleds, (byte)segmentIndex);
        try {
         segmentOutput.addDatagram(dg.setAddress("127.0.0.0").setPort(1337));
        } catch (java.net.UnknownHostException e) {
          println(e);
        }
        segmentOutput.enabled.setValue(enabled);
        lx.engine.output.addChild(segmentOutput);
        this.outputs.add(segmentOutput);
      } catch (java.net.SocketException e) {
        println(e);
      }
    }
    
    JSONArray jsonUplights = domeConf.getJSONArray("uplights");
    try {
      LXDatagramOutput uplightOutput = new LXDatagramOutput(lx);
      LXDatagram dg = new UplightDatagram(jsonUplights.size());
      try {
        uplightOutput.addDatagram(dg.setAddress("127.0.0.0").setPort(1338));
      } catch (java.net.UnknownHostException e) {
        println(e);
      }
      uplightOutput.enabled.setValue(enabled);
      lx.engine.output.addChild(uplightOutput);
      this.outputs.add(uplightOutput);
    } catch (Exception e) {
      println(e);
    }
  }

  public void initUI(final LXStudio.UI ui) {
    new UIOutputControls(ui, this).setExpanded(true).addToContainer(ui.leftPane.global);
  }

  private void setEnabled(boolean e) {
    this.enabled = e;
    for (LXDatagramOutput output : this.outputs) {
      output.enabled.setValue(e);
    }
  }
}

public class UIOutputControls extends UICollapsibleSection {
  public UIOutputControls(final LXStudio.UI ui, final DomeOutput domeOutput) {
    super(ui, 0, 0, ui.leftPane.global.getContentWidth(), 200);
    setTitle("Dome Output"); 
    setLayout(UI2dContainer.Layout.VERTICAL);
    setChildMargin(2);
    new UIButton(0,0, getContentWidth(), 18) {
      public void onToggle(boolean state) {
        domeOutput.setEnabled(state);
      }
    }.setLabel("Enabled").setEnabled(true).setActive(domeOutput.enabled).addToContainer(this);
  }
}

public class DomeDatagram extends LXDatagram  {
  private byte segmentIndex;
  public DomeDatagram(int size, byte segmentIndex) {
    super(size * 3 + 1);
    
    this.segmentIndex = segmentIndex;
  }
  public void onSend(int[] colors) {
    this.buffer[0] = this.segmentIndex;

    for(int i=0; i<min(colors.length, this.buffer.length / 3); i++) {
      this.buffer[1 + (i*3)] = (byte) (0xff & (colors[(this.segmentIndex * 2092) + i]>>16));
      this.buffer[1 + ((i*3)+1)] = (byte) (0xff & (colors[(this.segmentIndex * 2092) + i]>>8));
      this.buffer[1 + ((i*3)+2)] = (byte) (0xff & (colors[(this.segmentIndex * 2092) + i]));
    }
  }
}

public class UplightDatagram extends LXDatagram  {
  public UplightDatagram(int size) {
    super(size * 3);
  }
  public void onSend(int[] colors) {
    for(int i=0; i<min(colors.length, this.buffer.length / 3); i++) {
      this.buffer[i*3] = (byte) (0xff & (colors[(5 * 2092) + i]>>16));
      this.buffer[(i*3)+1] = (byte) (0xff & (colors[(5 * 2092) + i]>>8));
      this.buffer[(i*3)+2] = (byte) (0xff & (colors[(5 * 2092) + i]));
    }
  }
}
