ArrayList<OscMessage> MessagesOsc = new ArrayList<OscMessage>();
ArrayList<Integer> indexDropdownValue = new ArrayList<Integer>();
ArrayList<Boolean> areNeedMapValue = new ArrayList<Boolean>();
ArrayList<Float> fromMapValues = new ArrayList<Float>();
ArrayList<Float> toMapValues = new ArrayList<Float>();
int indexOSCAddresses, indexDropdown, currentIndexDropdown;
String currentAddress = " ";
boolean changeOption, currentOption;
float currentFromMap, currentToMap;

GTextField addressInput, fromMapInput, toMapInput;
GDropList dropdownSensorValues;
String[] dropdownItems = {"Attention", "Meditation", "Delta", "Theta", "LowAlpha", "HighAlpha", "LowBeta", "HighBeta", "LowGamma", "MidGamma"};
GImageButton addOSCAddressBtn, removeOSCAddressBtn, upIndexAddressBtn, downIndexAddressBtn;
GToggleGroup optionGroup;
GOption optionYes, optionNo;

boolean isShowHidePopUp, isShowPopUp, isCreatedInputs;
int alphaInputsBehindPopUp = 100;
float heightInputs = -25;

void CustomOSCAddresses() {
  showHidePopUp();

  if (isShowPopUp) {
    ipText.setAlpha(alphaInputsBehindPopUp);
    portText.setAlpha(alphaInputsBehindPopUp);
    serialPortText.setAlpha(alphaInputsBehindPopUp);
    serialPortBtn.setAlpha(alphaInputsBehindPopUp);
    addOSCBtn.setAlpha(alphaInputsBehindPopUp);
    removeOSCBtn.setAlpha(alphaInputsBehindPopUp);
    upIndexBtn.setAlpha(alphaInputsBehindPopUp);
    downIndexBtn.setAlpha(alphaInputsBehindPopUp);

    PopUpCustomOSCAddresses();
  } else {
    if (isCreatedInputs) {
      showHideInputsPopUp(false);
    }

    ipText.setAlpha(255);
    portText.setAlpha(255);
    serialPortText.setAlpha(255);
    serialPortBtn.setAlpha(255);
    addOSCBtn.setAlpha(255);
    removeOSCBtn.setAlpha(255);
    upIndexBtn.setAlpha(255);
    downIndexBtn.setAlpha(255);
  }

  OscCustomValue();
}

//============= PopUp OSC Adresses ==============
void PopUpCustomOSCAddresses() {
  pushStyle();

  fill(0, 50);
  noStroke();
  rect(0, 0, width, height);

  rectMode(CENTER);
  fill(242);
  rect(width/2, height/2, width/2, height/2-175, 25);

  textFont(robotoBold);
  textAlign(CENTER);
  fill(0);
  textSize(16);
  text(inEnglish ? "Send values to custom OSC Addresses" : "Enviar valores a direcciones OSC personalizadas", width/2, height/2-60);

  if (!isCreatedInputs) {
    createInputsPopUp();
  } else {
    showHideInputsPopUp(true);
    addressInput.setPromptText(inEnglish ? "OSC Address" : "Direccion OSC");
    optionYes.setText(inEnglish ? "Yes" : "Si");
    fromMapInput.setPromptText(inEnglish ? "From" : "Desde");
    toMapInput.setPromptText(inEnglish ? "To" : "Hasta");
  }

  textFont(robotoRegular);
  fill(255);
  rect(width/2+160, height/2+heightInputs+10, 30, 30);
  textSize(14);
  fill(0);
  text(indexOSCAddresses, width/2+160, height/2+heightInputs+15);

  textFont(robotoBold);
  textSize(14);
  text(inEnglish ? "Do the values have to be mapped?" : "¿Se tiene que mapear los valores?", width/2-125, height/2+heightInputs+60);

  textFont(robotoRegular);
  if (changeOption) {
    fromMapInput.setVisible(true);
    toMapInput.setVisible(true);
    text(inEnglish ? "From" : "Desde", width/2+50, height/2+heightInputs+92.5);
    text(inEnglish ? "To" : "Hasta", width/2+150, height/2+heightInputs+92.5);
  } else {
    fromMapInput.setVisible(false);
    toMapInput.setVisible(false);
  }

  popStyle();

  if (currentAddress != addressInput.getText() || currentIndexDropdown != indexDropdown || currentOption != changeOption || currentFromMap != float(fromMapInput.getText()) || currentToMap != float(toMapInput.getText())) {
    image(inEnglish ? alertEn : alert, width/2-alert.width/2, 10);
  }
}
//===============================================

//============= Show/Hide PopUp =================
void showHidePopUp() {
  if (keyPressed) {
    if (key == 'o' && !isShowHidePopUp && !inFocusInput) {
      isShowPopUp = !isShowPopUp;
      isShowHidePopUp = true;
    }
  } else {
    isShowHidePopUp = false;
  }
}
//===============================================

//================= Inputs ======================
void createInputsPopUp() {
  addressInput = new GTextField(this, width/2-275, height/2+heightInputs, 225, 20);
  addressInput.tag = "OscAddress";
  addressInput.setPromptText(inEnglish ? "OSC Address" : "Direccion OSC");
  addressInput.setText(currentAddress);

  dropdownSensorValues = new GDropList(this, width/2-25, height/2+heightInputs, 75, 100);
  for (int i = 0; i<dropdownItems.length; i++) {
    dropdownSensorValues.insertItem(i, dropdownItems[i]);
  }
  dropdownSensorValues.setSelected(indexDropdown);
  dropdownSensorValues.setLocalColorScheme(6);
  dropdownSensorValues.setLocalColor(5, 255);
  dropdownSensorValues.setLocalColor(6, 255);

  addOSCAddressBtn = new GImageButton(this, width/2+225, height/2+heightInputs, 21, 21, imgsAddButton);
  removeOSCAddressBtn = new GImageButton(this, width/2+75, height/2+heightInputs, 21, 21, imgsRemoveButton);
  upIndexAddressBtn = new GImageButton(this, width/2+200, height/2+heightInputs, 21, 21, imgsUpButton);
  downIndexAddressBtn = new GImageButton(this, width/2+100, height/2+heightInputs, 21, 21, imgsDownButton);

  GAnimIcon ico = new GAnimIcon(this, "RadioInputs.png", 2, 2, 300);
  ico.storeAnim("SELECT", 2, 2, 300, 1);
  ico.storeAnim("DESELECT", 0, 0, 300, 1);

  optionNo = new GOption(this, width/2-75, height/2+heightInputs+75, 40, 30, "No");
  optionNo.setIcon(ico, GAlign.WEST, GAlign.CENTER, GAlign.MIDDLE);
  optionYes = new GOption(this, width/2-25, height/2+heightInputs+75, 45, 30, inEnglish ? "Yes" : "Si");
  optionYes.setIcon(ico, GAlign.WEST, GAlign.CENTER, GAlign.MIDDLE);

  optionGroup = new GToggleGroup();
  optionGroup.addControls(optionNo, optionYes);

  if (currentOption) {
    optionNo.setSelected(false);
    optionYes.setSelected(true);
  } else {
    optionNo.setSelected(true);
    optionYes.setSelected(false);
  }

  fromMapInput = new GTextField(this, width/2+75, height/2+heightInputs+80, 30, 15);
  fromMapInput.tag = "fromMapInput";
  fromMapInput.setPromptText(inEnglish ? "From" : "Desde");
  fromMapInput.setText(str(currentFromMap));
  fromMapInput.setNumericType(G4P.DECIMAL);

  toMapInput = new GTextField(this, width/2+175, height/2+heightInputs+80, 30, 15);
  toMapInput.tag = "toMapInput";
  toMapInput.setPromptText(inEnglish ? "To" : "Hasta");
  toMapInput.setText(str(currentToMap));
  toMapInput.setNumericType(G4P.DECIMAL);

  isCreatedInputs = true;
}

void showHideInputsPopUp(boolean b) {
  addressInput.setVisible(b);
  dropdownSensorValues.setVisible(b);
  addOSCAddressBtn.setVisible(b);
  removeOSCAddressBtn.setVisible(b);
  upIndexAddressBtn.setVisible(b);
  downIndexAddressBtn.setVisible(b);
  optionNo.setVisible(b);
  optionYes.setVisible(b);
  fromMapInput.setVisible(b);
  toMapInput.setVisible(b);
}
//===============================================

//=================== OSC =======================
void OscCustomValue() {
  for (int i = 0; i<MessagesOsc.size(); i++) {
    OscMessage message = MessagesOsc.get(i);

    if (!areNeedMapValue.get(i)) {
      message.add(sendOSCCustomValue(indexDropdownValue.get(i)));
    } else {
      message.add(sendOSCCustomValue(indexDropdownValue.get(i), fromMapValues.get(i), toMapValues.get(i)));
    }

    for (NetAddress n : remoteLocations) {
      oscP5.send(message, n);
    }

    message.clearArguments();
  }
}

float sendOSCCustomValue(int index) {
  if (index == 0) {
    return attention;
  } else if (index == 1) {
    return meditation;
  } else if (index == 2) {
    return mindWaveFrequencies[0];
  } else if (index == 3) {
    return mindWaveFrequencies[1];
  } else if (index == 4) {
    return mindWaveFrequencies[2];
  } else if (index == 5) {
    return mindWaveFrequencies[3];
  } else if (index == 6) {
    return mindWaveFrequencies[4];
  } else if (index == 7) {
    return mindWaveFrequencies[5];
  } else if (index == 8) {
    return mindWaveFrequencies[6];
  } else {
    return mindWaveFrequencies[7];
  }
}

float sendOSCCustomValue(int index, float from, float to) {
  if (index == 0) {
    return map(attention, 0, 100, from, to);
  } else if (index == 1) {
    return map(meditation, 0, 100, from, to);
  } else if (index == 2) {
    return map(mindWaveFrequencies[0], 0, 1000, from, to);
  } else if (index == 3) {
    return map(mindWaveFrequencies[1], 0, 1000, from, to);
  } else if (index == 4) {
    return map(mindWaveFrequencies[2], 0, 1000, from, to);
  } else if (index == 5) {
    return map(mindWaveFrequencies[3], 0, 1000, from, to);
  } else if (index == 6) {
    return map(mindWaveFrequencies[4], 0, 1000, from, to);
  } else if (index == 7) {
    return map(mindWaveFrequencies[5], 0, 1000, from, to);
  } else if (index == 8) {
    return map(mindWaveFrequencies[6], 0, 1000, from, to);
  } else {
    return map(mindWaveFrequencies[7], 0, 1000, from, to);
  }
}
//===============================================
