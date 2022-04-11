//======================== UI ==========================
void infoMind (int tamTitle, int tamInfo, int tamAddresses, color colorFill) {
  pushStyle();
  textSize(tamTitle);
  fill(colorFill);
  textAlign(CENTER);
  text("MindWave Sensor", width/2-250, 80);
  text("Conexión OSC", width-275, 80);

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

  text("Dirección IP: " + oscIP, width/2+xItems+75, yItems-10);
  text("Puerto a enviar: " + sendPort, width/2+xItems+75, yItems-10+50);

  textSize(tamTitle);
  textAlign(CENTER);
  text("Direcciones OSC", width-275, yItems+160);

  textAlign(BASELINE);
  textSize(tamAddresses);
  for ( int i = 0; i<5; i++ ) {
    text((i+1) + ". " + direcciones[i], width/2+xItems+75, 225+yItems+60*i);
  }
  for ( int i = 5; i<direcciones.length; i++ ) {
    float m = map(i, 5, 10, 0, 5);
    text((i+1) + ". " + direcciones[i], width/2+xItems+325, 225+yItems+60*m);
  }
  popStyle();
}
//===================================================

//============= Change IP & Port OSC ================
void ChangeOSCSend() {
  if (isChangeIpPort) {
    oscIP = ipText.getText();
    sendPort = int(portText.getText());
    myRemoteLocation = new NetAddress(oscIP, sendPort);
    isChangeIpPort = false;
  }

  if (!isChangeIpPort && keyPressed) {
    if (key == ENTER) {
      isChangeIpPort = true;
    }
  }
}
//===================================================

//=========== MindWave Functions =============
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
//=============================================

//=============== GUI Event Functions ===================
public void displayEvent(String name, GEvent event) {
  String extra = " event fired at " + millis() / 1000.0 + "s";
  print(name + "   ");
  switch(event) {
  case CHANGED:
    println("CHANGED " + extra);
    break;
  case SELECTION_CHANGED:
    println("SELECTION_CHANGED " + extra);
    break;
  case LOST_FOCUS:
    println("LOST_FOCUS " + extra);
    break;
  case GETS_FOCUS:
    println("GETS_FOCUS " + extra);
    break;
  case ENTERED:
    println("ENTERED " + extra);  
    break;
  default:
    println("UNKNOWN " + extra);
  }
}

public void handleTextEvents(GEditableTextControl textControl, GEvent event) { 
  displayEvent(textControl.tag, event);
}

public void handlePasswordEvents(GPassword pwordControl, GEvent event) {
  displayEvent(pwordControl.tag, event);
}
//=======================================================
