/** 
 * By using LX Studio, you agree to the terms of the LX Studio Software
 * License and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 */

// ---------------------------------------------------------------------------
//
// Welcome to LX Studio! Getting started is easy...
// 
// (1) Quickly scan this file
// (2) Move on to "Patterns" to write your animations
// 
// ---------------------------------------------------------------------------

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;
DomeOutput domeOutput;
static PApplet applet;

void settings() {
  size(960, 800, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  applet = this;

  heronarts.lx.studio.LXStudio.Flags flags = new heronarts.lx.studio.LXStudio.Flags(this);
  flags.useGLPointCloud = true;
  flags.startMultiThreaded = true;
  flags.resizable = true;
  
  lx = new heronarts.lx.studio.LXStudio(this, flags, buildModel());
}

void initialize(LX lx) {
  domeOutput = new DomeOutput();
  domeOutput.initOutput(lx);
}

void initializeUI(final heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  // Modify the UI theme if you like
}

void onUIReady(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  domeOutput.initUI(ui);
}

void draw() {
  // Nothing needs to happen here, this method just needs to exist for Processing
  // to run a draw loop. You should not need to do anything here.
}

// Helpful global constants
final static float INCHES = 1;
final static float IN = INCHES;
final static float FEET = 12 * INCHES;
final static float FT = FEET;
final static float CM = IN / 2.54;
final static float MM = CM * .1;
final static float M = CM * 100;
final static float METER = M;
