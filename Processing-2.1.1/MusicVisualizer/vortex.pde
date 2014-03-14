
class VortexRenderer extends FourierRenderer {

  int n = 48;
  float squeeze = .5;

  float val[];

  VortexRenderer(AudioSource source) {
    super(source); 
    val = new float[n];
  }

  void setup() {
    colorMode(HSB, n, n, n);
    rectMode(CORNERS);
    noStroke();
    noSmooth();    
  }

  synchronized void draw() {

    if(left != null) {  
      
      float t = map(millis(),0, 3000, 0, TWO_PI);
      float dx = width / n;
      float dy = height / n * .5;
      super.calc(n);

      // rotate slowly
      background(0); lights();
      translate(width/2, height, -width/2);
      rotateZ(HALF_PI); 
      rotateY(-2.2 - HALF_PI + float(mouseY)/height * HALF_PI);
      rotateX(t);
      translate(0,width/4,0);
      rotateX(t);

      // draw coloured slices
      for(int i=0; i < n; i++)
      {
        val[i] = lerp(val[i], pow(leftFFT[i] * (i+1), squeeze), .1);
        float x = map(i, 0, n, height, 0);
        float y = map(val[i], 0, maxFFT, 0, width/2);
        pushMatrix();
          translate(x, 0, 0);
          rotateX(PI/16 * i);
          fill(i, n * .7 + i * .3, n-i);
          box(dy, dx + y, dx + y);
        popMatrix();
      }
    }
  }
}


