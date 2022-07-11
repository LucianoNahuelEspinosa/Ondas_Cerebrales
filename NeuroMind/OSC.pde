void ChangeOSCSend() {
  if (isChangeIpPort) {
    serialPort = serialPortText.getText();
    oscIP = ipText.getText();
    sendPort = int(portText.getText());

    if (sendPort > 1 && sendPort <= 65535) {
      remoteLocations.set(idIndexJSON, new NetAddress(oscIP, sendPort));
    } else {
      isAlertPort = true;
    }

    json.setString("portSerial", serialPort);

    JSONObject j = new JSONObject();
    j.setInt("id", idIndexJSON);
    j.setString("ipOSC", oscIP);
    j.setInt("portOSC", sendPort);
    ja.setJSONObject(idIndexJSON, j);
    json.setJSONArray("osc", ja);

    if (isShowPopUp) {
      currentAddress = addressInput.getText();
      currentIndexDropdown = indexDropdown;

      JSONObject j2 = new JSONObject();
      j2.setInt("id", indexOSCAddresses);
      j2.setString("address", addressInput.getText());
      j2.setInt("indexValue", indexDropdown);
      ja2.setJSONObject(indexOSCAddresses, j2);
      json.setJSONArray("addressOsc", ja2);

      indexDropdownValue.set(indexOSCAddresses, indexDropdown);
      MessagesOsc.set(indexOSCAddresses, new OscMessage(addressInput.getText()));
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
  }
}
