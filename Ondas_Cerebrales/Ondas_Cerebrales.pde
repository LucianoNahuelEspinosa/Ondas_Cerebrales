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
boolean isChangeIpPort;

float atencion, meditacion;
float delta, theta, lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, midGamma;
float xItems = 75;
float yItems = 160;
String estadoMind = "Desconectado";
color[] colorsStatus = {color(150), color(255, 0, 0), color(0, 255, 0), color(50)};
int indexColorsStatus;
PImage alert, alertPort;
boolean isAlertPort;

String [] direcciones = {"/mindAtencion", "/mindMeditacion", "/mindDelta", "/mindTheta", "/mindLowAlpha", "/mindHighAlpha", "/mindLowBeta", "/mindHighBeta", "/mindLowGamma", "/mindMidGamma"};

PImage background;

void setup() {
  size(1280, 720);
  background = loadImage("Home.png");
  alert = loadImage("Alert.png");
  alertPort = loadImage("AlertPort.png");
  oscP5 = new OscP5(this, 6969);
  myRemoteLocation = new NetAddress(oscIP, sendPort);
  InitGUI();
}

void draw() {
  background(background);

  infoMind(24, 16, 14, 0);  //infoMind("tamaño titulos", "tamaño texto general", tamaño texto direcciones", "color de los textos")
  CheckStatusConnection();
  ChangeOSCSend();
}
