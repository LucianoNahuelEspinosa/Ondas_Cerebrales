void infoMind (int tamTitle, int tamInfo, color colorFill) {
  pushStyle();
  textSize(tamTitle);
  fill(colorFill);
  textAlign(CENTER);
  text("MindWave Sensor", width/2-250, 75);
  text("Conexión OSC", width/2+250, 75);

  line(width/2, 0, width/2, height);

  textAlign(BASELINE);
  textSize(tamInfo);
  text("Estado conexión: " + estadoMind, xItems, yItems);

  text("Nivel de Atencion: " + atencion, xItems, yItems + 50);
  OscMessage atencionMessage = new OscMessage(direcciones[0]);
  atencionMessage.add(atencion);
  oscP5.send(atencionMessage, myRemoteLocation);

  text("Nivel de Meditacion: " + meditacion, xItems, yItems + 100);
  OscMessage meditacionMessage = new OscMessage(direcciones[1]);
  meditacionMessage.add(meditacion);
  oscP5.send(meditacionMessage, myRemoteLocation);

  text("Delta: " + delta, xItems, yItems + 150);
  OscMessage deltaMessage = new OscMessage(direcciones[2]);
  deltaMessage.add(delta);
  oscP5.send(deltaMessage, myRemoteLocation);

  text("Theta: " + theta, xItems, yItems + 200);
  OscMessage thetaMessage = new OscMessage(direcciones[3]);
  thetaMessage.add(theta);
  oscP5.send(thetaMessage, myRemoteLocation);

  text("Low Alpha: " + lowAlpha, xItems, yItems + 250);
  OscMessage lowAlphaMessage = new OscMessage(direcciones[4]);
  lowAlphaMessage.add(lowAlpha);
  oscP5.send(lowAlphaMessage, myRemoteLocation);

  text("High Alpha: " + highAlpha, xItems, yItems + 300);
  OscMessage highAlphaMessage = new OscMessage(direcciones[5]);
  highAlphaMessage.add(highAlpha);
  oscP5.send(highAlphaMessage, myRemoteLocation);

  text("Low Beta: " + lowBeta, xItems, yItems + 350);
  OscMessage lowBetaMessage = new OscMessage(direcciones[6]);
  lowBetaMessage.add(lowBeta);
  oscP5.send(lowBetaMessage, myRemoteLocation);

  text("High Beta: " + highBeta, xItems, yItems + 400);
  OscMessage highBetaMessage = new OscMessage(direcciones[7]);
  highBetaMessage.add(highBeta);
  oscP5.send(highBetaMessage, myRemoteLocation);

  text("Low Gamma: " + lowGamma, xItems, yItems + 450);
  OscMessage lowGammaMessage = new OscMessage(direcciones[8]);
  lowGammaMessage.add(lowGamma);
  oscP5.send(lowGammaMessage, myRemoteLocation);

  text("Mid Gamma: " + midGamma, xItems, yItems + 500);
  OscMessage midGammaMessage = new OscMessage(direcciones[9]);
  midGammaMessage.add(midGamma);
  oscP5.send(midGammaMessage, myRemoteLocation);

  text("Dirección IP: " + oscIP, width/2+xItems, yItems);
  text("Puerto a enviar: " + sendPort, width/2+xItems, yItems+50);
  text("Direcciones OSC:", width/2+xItems, yItems+125);
  for ( int i = 0; i<direcciones.length; i++ ) {
    text((i+1) + ". " + direcciones[i], width/2+xItems, 175+yItems+50*i);
  }
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
