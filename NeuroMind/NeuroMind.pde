/*

 NeuroMind by Luciano Nahuel Espinosa - 2022
 https://lucianoespinosa-7954e.firebaseapp.com
 
 Version: 1.0
 
 */

import g4p_controls.*;
import netP5.*;
import oscP5.*;
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;
String serialPort = "COM4"; //Puerto Saliente

OscP5 oscP5;
NetAddress myRemoteLocation;
int sendPort = 7000; //Puerto para enviar informacion
String oscIP = "127.0.0.1"; //Direccion IP de conexion osc

GTextField portText, ipText, serialPortText;
GImageButton serialPortBtn;
String[] imgsSerialPortButton = {"SerialPortButton_Idle.png", "SerialPortButton_Hover.png", "SerialPortButton_Pressed.png"};
boolean isChangeIpPort, isInitGUI, inFocusInput;

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
color[] colorsStatus = {color(150), color(255, 0, 0), color(0, 200, 0), color(50)};
int indexColorsStatus;
PImage alert, alertPort;
boolean isAlertPort, isTryGetConnection, changeStatus;

String [] direcciones = {"/mindAtencion", "/mindMeditacion", "/mindDelta", "/mindTheta", "/mindLowAlpha", "/mindHighAlpha", "/mindLowBeta", "/mindHighBeta", "/mindLowGamma", "/mindMidGamma"};

PImage background, splash;
boolean isAppInit;
boolean isSimulation, isChangeStatusSimulation;

JSONObject json;

void setup() {
  size(1280, 720);
  surface.setTitle("NeuroMind");
  surface.setIcon(loadImage("Icon.png"));

  background = loadImage("Home.png");
  alert = loadImage("Alert.png");
  alertPort = loadImage("AlertPort.png");
  splash = loadImage("Splash.png");

  try {
    json = loadJSONObject("data.json");
    serialPort = json.getString("portSerial");
    oscIP = json.getString("ipOSC");
    sendPort = json.getInt("portOSC");
  } 
  catch (Exception e) {
    json = new JSONObject();
    json.setString("portSerial", " ");
    json.setString("ipOSC", "127.0.0.1");
    json.setInt("portOSC", 7000);
    saveJSONObject(json, "data/data.json");
  }

  attentionWidget = new SampleWidget(100, true, 100);
  meditationWidget = new SampleWidget(100, true, 100);

  for (int i = 0; i<mindWaveFrequenciesWidget.length; i++) {
    mindWaveFrequenciesWidget[i] = new SampleWidget(100, true, 1000);
  }

  oscP5 = new OscP5(this, 1);
  myRemoteLocation = new NetAddress(oscIP, sendPort);
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
    ChangeOSCSend();
    simulate(); //Simulation Sensor's Values
  } else {
    Splash();
  }
}
