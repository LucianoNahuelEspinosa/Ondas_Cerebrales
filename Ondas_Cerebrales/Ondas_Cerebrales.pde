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

GTextField portText, ipText;
boolean isChangeIpPort;

float atencion, meditacion;
float delta, theta, lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, midGamma;
float xItems = 75;
float yItems = 150;
String estadoMind = "";

String [] direcciones = {"/mindAtencion", "/mindMeditacion", "/mindDelta", "/mindTheta", "/mindLowAlpha", "/mindHighAlpha", "/mindLowBeta", "/mindHighBeta", "/mindLowGamma", "/mindMidGamma"};

PImage background;

void setup() {
  size(1280, 720);

  background = loadImage("Home.png");

  try {
    mindSet = new MindSet(this, serialPort);
    estadoMind = "Conectado";
  } 
  catch (Exception e) {
    println(e);
    estadoMind = "Error al conectar";
  }

  oscP5 = new OscP5(this, 6969);
  myRemoteLocation = new NetAddress(oscIP, sendPort);

  ipText = new GTextField(this, width/2+xItems+190, yItems-25, 200, 20);
  ipText.tag = "IpAddress";
  ipText.setPromptText("Direccion IP");
  ipText.setText(oscIP);

  portText = new GTextField(this, width/2+xItems+215, yItems-10+35, 200, 20);
  portText.tag = "portNumber";
  portText.setPromptText("Puerto");
  portText.setText(str(sendPort));
}

void draw() {
  background(background);

  infoMind(26, 18, 16, 0);  //infoMind("tamaño titulos", "tamaño texto general", tamaño texto direcciones", "color de los textos")
  ChangeOSCSend();
}
