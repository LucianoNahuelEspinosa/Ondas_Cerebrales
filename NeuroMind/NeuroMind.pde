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
boolean isChangeIpPort, isInitGUI;

float attention, meditation;
float attenBefore, mediBefore;
float[] mindWaveFrequencies = new float[8];
float[] mindWaveFrequenciesBefore = new float[8];
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

JSONObject json;

void setup() {
  size(1280, 720);
  surface.setTitle("NeuroMind");
  surface.setIcon(loadImage("Icon.png"));

  background = loadImage("Home.png");
  alert = loadImage("Alert.png");
  alertPort = loadImage("AlertPort.png");
  splash = loadImage("Splash.png");

  json = loadJSONObject("data.json");
  serialPort = json.getString("portSerial");
  oscIP = json.getString("ipOSC");
  sendPort = json.getInt("portOSC");

  oscP5 = new OscP5(this, 1);
  myRemoteLocation = new NetAddress(oscIP, sendPort);
}

void draw() {
  background(background);

  if (isAppInit) {
    if (!isInitGUI) {
      InitGUI();
    }

    infoMind(24, 16, 14, 0);  //infoMind("tamaño titulos", "tamaño texto general", tamaño texto direcciones", "color de los textos")
    GetConnection();
    CheckStatusConnection();
    ChangeOSCSend();
  } else {
    Splash();
  }
}
