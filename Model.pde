import java.util.List;

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

  public static DomeFixture[] BuildFixtures(JSONObject domeConf) {
    ArrayList<DomeFixture> struts = new ArrayList<DomeFixture>();
    JSONArray jsonSegments = domeConf.getJSONArray("segments");
    for (int segmentIndex = 0; segmentIndex < jsonSegments.size(); segmentIndex++) {
      JSONObject jsonSegment = jsonSegments.getJSONObject(segmentIndex);
      JSONArray jsonPaths = jsonSegment.getJSONArray("paths");
      for (int pathIndex = 0; pathIndex < jsonPaths.size(); pathIndex++) {
        JSONObject jsonPath = jsonPaths.getJSONObject(pathIndex);
        JSONArray jsonStruts = jsonPath.getJSONArray("struts");
        for (int strutIndex = 0; strutIndex < jsonStruts.size(); strutIndex++) {
          struts.add(new DomeFixture(jsonStruts.getJSONObject(strutIndex)));
        }
      }
    }
    JSONArray jsonUplights = domeConf.getJSONArray("uplights");
    for (int uplightIndex = 0; uplightIndex < jsonUplights.size(); uplightIndex++) {
      struts.add(new DomeFixture(jsonUplights.getJSONObject(uplightIndex)));
    }
    return struts.toArray(new DomeFixture[struts.size()]);
  }

  public static class DomeFixture extends LXAbstractFixture {
    DomeFixture(JSONObject strutconf) {
        JSONArray leds = strutconf.getJSONArray("leds");
        for (int i=0; i<leds.size(); i++) {
          JSONArray led = leds.getJSONArray(i);
          addPoint(new LXPoint(led.getFloat(0)*SCALE, led.getFloat(1)*SCALE, led.getFloat(2)*SCALE));
        }
    }
  }
}
