---
description: Por Luciano Nahuel Espinosa
---

# Ondas Cerebrales

**Palabras Clave:** EEG, Ondas cerebrales, OSC

{% tabs %}
{% tab title="Conocimientos" %}
* Conocimiento básico en programación orientado a objetos
* Conocimiento básico en el protocolo de comunicación Open Sound Control (OSC)
{% endtab %}

{% tab title="Requerimientos" %}
Software

* Processing
* Librería de Mindset Processing

Hardware

* Neurosky Mindwave mobile 2
* Computadora con bluetooth
{% endtab %}

{% tab title="Links" %}
{% embed url="https://processing.org" %}

{% embed url="https://github.com/LucianoNahuelEspinosa/Ondas_Cerebrales" %}
{% endtab %}
{% endtabs %}

## Detección de ondas cerebrales

Las ondas cerebrales son ondas que emite nuestro cerebro todo el tiempo y dependiendo el estado de tu cerebro emite diferentes frecuencias en los diferentes tipos de ondas. Para detectar las ondas cerebrales hay dispositivos de detección denominados **Electroencefalograma (EEG)**, esto permite visual las frecuencias de las ondas cerebrales.

### Tipos de ondas cerebrales

Los tipos de ondas cerebrales que emite el cuerpo humano son:

* Delta
* Theta
* Alpha
* Beta
* Gamma

### Software

Se ha desarrollado un software capaz de detectar las ondas cerebrales del sernsor EGG **Neurosky Mindwave mobile 2**, que permite no solo obtener las frecuencias de las ondas cerebrales ya mencionadas sino también agrega variantes como Low Alpha, Mid Gamma, etc, y también agrega niveles de atención y meditación, que son el punto fuerte de este sensor, que hace un calculo entre las diferentes ondas para saber si el usuario está relajado o esta muy atento.


El software, denominado NeuroMind, fue desarrollado en el entorno de programación Processing, utilizando la librería Mindset Processing para la detección de las ondas cerebrales y oscP5 para la comunicación OSC. El software permite conectar con el sensor, visualizar los valores en números y en formato de gráfico, y permite añadir, modificar y eliminar direcciones ip y puertos para la conexión OSC, además permite crear, modificar y eliminar, direcciones OSC personalizadas y hacer mapeo de los valores de las mediciones.

#### Como vincular el sensor con el software

Para que el software pueda detectar las ondas cerebrales desde el dispositivo se necesita que la computadora tenga **Bluetooth**, vincular el sensor con la computadora y poner el puerto serial correspondiente en el software.

Dependiendo del sistema operativo los puertos serial varian e incluso en algunos figuran dos puertos serial con el nombre del sensor, un entrante y otro saliente, en el software hay que poner el puerto serial saliente.

**Obtener puerto serial**

* Windows 10

Ir a configuración -> dispositivos -> Más opciones de Bluetooth, les abrirá una ventana y tienen que ir a la pestaña Puertos COM. En el caso que no les aparezca nada, tiene que hacer clic en Agregar, seleccionan la opción saliente y en el campo de selección seleccionan el dispositivo y le dan a Aceptar (Tienen que hacer esto con el sensor y el bluetooth encendido).

* Mac OS

Los puertos seriales para este sistema operativo pueden ser **/dev/cu.MindWaveMobile-DevA** o **/dev/cu.MindSet-DevB**.

* Linux

Descargar el software Bluetooth Manager y ahí le debe decir el puerto del sensor.

## Descargas

**Código fuente**

{% embed url="https://github.com/LucianoNahuelEspinosa/Ondas_Cerebrales" %}

**Ejecutables**

* [Windows (64 bits)](https://drive.google.com/file/d/1pPv6eD7bbp1vdy8kbWvpjCb2NTqlRt6b/view?usp=sharing)
* [Linux (64 bits)](https://drive.google.com/file/d/1y24tR63k4sxq19a0M5-Rr5Z-PMzquRmT/view?usp=sharing)

**Librería MindSet Processing**

{% embed url="http://jorgecardoso.eu/processing/MindSetProcessing/" %}
