#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

// I2C pins
#define SDA_PIN 21
#define SCL_PIN 22

// ADXL345 instances (0x53 and 0x1D)
Adafruit_ADXL345_Unified accel1 = Adafruit_ADXL345_Unified(12345, 0x53);
Adafruit_ADXL345_Unified accel2 = Adafruit_ADXL345_Unified(12346, 0x1D);

// Joystick pins
const int pinVRx = 35;  // ADC1_CH7
const int pinVRy = 34;  // ADC1_CH6
const int pinSW  = 18;  // digital button

// UART1 pins
#define ESP32_UART_TX 17
#define ESP32_UART_RX 16

void setup() {
  // USB debug
  Serial.begin(115200);
  delay(1000);
  Serial.println("ESP32 → FPGA streaming demo");

  // I2C init
  Wire.begin(SDA_PIN, SCL_PIN);

  // Init both ADXL345s
  if (!accel1.begin()) {
    Serial.println("ERROR: ADXL345 #1 not found");
    while (1);
  }
  accel1.setRange(ADXL345_RANGE_2_G);

  if (!accel2.begin()) {
    Serial.println("ERROR: ADXL345 #2 not found");
    while (1);
  }
  accel2.setRange(ADXL345_RANGE_2_G);

  // Joystick switch pull-up
  pinMode(pinSW, INPUT_PULLUP);

  // UART1 for FPGA (8N1, 115200)
  Serial1.begin(115200, SERIAL_8N1, ESP32_UART_RX, ESP32_UART_TX);
}

void loop() {
  sensors_event_t e1, e2;
  accel1.getEvent(&e1);
  accel2.getEvent(&e2);

  int xJ = analogRead(pinVRx);
  int yJ = analogRead(pinVRy);
  int btn = (digitalRead(pinSW) == LOW) ? 1 : 0;

  // Format: ax1,ay1,az1;ax2,ay2,az2;Jx,Jy,Btn\n
  Serial1.printf(
    "%.2f,%.2f,%.2f;%.2f,%.2f,%.2f;%d,%d,%d\n",
    e1.acceleration.x, e1.acceleration.y, e1.acceleration.z,
    e2.acceleration.x, e2.acceleration.y, e2.acceleration.z,
    xJ, yJ, btn
  );

  delay(10);  // 100 Hz update
}
