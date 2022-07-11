ArrayList<OscMessage> MessagesOsc = new ArrayList<OscMessage>();
ArrayList<Integer> indexDropdownValue = new ArrayList<Integer>();
int indexOSCAddresses, indexDropdown, currentIndexDropdown;
String currentAddress;

GTextField addressInput;
GDropList dropdownSensorValues;
String[] dropdownItems = {"Atencion", "Meditacion", "Delta", "Theta", "LowAlpha", "HighAlpha", "LowBeta", "HighBeta", "LowGamma", "MidGamma"};
GImageButton addOSCAddressBtn, removeOSCAddressBtn, upIndexAddressBtn, downIndexAddressBtn;

boolean isShowHidePopUp, isShowPopUp, isCreatedInputs;
int alphaInputsBehindPopUp = 100;
float heightInputs = 10;

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
      removeInputsPopUp();
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
  rect(width/2, height/2, width/2, height/2-200, 25);

  textAlign(CENTER);
  fill(0);
  textSize(16);
  text("Enviar valores a direcciones OSC personalizadas", width/2, height/2-40);

  if (!isCreatedInputs) {
    createInputsPopUp();
  } else {
    showInputsPopUp();
  }

  fill(255);
  rect(width/2+160, height/2+heightInputs+10, 30, 30);
  textSize(14);
  fill(0);
  text(indexOSCAddresses, width/2+160, height/2+heightInputs+15);

  popStyle();

  if (currentAddress != addressInput.getText() || currentIndexDropdown != indexDropdown) {
    image(alert, width/2-alert.width/2, 10);
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
  addressInput.setPromptText("Direccion OSC");
  addressInput.setText(currentAddress);

  dropdownSensorValues = new GDropList(this, width/2-25, height/2+heightInputs+2, 75, 75);
  for (int i = 0; i<dropdownItems.length; i++) {
    dropdownSensorValues.insertItem(i, dropdownItems[i]);
  }
  dropdownSensorValues.setSelected(indexDropdown);

  addOSCAddressBtn = new GImageButton(this, width/2+225, height/2+heightInputs, 21, 21, imgsAddButton);
  removeOSCAddressBtn = new GImageButton(this, width/2+75, height/2+heightInputs, 21, 21, imgsRemoveButton);
  upIndexAddressBtn = new GImageButton(this, width/2+200, height/2+heightInputs, 21, 21, imgsUpButton);
  downIndexAddressBtn = new GImageButton(this, width/2+100, height/2+heightInputs, 21, 21, imgsDownButton);

  isCreatedInputs = true;
}

void showInputsPopUp() {
  addressInput.setVisible(true);
  dropdownSensorValues.setVisible(true);
  addOSCAddressBtn.setVisible(true);
  removeOSCAddressBtn.setVisible(true);
  upIndexAddressBtn.setVisible(true);
  downIndexAddressBtn.setVisible(true);
}

void removeInputsPopUp() {
  addressInput.setVisible(false);
  dropdownSensorValues.setVisible(false);
  addOSCAddressBtn.setVisible(false);
  removeOSCAddressBtn.setVisible(false);
  upIndexAddressBtn.setVisible(false);
  downIndexAddressBtn.setVisible(false);
}
//===============================================

//=================== OSC =======================
void OscCustomValue() {
  for (int i = 0; i<MessagesOsc.size(); i++) {
    OscMessage message = MessagesOsc.get(i);

    message.add(sendOSCCustomValue(indexDropdownValue.get(i)));

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
//===============================================
