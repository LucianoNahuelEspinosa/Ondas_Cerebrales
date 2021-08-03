import processing.serial.*;

Serial serial;

void setup() {
  size(800, 600);

  String portName = Serial.list()[1];
  println(portName);
  serial = new Serial(this, portName, 9600);
}

void draw() {
  background(255);

  if ( serial.available() > 0) {
    byte[] recive = serial.readBytesUntil(1);

    println(recive);
  }
}
