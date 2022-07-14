/*

 NeuroMind by Luciano Nahuel Espinosa - 2022
 https://lucianoespinosa-7954e.firebaseapp.com
 
 Version: 1.2
 
 */

import g4p_controls.*;
import netP5.*;
import oscP5.*;
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;
String serialPort = ""; //Puerto Saliente

OscP5 oscP5;
ArrayList<NetAddress> remoteLocations = new ArrayList<NetAddress>();
int sendPort = 7000; //Puerto para enviar informacion
String oscIP = "127.0.0.1"; //Direccion IP de conexion osc

GTextField portText, ipText, serialPortText;
GImageButton serialPortBtn, addOSCBtn, removeOSCBtn, upIndexBtn, downIndexBtn;
String[] imgsSerialPortButton = {"SerialPortButton_Idle.png", "SerialPortButton_Hover.png", "SerialPortButton_Pressed.png"};
String[] imgsSerialPortButtonEn = {"SerialPortButton_Idle_EN.png", "SerialPortButton_Hover_EN.png", "SerialPortButton_Pressed_EN.png"};
String[] imgsAddButton = {"ADD.png", "ADD_Hover.png", "ADD_Pressed.png"};
String[] imgsRemoveButton = {"REMOVE.png", "REMOVE_Hover.png", "REMOVE_Pressed.png"};
String[] imgsUpButton = {"UP_Index.png", "UP_Index_Hover.png", "UP_Index_Pressed.png"};
String[] imgsDownButton = {"DOWN_Index.png", "DOWN_Index_Hover.png", "DOWN_Index_Pressed.png"};
boolean isChangeIpPort, isInitGUI, inFocusInput, isKeyPressed;

float attention, meditation;
float attenBefore, mediBefore;
SampleWidget attentionWidget, meditationWidget;
float[] mindWaveFrequencies = new float[8];
float[] mindWaveFrequenciesBefore = new float[8];
SampleWidget[] mindWaveFrequenciesWidget = new SampleWidget[8];
float xItems = 75;
float yItems = 160;
OscMessage[] OSCMessages = new OscMessage[10];
String estadoMind = "Desconectado";
String MindStatus = "Disconnected";
color[] colorsStatus = {color(150), color(255, 0, 0), color(0, 200, 0), color(50)};
int indexColorsStatus;
PImage alert, alertPort, alertEn, alertPortEn;
boolean isAlertPort, isTryGetConnection, changeStatus;

String [] direcciones = {"/mindAttention", "/mindMeditation", "/mindDelta", "/mindTheta", "/mindLowAlpha", "/mindHighAlpha", "/mindLowBeta", "/mindHighBeta", "/mindLowGamma", "/mindMidGamma"};

PFont robotoRegular, robotoBold;

PImage background, splash;
boolean isAppInit;
boolean isSimulation, isChangeStatusSimulation;
boolean inEnglish, currentLanguage;

JSONObject json;
JSONArray ja, ja2;
int idIndexJSON;

void setup() {
  size(1280, 720);
  surface.setTitle("NeuroMind");
  surface.setIcon(loadImage("Icon.png"));

  background = loadImage("Home.png");
  alert = loadImage("Alert.png");
  alertPort = loadImage("AlertPort.png");
  alertEn = loadImage("Alert_EN.png");
  alertPortEn = loadImage("AlertPort_EN.png");
  splash = loadImage("Splash.png");

  //========== Load/Create Json file ===========
  try {
    json = loadJSONObject("data.json");

    serialPort = json.getString("portSerial");
    inEnglish = json.getBoolean("inEnglish");
    currentLanguage = inEnglish;

    ja = json.getJSONArray("osc");
    JSONObject item = ja.getJSONObject(0);
    idIndexJSON = item.getInt("id");
    oscIP = item.getString("ipOSC");
    sendPort = item.getInt("portOSC");

    for (int i = 0; i<ja.size(); i++) {
      JSONObject it = ja.getJSONObject(i);
      remoteLocations.add(new NetAddress(it.getString("ipOSC"), it.getInt("portOSC")));
    }

    ja2 = json.getJSONArray("addressOsc");
    for (int i = 0; i<ja2.size(); i++) {
      JSONObject it = ja2.getJSONObject(i);
      MessagesOsc.add(new OscMessage(it.getString("address")));
      indexDropdownValue.add(it.getInt("indexValue"));
      areNeedMapValue.add(it.getBoolean("isMapValue"));
      fromMapValues.add(it.getFloat("fromMapValue"));
      toMapValues.add(it.getFloat("toMapValue"));
    }
    JSONObject item2 = ja2.getJSONObject(0);
    indexOSCAddresses = item2.getInt("id");
    currentAddress = item2.getString("address");
    indexDropdown = item2.getInt("indexValue");
    currentIndexDropdown = item2.getInt("indexValue");
    changeOption = item2.getBoolean("isMapValue");
    currentOption = item2.getBoolean("isMapValue");
    currentFromMap = item2.getFloat("fromMapValue");
    currentToMap = item2.getFloat("toMapValue");
  } 
  catch (Exception e) {
    json = new JSONObject();

    json.setString("portSerial", " ");

    inEnglish = System.getProperty("user.language") == "es" ? false : true;
    currentLanguage = inEnglish;
    json.setBoolean("inEnglish", inEnglish);

    ja = new JSONArray();
    JSONObject j = new JSONObject();
    j.setInt("id", 0);
    j.setString("ipOSC", "127.0.0.1");
    j.setInt("portOSC", 7000);
    ja.setJSONObject(0, j);
    json.setJSONArray("osc", ja);

    ja2 = new JSONArray();
    JSONObject j2 = new JSONObject();
    j2.setInt("id", 0);
    j2.setString("address", " ");
    j2.setInt("indexValue", 0);
    j2.setBoolean("isMapValue", false);
    j2.setFloat("fromMapValue", 0.0);
    j2.setFloat("toMapValue", 0.0);
    ja2.setJSONObject(0, j2);
    json.setJSONArray("addressOsc", ja2);

    MessagesOsc.add(new OscMessage(" "));
    indexDropdownValue.add(0);
    areNeedMapValue.add(false);
    fromMapValues.add(0.0);
    toMapValues.add(0.0);

    saveJSONObject(json, "data/data.json");

    remoteLocations.add(new NetAddress("127.0.0.1", 7000));
  }
  //============================================

  attentionWidget = new SampleWidget(100, true, 100);
  meditationWidget = new SampleWidget(100, true, 100);

  for (int i = 0; i<mindWaveFrequenciesWidget.length; i++) {
    mindWaveFrequenciesWidget[i] = new SampleWidget(100, true, 1000);
  }

  robotoRegular = createFont("Roboto-Regular.ttf", 14);
  robotoBold = createFont("Roboto-Regular.ttf", 24);

  oscP5 = new OscP5(this, 1);
}

void draw() {
  background(background);

  if (isAppInit) {
    if (!isInitGUI) {
      InitGUI();
    }

    infoMind(24, 16, 14, 12, 0);  //infoMind("tamanio titulos", "tamanio texto general", tamaño texto direcciones", "tamanio texto asignacion de teclas", "color de los textos")
    GetConnection();
    CheckStatusConnection();
    Osc();
    OSCButtonsStatus();
    simulate(); //Simulation Sensor's Values
    changeLanguage();

    CustomOSCAddresses();
  } else {
    Splash();
  }

  //println("FPS: " + frameRate);
}
