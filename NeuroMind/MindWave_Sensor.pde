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
  attentionWidget.add(attentionLevel);
  attention = attentionLevel;
}


public void meditationEvent(int meditationLevel) {
  meditationWidget.add(meditationLevel);
  meditation = meditationLevel;
}

public void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  mindWaveFrequencies[0] = delta%1000;
  mindWaveFrequenciesWidget[0].add(delta);
  mindWaveFrequencies[1] = theta%1000;
  mindWaveFrequenciesWidget[1].add(theta);
  mindWaveFrequencies[2] = low_alpha%1000;
  mindWaveFrequenciesWidget[2].add(low_alpha);
  mindWaveFrequencies[3] = high_alpha%1000;
  mindWaveFrequenciesWidget[3].add(high_alpha);
  mindWaveFrequencies[4] = low_beta%1000;
  mindWaveFrequenciesWidget[4].add(low_beta);
  mindWaveFrequencies[5] = high_beta%1000;
  mindWaveFrequenciesWidget[5].add(high_beta);
  mindWaveFrequencies[6] = low_gamma%1000;
  mindWaveFrequenciesWidget[6].add(low_gamma);
  mindWaveFrequencies[7] = mid_gamma%1000;
  mindWaveFrequenciesWidget[7].add(mid_gamma);
}

void simulate() {
  if (keyPressed) {
    if (key == 's' && !isChangeStatusSimulation && !inFocusInput) {
      isSimulation = !isSimulation;
      isChangeStatusSimulation = true;
    }
  } else {
    isChangeStatusSimulation = false;
  }

  if (isSimulation) {
    if (frameCount % 60 == 0) {
      //poorSignalEvent(int(random(200)));
      attentionEvent(int(random(100)));
      meditationEvent(int(random(100)));
      eegEvent(int(random(1000)), int(random(1000)), int(random(1000)), 
        int(random(1000)), int(random(1000)), int(random(1000)), 
        int(random(1000)), int(random(1000)) );
    }
  }
}
//=============================================
