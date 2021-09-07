import netP5.*;
import oscP5.*;
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;

MindSet mindSet;
String serialPort = "COM3"; //Puerto Saliente

OscP5 oscP5;
NetAddress myRemoteLocation;
int sendPort = 7000; //Puerto para enviar informacion
String oscIP = "127.0.0.1"; //Direccion IP de conexion osc

float atencion, meditacion;
float delta, theta, lowAlpha, highAlpha, lowBeta, highBeta, lowGamma, midGamma;
float xItems = 50;
float yItems = 150;
String estadoMind = "";

String [] direcciones = {"/mindAtencion", "/mindMeditacion", "/mindDelta", "/mindTheta", "/mindLowAlpha", "/mindHightAplha", "/mindLowBeta", "/mindHighBeta", "/mindLowGamma", "/mindMidGamma"};

void setup() {
  size(1024, 800);

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
}

void draw() {
  background(255);

  infoMind(26, 20, 0);  //infoMind("tamanio titulos", "tamanio texto general", "color de los textos")
}
