//================ Splash ================
void Splash() {
  image(splash, 0, 0);

  if (frameCount % 180 == 0) {
    isAppInit = true;
  }
}
//========================================

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
  text("Puerto Serial (Saliente): ", xItems, yItems - 35);

  pushStyle();
  fill(colorsStatus[indexColorsStatus]);
  text("Estado conexión: " + estadoMind, xItems, yItems);
  popStyle();

  for (int i = 0; i<direcciones.length; i++) {
    for (int j = 0; j<mindWaveFrequencies.length; j++) {
      OSCMessages[i] = new OscMessage(direcciones[i]);

      if (i == 0) {
        OSCMessages[i].add(attention);
      } else if (i == 1) {
        OSCMessages[i].add(meditation);
      } else {
        OSCMessages[i].add(mindWaveFrequencies[j]);
      }

      oscP5.send(OSCMessages[i], myRemoteLocation);
    }
  }

  text("Nivel de Atencion: " + attention, xItems, yItems + 50);

  text("Nivel de Meditacion: " + meditation, xItems, yItems + 100);

  text("Delta: " + mindWaveFrequencies[0], xItems, yItems + 150);
  text("Theta: " + mindWaveFrequencies[1], xItems, yItems + 200);
  text("Low Alpha: " + mindWaveFrequencies[2], xItems, yItems + 250);
  text("High Alpha: " + mindWaveFrequencies[3], xItems, yItems + 300);
  text("Low Beta: " + mindWaveFrequencies[4], xItems, yItems + 350);
  text("High Beta: " + mindWaveFrequencies[5], xItems, yItems + 400);
  text("Low Gamma: " + mindWaveFrequencies[6], xItems, yItems + 450);
  text("Mid Gamma: " + mindWaveFrequencies[7], xItems, yItems + 500);

  text("Dirección IP: ", width/2+xItems+75, yItems-30);
  text("Puerto a enviar: ", width/2+xItems+75, yItems-30+50);

  textSize(tamTitle);
  textAlign(CENTER);
  text("Direcciones OSC", width-275, yItems+160);

  textAlign(BASELINE);
  textSize(tamAddresses);
  for ( int i = 0; i<5; i++ ) {
    text((i+1) + ". " + direcciones[i], width/2+xItems+100, 225+yItems+60*i);
  }
  for ( int i = 5; i<direcciones.length; i++ ) {
    float m = map(i, 5, 10, 0, 5);
    text((i+1) + ". " + direcciones[i], width/2+xItems+340, 225+yItems+60*m);
  }
  popStyle();

  if (oscIP != ipText.getText() || sendPort != int(portText.getText())) {
    image(alert, width/2-alert.width/2, 10);
  }

  if (isAlertPort) {
    image(alertPort, width/2-alertPort.width/2, height/2-alertPort.height/2);
  }
}
//===================================================

//============= Setup GUI ================
void InitGUI() {
  ipText = new GTextField(this, width/2+xItems+175, yItems-45, 80, 20);
  ipText.tag = "IpAddress";
  ipText.setPromptText("Direccion IP");
  ipText.setText(oscIP);

  portText = new GTextField(this, width/2+xItems+200, yItems-30+35, 50, 20);
  portText.tag = "portNumber";
  portText.setPromptText("Puerto");
  portText.setText(str(sendPort));

  serialPortText = new GTextField(this, xItems+180, yItems-50, 200, 20);
  serialPortText.tag = "serialPort";
  serialPortText.setPromptText("Puerto Serial");
  serialPortText.setText(serialPort);

  serialPortBtn = new GImageButton(this, xItems+400, yItems-65, 135, 50, imgsSerialPortButton);

  isInitGUI = true;
}
//=========================================

//============= Change IP & Port OSC ================
void ChangeOSCSend() {
  if (isChangeIpPort) {
    oscIP = ipText.getText();
    sendPort = int(portText.getText());

    if (sendPort > 1 && sendPort <= 65535) {
      myRemoteLocation = new NetAddress(oscIP, sendPort);
    } else {
      isAlertPort = true;
    }

    json.setString("portSerial", serialPort);
    json.setString("ipOSC", oscIP);
    json.setInt("portOSC", sendPort);
    saveJSONObject(json, "data/data.json");

    isChangeIpPort = false;
  }

  if (!isChangeIpPort && keyPressed) {
    if (key == ENTER) {
      isChangeIpPort = true;
      isAlertPort = false;
    }
  }
}
//===================================================

//=========== Get Connection of the Sensor ===========
void GetConnection() {
  if (isTryGetConnection && frameCount % 120 == 0) {
    try {
      mindSet = new MindSet(this, serialPort);
      changeStatus = false;
      estadoMind = "Conectado";
    } 
    catch (Exception e) {
      estadoMind = "Error al conectar";
    }

    isTryGetConnection = false;
  }
}
//================================================

//============= Connection Status ================
void CheckStatusConnection() {
  if (estadoMind == "Desconectado") {
    indexColorsStatus = 0;
  } else if (estadoMind == "Conectado") {
    indexColorsStatus = 2;
  } else if (estadoMind == "Conectando...") {
    indexColorsStatus = 3;
  } else {
    indexColorsStatus = 1;
  }

  for (int i = 0; i<mindWaveFrequencies.length; i++) {
    if (mindWaveFrequencies[i] != mindWaveFrequenciesBefore[i] && (attention != attenBefore || attention == 0) && (meditation != mediBefore || meditation == 0)) {
      if (frameCount % 120 == 0) {
        attenBefore = attention;
        mediBefore = meditation;
        mindWaveFrequenciesBefore[i] = mindWaveFrequencies[i];
        changeStatus = false;
      }
    } else {
      if (frameCount % 120 == 0) {
        changeStatus = true;
      }
    }

    if (changeStatus && estadoMind == "Conectado") {
      if (frameCount % 600 == 0 && attention == attenBefore && meditation == mediBefore && mindWaveFrequencies[i] ==  mindWaveFrequenciesBefore[i]) {
        estadoMind = "Desconectado";
        mindSet.quit();
      }
    }
  }
}
//================================================

//=========== MindWave Functions =============
public void poorSignalEvent(int sig) {
  //println(sig);
  //signalWidget.add(200-sig);
}

public void attentionEvent(int attentionLevel) {
  //attentionWidget.add(attentionLevel);
  //println("Nivel de Atencion: " + attentionLevel);
  attention = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  //meditationWidget.add(meditationLevel);
  //println("Nivel de Meditacion: " + meditationLevel);
  meditation = meditationLevel;
}

public void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  mindWaveFrequencies[0] = delta%1000;
  mindWaveFrequencies[1] = theta%1000;
  mindWaveFrequencies[2] = low_alpha%1000;
  mindWaveFrequencies[3] = high_alpha%1000;
  mindWaveFrequencies[4] = low_beta%1000;
  mindWaveFrequencies[5] = high_beta%1000;
  mindWaveFrequencies[6] = low_gamma%1000;
  mindWaveFrequencies[7] = mid_gamma%1000;
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

void handleButtonEvents(GImageButton button, GEvent event) {
  if (button == serialPortBtn && event == GEvent.CLICKED) {
    serialPort = serialPortText.getText();
    estadoMind = "Conectando...";
    isTryGetConnection = true;
  }
}
//=======================================================
