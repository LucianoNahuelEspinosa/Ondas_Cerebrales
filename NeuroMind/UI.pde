//================ Splash ================
void Splash() {
  image(splash, 0, 0);

  if (frameCount % 180 == 0) {
    isAppInit = true;
  }
}
//========================================

//======================== UI ==========================
void infoMind (int tamTitle, int tamInfo, int tamAddresses, int tamKeyAssignation, color colorFill) {
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

      for (NetAddress n : remoteLocations) {
        oscP5.send(OSCMessages[i], n);
      }
    }
  }

  text("Nivel de Atencion: " + attention, xItems, yItems + 50);
  attentionWidget.draw(xItems + 250, yItems + 25, 300, 25);

  text("Nivel de Meditacion: " + meditation, xItems, yItems + 100);
  meditationWidget.draw(xItems + 250, yItems + 75, 300, 25);

  text("Delta: " + mindWaveFrequencies[0], xItems, yItems + 150);
  mindWaveFrequenciesWidget[0].draw(xItems + 250, yItems + 125, 300, 25);
  text("Theta: " + mindWaveFrequencies[1], xItems, yItems + 200);
  mindWaveFrequenciesWidget[1].draw(xItems + 250, yItems + 175, 300, 25);
  text("Low Alpha: " + mindWaveFrequencies[2], xItems, yItems + 250);
  mindWaveFrequenciesWidget[2].draw(xItems + 250, yItems + 225, 300, 25);
  text("High Alpha: " + mindWaveFrequencies[3], xItems, yItems + 300);
  mindWaveFrequenciesWidget[3].draw(xItems + 250, yItems + 275, 300, 25);
  text("Low Beta: " + mindWaveFrequencies[4], xItems, yItems + 350);
  mindWaveFrequenciesWidget[4].draw(xItems + 250, yItems + 325, 300, 25);
  text("High Beta: " + mindWaveFrequencies[5], xItems, yItems + 400);
  mindWaveFrequenciesWidget[5].draw(xItems + 250, yItems + 375, 300, 25);
  text("Low Gamma: " + mindWaveFrequencies[6], xItems, yItems + 450);
  mindWaveFrequenciesWidget[6].draw(xItems + 250, yItems + 425, 300, 25);
  text("Mid Gamma: " + mindWaveFrequencies[7], xItems, yItems + 500);
  mindWaveFrequenciesWidget[7].draw(xItems + 250, yItems + 475, 300, 25);

  text("Dirección IP: ", width/2+xItems+75, yItems-30);
  text("Puerto a enviar: ", width/2+xItems+75, yItems-30+50);

  rectMode(CENTER);
  fill(255);
  noStroke();
  rect(width-xItems-105, yItems-10, 30, 30);
  textAlign(CENTER);
  fill(colorFill);
  text(idIndexJSON, width-xItems-105, yItems-5);

  textSize(tamTitle);

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

  textAlign(RIGHT, BASELINE);
  fill(255);
  textSize(tamKeyAssignation);
  text("(R) Restaurar valores predeterminados  (S) Simulación   (O) Opciones direcciones OSC personalizadas", width - 50, height - 15);
  popStyle();

  if (serialPort != serialPortText.getText() || oscIP != ipText.getText() || sendPort != int(portText.getText())) {
    image(alert, width/2-alert.width/2, 10);
  }

  if (isAlertPort) {
    image(alertPort, width/2-alertPort.width/2, height/2-alertPort.height/2);
  }
}
//===================================================
