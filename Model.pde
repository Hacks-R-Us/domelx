LXModel buildModel() {
  JSONObject config = applet.loadJSONObject("dome.json");
  return new DomeModel(config);
}

// Currently this takes a JSON array of 3-float-array points [[x1,y1,z1], [x2,y2,z2], ...]
// multiplies all points by a SCALE factor and adds them all to the UI
// TODO: replace this with an actual parametric dome algorithm
public static class DomeModel extends LXModel {

  public final static int SCALE = 10;

  public DomeModel(JSONObject domeConf) {
    super(DomeModel.BuildFixtures(domeConf));
  }

  public static LXModel[] BuildFixtures(JSONObject domeConf) {
    ArrayList<StrutFixture> struts = new ArrayList<StrutFixture>();
    JSONArray jsonstruts = domeConf.getJSONArray("struts");
    for (int i =0; i < jsonstruts.size(); i++) {
      JSONObject strutconf = jsonstruts.getJSONObject(i);
      String strutType = strutconf.getString("type");
      JSONArray leds = strutconf.getJSONArray("leds");
      ArrayList<LXPoint> points  = new ArrayList<LXPoint>();
      for (int j=0; j<leds.size(); j++) {
        JSONArray led = leds.getJSONArray(j);
        points.add(new LXPoint(led.getFloat(0)*SCALE, led.getFloat(1)*SCALE, led.getFloat(2)*SCALE));
      }
      struts.add(new StrutFixture(strutType, points));
    }
    return struts.toArray(new LXModel[struts.size()]);
  }

  public static class StrutFixture extends LXModel {
    public final String type;

    StrutFixture(String strutType, ArrayList<LXPoint> point) {
      super(point);
      this.type = strutType;
    }
  }
}
