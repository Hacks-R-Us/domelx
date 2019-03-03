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

  public static StrutFixture[] BuildFixtures(JSONObject domeConf) {
    ArrayList<StrutFixture> struts = new ArrayList<StrutFixture>();
    JSONArray jsonstruts = domeConf.getJSONArray("struts");
    for (int i =0; i < jsonstruts.size(); i++) {
      struts.add(new StrutFixture(jsonstruts.getJSONObject(i)));
    }
    return struts.toArray(new StrutFixture[struts.size()]);
  }

  public static class StrutFixture extends LXAbstractFixture {
    public final String type;

    StrutFixture(JSONObject strutconf) {
        this.type = strutconf.getString("type");
        JSONArray leds = strutconf.getJSONArray("leds");
        for (int i=0; i<leds.size(); i++) {
          JSONArray led = leds.getJSONArray(i);
          addPoint(new LXPoint(led.getFloat(0)*SCALE, led.getFloat(1)*SCALE, led.getFloat(2)*SCALE));
        }
    }
  }
}