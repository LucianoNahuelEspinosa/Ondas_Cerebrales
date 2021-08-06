import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;
String serialPort = "COM4"; //Puerto Saliente

int atencion, meditacion;
int delta, theta, lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, midGamma;

void setup() {
  size(800, 600);
  mindSet = new MindSet(this, serialPort);
}

void draw() {
  background(255);

  pushStyle();
  textSize(20);
  fill(0);
  text("Nivel de Atencion: " + atencion, 50, 50);
  text("Nivel de Meditacion: " + meditacion, 50, 100);
  text("Delta: " + delta, 50, 150);
  text("Theta: " + theta, 50, 200);
  text("Low Alpha: " + lowAlpha, 50, 250);
  text("High Alpha: " + highAlpha, 50, 300);
  text("Low Beta: " + lowBeta, 50, 350);
  text("High Beta: " + highBeta, 50, 400);
  text("Low Gamma: " + lowGamma, 50, 450);
  text("Mid Gamma: " + midGamma, 50, 500);
  popStyle();
}

public void poorSignalEvent(int sig) {
  //println(sig);
  //signalWidget.add(200-sig);
}

public void attentionEvent(int attentionLevel) {
  //attentionWidget.add(attentionLevel);
  //println("Nivel de Atencion: " + attentionLevel);
  atencion = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  //meditationWidget.add(meditationLevel);
  //println("Nivel de Meditacion: " + meditationLevel);
  meditacion = meditationLevel;
}

public void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  this.delta = delta%1000;
  this.theta = theta%1000;
  lowAlpha = low_alpha%1000;
  highAlpha = high_alpha%1000;
  lowBeta = low_beta%1000;
  highBeta = high_beta%1000;
  lowGamma = low_gamma%1000;
  midGamma = mid_gamma%1000;
}
