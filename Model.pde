LXModel buildModel(JSONArray points) {
  return new DomeModel(points);
}

// Currently this takes a JSON array of 3-float-array points [[x1,y1,z1], [x2,y2,z2], ...]
// multiplies all points by a SCALE factor and adds them all to the UI
// TODO: replace this with an actual parametric dome algorithm
public static class DomeModel extends LXModel {

  public final static int SCALE = 20;

  public DomeModel(JSONArray points) {
    super(new DomeFixture(points));
  }
  public static class DomeFixture extends LXAbstractFixture {
  DomeFixture(JSONArray points) {
    for (int i =0; i < points.size(); i++) {
      JSONArray point = points.getJSONArray(i);
      addPoint(new LXPoint(point.getFloat(0)*SCALE, point.getFloat(1)*SCALE, point.getFloat(2)*SCALE));
    }
  }
}