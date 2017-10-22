/**
 * This is a very basic model class that is a 3-D matrix
 * of points. The model contains just one fixture with all the
 * points in the matrix.
 */
public static class Model extends LXModel {
  
  public Model() {
    super(new Fixture());
  }
  
  private static class Fixture extends LXAbstractFixture {
    
    private static final int MATRIX_SIZE = 12;
    private static final int DOME_FREQUENCY = 3;
    private static final int PIXELS_PER_STRUT = 64;
    private static final float DOME_RADIUS = 2.5*METER; 
    
    private Fixture() {
      //for (int x = 0; x < 5; x++) {
      //    addPoint(new LXPoint(
      //      DOME_RADIUS * Math.cos(2.0*Math.PI*float(x)/5.0),
      //      DOME_RADIUS * Math.sin(2.0*Math.PI*float(x)/5.0),
      //      0
      //    ));
      //}
      
      
      for (int i = 0; i<20; i++) {
        addPoint(new LXPoint(
          0,
          i*10*CENTIMETER,
          0
        ));
      }
    }
  }
}