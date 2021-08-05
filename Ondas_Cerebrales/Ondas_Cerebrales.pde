import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;
String serialPort = "COM3";

void setup() {
  size(800, 600);
  mindSet = new MindSet(this, serialPort);
}

void draw() {
  background(255);
   
 
}

public void poorSignalEvent(int sig) {
  //println(sig);
  //signalWidget.add(200-sig);
}

public void attentionEvent(int attentionLevel) {
  //attentionWidget.add(attentionLevel);
}


public void meditationEvent(int meditationLevel) {
  //meditationWidget.add(meditationLevel);
}

public void eegEvent(int delta, int theta, int low_alpha, 
int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  println(delta%1000);
  /*thetaWidget.add(theta);
  lowAlphaWidget.add(low_alpha);
  highAlphaWidget.add(high_alpha);
  lowBetaWidget.add(low_beta);
  highBetaWidget.add(high_beta);
  lowGammaWidget.add(low_gamma);
  midGammaWidget.add(mid_gamma);*/
}
