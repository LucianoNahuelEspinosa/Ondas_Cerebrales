void Osc() {
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

  ChangeOSCSend();
}

void ChangeOSCSend() {
  if (isChangeIpPort) {
    serialPort = serialPortText.getText();
    oscIP = ipText.getText();
    sendPort = int(portText.getText());
    currentLanguage = inEnglish;

    if (sendPort > 1 && sendPort <= 65535) {
      remoteLocations.set(idIndexJSON, new NetAddress(oscIP, sendPort));
    } else {
      isAlertPort = true;
    }

    json.setString("portSerial", serialPort);
    json.setBoolean("inEnglish", inEnglish);

    JSONObject j = new JSONObject();
    j.setInt("id", idIndexJSON);
    j.setString("ipOSC", oscIP);
    j.setInt("portOSC", sendPort);
    ja.setJSONObject(idIndexJSON, j);
    json.setJSONArray("osc", ja);

    if (isShowPopUp) {
      currentAddress = addressInput.getText();
      currentIndexDropdown = indexDropdown;
      currentOption = changeOption;
      currentFromMap = float(fromMapInput.getText());
      currentToMap = float(toMapInput.getText());

      JSONObject j2 = new JSONObject();
      j2.setInt("id", indexOSCAddresses);
      j2.setString("address", addressInput.getText());
      j2.setInt("indexValue", indexDropdown);
      j2.setBoolean("isMapValue", changeOption);
      j2.setFloat("fromMapValue", float(fromMapInput.getText()));
      j2.setFloat("toMapValue", float(toMapInput.getText()));
      ja2.setJSONObject(indexOSCAddresses, j2);
      json.setJSONArray("addressOsc", ja2);

      indexDropdownValue.set(indexOSCAddresses, indexDropdown);
      MessagesOsc.set(indexOSCAddresses, new OscMessage(addressInput.getText()));
      areNeedMapValue.set(indexOSCAddresses, changeOption);
      fromMapValues.set(indexOSCAddresses, float(fromMapInput.getText()));
      toMapValues.set(indexOSCAddresses, float(toMapInput.getText()));
    }

    saveJSONObject(json, "data/data.json");

    isChangeIpPort = false;
  }

  if (keyPressed) {
    if (!isKeyPressed) {
      isKeyPressed = true;

      if (!isChangeIpPort && key == ENTER) {
        isChangeIpPort = true;
        isAlertPort = false;
      }

      if (key == 'r' && !inFocusInput) {
        resetData();
      }
    }
  } else {
    isKeyPressed = false;
  }
}

void resetData() {
  if (!isShowPopUp) {
    serialPortText.setText(" ");
    ipText.setText("127.0.0.1");
    portText.setText(str(7000));
  } else {
    addressInput.setText(" ");
    dropdownSensorValues.setSelected(0);
    indexDropdown = 0;
    optionNo.setSelected(true);
    optionYes.setSelected(false);
    changeOption = false;
    fromMapInput.setText("0.0");
    toMapInput.setText("0.0");
  }
}
