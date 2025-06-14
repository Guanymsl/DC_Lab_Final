#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

// I2C 腳位
#define SDA_PIN 8
#define SCL_PIN 9

// 高通濾波係數 (0 < α < 1)：α 越大，對重力抑制越強，但動態響應越慢
const float alpha = 0.95;  

Adafruit_ADXL345_Unified accel(12345);

// 前一次讀值與前一次濾波值，用於 IIR
float prev_raw_x = 0, prev_raw_y = 0, prev_raw_z = 0;
float prev_filt_x = 0, prev_filt_y = 0, prev_filt_z = 0;

void setup() {
  Serial.begin(115200);
  Wire.begin(SDA_PIN, SCL_PIN);

  if (!accel.begin()) {
    Serial.println("ADXL345 init failed!");
    while (1) delay(10);
  }
  accel.setRange(ADXL345_RANGE_2_G);
  Serial.println("ADXL345 Dynamic Acceleration (High-pass) Ready");
}

void loop() {
  sensors_event_t ev;
  accel.getEvent(&ev);

  // 原始量測 (含重力 + 動態)
  float raw_x = ev.acceleration.x;
  float raw_y = ev.acceleration.y;
  float raw_z = ev.acceleration.z;

  // 一階高通 IIR 濾波器：
  // filt[n] = α * (filt[n−1] + raw[n] − raw[n−1])
  float filt_x = alpha * (prev_filt_x + raw_x - prev_raw_x);
  float filt_y = alpha * (prev_filt_y + raw_y - prev_raw_y);
  float filt_z = alpha * (prev_filt_z + raw_z - prev_raw_z);

  // 更新狀態
  prev_raw_x  = raw_x;   prev_raw_y  = raw_y;   prev_raw_z  = raw_z;
  prev_filt_x = filt_x;  prev_filt_y = filt_y;  prev_filt_z = filt_z;

  // 輸出「動態加速度」(m/s^2)
  Serial.printf("dX:%+6.3f  dY:%+6.3f  dZ:%+6.3f\n", filt_x, filt_y, filt_z);

  delay(100);
}
