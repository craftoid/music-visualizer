
// the code for the isometric renderer was deliberately taken from Jared C.'s wavy sketch 
// ( http://www.openprocessing.org/visuals/?visualID=5671 )

class IsometricRenderer extends FourierRenderer {

  int r = 7;
  float squeeze = .5;

  float a, d;
  float val[];
  int n;
  PGraphics pg;

  IsometricRenderer(AudioSource source) {
    super(source);
    n = ceil(sqrt(2) * r);
    d = min(width, height) / r / 5;
    val = new float[n];
    reset();
  }

  void setup() { 
    reset();
  } 

  void reset() {
    
    // Offscreen P2D renderer (fastest)
    pg = createGraphics(width, height, P2D);
    
    // Alternatively use Java2D (sharper)
    // pg = createGraphics(width, height, JAVA2D);
    
  }

  void draw() {

    if (left != null) {

      pg.beginDraw();
      pg.colorMode(RGB, 6, 6, 6); 
      pg.stroke(0);
      //pg.noSmooth();
      super.calc(n);

      // actual values react with a delay
      for (int i=0; i<n; i++) val[i] = lerp(val[i], pow(leftFFT[i], squeeze), .1);

      a -= 0.08; 
      pg.background(6);  
      for (int x = -r; x <= r; x++) { 
        for (int z = -r; z <= r; z++) { 
          int y = int( height/3 * val[(int) dist(x, z, 0, 0)]); 

          float xm = x*d - d/2; 
          float xt = x*d + d/2; 
          float zm = z*d - d/2; 
          float zt = z*d + d/2; 

          int w0 = (int) width/2; 
          int h0 = (int) height * 2/3; 

          int isox1 = int(xm - zm + w0); 
          int isoy1 = int((xm + zm) * 0.5 + h0); 
          int isox2 = int(xm - zt + w0); 
          int isoy2 = int((xm + zt) * 0.5 + h0); 
          int isox3 = int(xt - zt + w0); 
          int isoy3 = int((xt + zt) * 0.5 + h0); 
          int isox4 = int(xt - zm + w0); 
          int isoy4 = int((xt + zm) * 0.5 + h0); 

          // pg.hint(DISABLE_DEPTH_TEST);
          pg.fill (2); 
          pg.quad(isox2, isoy2-y, isox3, isoy3-y, isox3, isoy3+d, isox2, isoy2+d); 
          pg.fill (4); 
          pg.quad(isox3, isoy3-y, isox4, isoy4-y, isox4, isoy4+d, isox3, isoy3+d); 

          pg.fill(4 + y / 2.0 / d); 
          pg.quad(isox1, isoy1-y, isox2, isoy2-y, isox3, isoy3-y, isox4, isoy4-y); 
          // pg.hint(ENABLE_DEPTH_TEST);
        }
      }
    }
    pg.endDraw();
    image(pg, 0, 0);
  }
}

