//============= Setup GUI ================
void InitGUI() {
  ipText = new GTextField(this, width/2+xItems+175, yItems-45, 90, 20);
  ipText.tag = "IpAddress";
  ipText.setPromptText(inEnglish ? "IP Address" : "Direccion IP");
  ipText.setText(oscIP);

  portText = new GTextField(this, width/2+xItems+200, yItems-30+35, 50, 20);
  portText.tag = "portNumber";
  portText.setPromptText(inEnglish ? "Port" : "Puerto");
  portText.setText(str(sendPort));
  portText.setNumericType(G4P.INTEGER);

  serialPortText = new GTextField(this, xItems+180, yItems-50, 200, 20);
  serialPortText.tag = "serialPort";
  serialPortText.setPromptText(inEnglish ? "Serial Port" : "Puerto Serial");
  serialPortText.setText(serialPort);

  serialPortBtn = new GImageButton(this, xItems+400, yItems-65, 135, 50, inEnglish ? imgsSerialPortButtonEn : imgsSerialPortButton);

  addOSCBtn = new GImageButton(this, width-xItems-50, yItems-20, 21, 21, imgsAddButton);
  removeOSCBtn = new GImageButton(this, width-xItems-175, yItems-20, 21, 21, imgsRemoveButton);
  upIndexBtn = new GImageButton(this, width-xItems-75, yItems-20, 21, 21, imgsUpButton);
  downIndexBtn = new GImageButton(this, width-xItems-150, yItems-20, 21, 21, imgsDownButton);

  isInitGUI = true;
}
//=========================================

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
    inFocusInput = false;
    break;
  case GETS_FOCUS:
    println("GETS_FOCUS " + extra);
    inFocusInput = true;
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
    if (mindSet != null) {
      mindSet.quit();
    }

    serialPort = serialPortText.getText();
    estadoMind = "Conectando...";
    MindStatus = "Connecting...";
    isTryGetConnection = true;
  }

  if (button == addOSCBtn && event == GEvent.CLICKED) {
    json.setString("portSerial", serialPort);
    json.setBoolean("inEnglish", inEnglish);
    JSONObject j = new JSONObject();
    j.setInt("id", ja.size());
    j.setString("ipOSC", "127.0.0.1");
    j.setInt("portOSC", 7000);
    ja.setJSONObject(ja.size(), j);
    json.setJSONArray("osc", ja);
    saveJSONObject(json, "data/data.json");

    ipText.setText("127.0.0.1");
    portText.setText(str(7000));
    oscIP = ipText.getText();
    sendPort = int(portText.getText());

    if (idIndexJSON == ja.size()-2) {
      idIndexJSON++;
    } else {
      idIndexJSON = ja.size()-1;
    }

    remoteLocations.add(new NetAddress("127.0.0.1", 7000));
  }

  if (button == removeOSCBtn && event == GEvent.CLICKED) {
    ja = json.getJSONArray("osc");
    ja.remove(idIndexJSON);
    saveJSONObject(json, "data/data.json");

    remoteLocations.remove(idIndexJSON);

    idIndexJSON--;
    JSONObject item = ja.getJSONObject(idIndexJSON); 
    oscIP = item.getString("ipOSC");
    sendPort = item.getInt("portOSC");
    ipText.setText(oscIP);
    portText.setText(str(sendPort));
  }

  if (button == upIndexBtn && event == GEvent.CLICKED) {
    ja = json.getJSONArray("osc");
    idIndexJSON++;
    JSONObject item = ja.getJSONObject(idIndexJSON); 
    oscIP = item.getString("ipOSC");
    sendPort = item.getInt("portOSC");
    ipText.setText(oscIP);
    portText.setText(str(sendPort));
  }

  if (button == downIndexBtn && event == GEvent.CLICKED) {
    ja = json.getJSONArray("osc");
    idIndexJSON--;
    JSONObject item = ja.getJSONObject(idIndexJSON); 
    oscIP = item.getString("ipOSC");
    sendPort = item.getInt("portOSC");
    ipText.setText(oscIP);
    portText.setText(str(sendPort));
  }

  //Custom OSC Button
  if (button == addOSCAddressBtn && event == GEvent.CLICKED) {
    JSONObject j = new JSONObject();
    j.setInt("id", ja2.size());
    j.setString("address", " ");
    j.setInt("indexValue", 0);
    j.setBoolean("isMapValue", false);
    j.setFloat("fromMapValue", 0.0);
    j.setFloat("toMapValue", 0.0);
    ja2.setJSONObject(ja2.size(), j);
    json.setJSONArray("addressOsc", ja2);
    saveJSONObject(json, "data/data.json");

    MessagesOsc.add(new OscMessage(" "));
    indexDropdownValue.add(0);
    areNeedMapValue.add(false);
    fromMapValues.add(0.0);
    toMapValues.add(0.0);

    addressInput.setText("");
    dropdownSensorValues.setSelected(0);
    optionNo.setSelected(true);
    optionYes.setSelected(false);
    changeOption = false;
    fromMapInput.setText("0.0");
    toMapInput.setText("0.0");

    if (indexOSCAddresses == ja2.size()-2) {
      indexOSCAddresses++;
    } else {
      indexOSCAddresses = ja2.size()-1;
    }
  }

  if (button == removeOSCAddressBtn && event == GEvent.CLICKED) {
    ja2 = json.getJSONArray("addressOsc");
    ja2.remove(indexOSCAddresses);
    saveJSONObject(json, "data/data.json");

    MessagesOsc.remove(indexOSCAddresses);
    indexDropdownValue.remove(indexOSCAddresses);
    areNeedMapValue.remove(indexOSCAddresses);
    fromMapValues.remove(indexOSCAddresses);
    toMapValues.remove(indexOSCAddresses);

    indexOSCAddresses--;

    JSONObject item = ja2.getJSONObject(indexOSCAddresses);
    currentAddress = item.getString("address");
    indexDropdown = item.getInt("indexValue");
    currentIndexDropdown = item.getInt("indexValue");
    changeOption = item.getBoolean("isMapValue");
    currentOption = item.getBoolean("isMapValue");
    currentFromMap = item.getFloat("fromMapValue");
    currentToMap = item.getFloat("toMapValue");

    addressInput.setText(item.getString("address"));
    dropdownSensorValues.setSelected(item.getInt("indexValue"));
    fromMapInput.setText(str(item.getFloat("fromMapValue")));
    toMapInput.setText(str(item.getFloat("toMapValue")));

    if (item.getBoolean("isMapValue")) {
      optionNo.setSelected(false);
      optionYes.setSelected(true);
    } else {
      optionNo.setSelected(true);
      optionYes.setSelected(false);
    }
  }

  if (button == upIndexAddressBtn && event == GEvent.CLICKED) {
    ja2 = json.getJSONArray("addressOsc");

    indexOSCAddresses++;

    JSONObject item = ja2.getJSONObject(indexOSCAddresses);
    currentAddress = item.getString("address");
    indexDropdown = item.getInt("indexValue");
    currentIndexDropdown = item.getInt("indexValue");
    changeOption = item.getBoolean("isMapValue");
    currentOption = item.getBoolean("isMapValue");
    currentFromMap = item.getFloat("fromMapValue");
    currentToMap = item.getFloat("toMapValue");

    addressInput.setText(item.getString("address"));
    dropdownSensorValues.setSelected(item.getInt("indexValue"));
    fromMapInput.setText(str(item.getFloat("fromMapValue")));
    toMapInput.setText(str(item.getFloat("toMapValue")));

    if (item.getBoolean("isMapValue")) {
      optionNo.setSelected(false);
      optionYes.setSelected(true);
    } else {
      optionNo.setSelected(true);
      optionYes.setSelected(false);
    }
  }

  if (button == downIndexAddressBtn && event == GEvent.CLICKED) {
    ja2 = json.getJSONArray("addressOsc");

    indexOSCAddresses--;

    JSONObject item = ja2.getJSONObject(indexOSCAddresses);
    currentAddress = item.getString("address");
    indexDropdown = item.getInt("indexValue");
    currentIndexDropdown = item.getInt("indexValue");
    changeOption = item.getBoolean("isMapValue");
    currentOption = item.getBoolean("isMapValue");
    currentFromMap = item.getFloat("fromMapValue");
    currentToMap = item.getFloat("toMapValue");

    addressInput.setText(item.getString("address"));
    dropdownSensorValues.setSelected(item.getInt("indexValue"));
    fromMapInput.setText(str(item.getFloat("fromMapValue")));
    toMapInput.setText(str(item.getFloat("toMapValue")));

    if (item.getBoolean("isMapValue")) {
      optionNo.setSelected(false);
      optionYes.setSelected(true);
    } else {
      optionNo.setSelected(true);
      optionYes.setSelected(false);
    }
  }
}

void OSCButtonsStatus() {  
  if (ja.size() > 1 && idIndexJSON > 0) {
    removeOSCBtn.setEnabled(true);
  } else {
    removeOSCBtn.setEnabled(false);
  }

  if (ja.size()-1 == idIndexJSON) {
    upIndexBtn.setEnabled(false);
  } else {
    upIndexBtn.setEnabled(true);
  }

  if (ja.size() == 1 || idIndexJSON == 0) {
    downIndexBtn.setEnabled(false);
  } else {
    downIndexBtn.setEnabled(true);
  }

  //Custom OSC Buttons
  if (removeOSCAddressBtn != null && upIndexAddressBtn != null && downIndexAddressBtn != null) {
    if (ja2.size() > 1 && indexOSCAddresses > 0) {
      removeOSCAddressBtn.setEnabled(true);
    } else {
      removeOSCAddressBtn.setEnabled(false);
    }

    if (ja2.size()-1 == indexOSCAddresses) {
      upIndexAddressBtn.setEnabled(false);
    } else {
      upIndexAddressBtn.setEnabled(true);
    }

    if (ja2.size() == 1 || indexOSCAddresses == 0) {
      downIndexAddressBtn.setEnabled(false);
    } else {
      downIndexAddressBtn.setEnabled(true);
    }
  }
}

void handleDropListEvents(GDropList list, GEvent event) {
  if (event == GEvent.SELECTED) {
    indexDropdown = list.getSelectedIndex();
  }
}

public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if (event == GEvent.SELECTED) {
    changeOption = !changeOption;
  }
}
//=======================================================
