#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

// -----------------------------------------------------------------------------
//   ADXL345 定義
// -----------------------------------------------------------------------------
// 第一顆 ADXL345：SDO 接地 ⇒ I2C 地址 0x53
// 第二顆 ADXL345：SDO 接 3.3V ⇒ I2C 地址 0x1D
#define ADXL1_ADDR  0x53
#define ADXL2_ADDR  0x1D

// 使用非 Unified 版的 Adafruit_ADXL345
Adafruit_ADXL345_h adxl1 = Adafruit_ADXL345();
Adafruit_ADXL345_h adxl2 = Adafruit_ADXL345();

// -----------------------------------------------------------------------------
//   Joystick 定義
// -----------------------------------------------------------------------------
// 假設搖桿 X → GPIO32 (ADC1_CH0)，Y → GPIO33 (ADC1_CH1)，按鈕 → GPIO25
#define JOY_X_PIN    32
#define JOY_Y_PIN    33
#define JOY_BTN_PIN  25

void setup() {
  Serial.begin(115200);
  while (!Serial) { delay(10); }

  // 初始化 I²C（ESP32-S3 預設 SDA=21, SCL=22）
  Wire.begin();

  // 初始化 ADXL345 1
  if (! adxl1.begin(ADXL1_ADDR)) {
    Serial.println("錯誤：無法初始化 ADXL345 #1 (0x53)。請檢查接線！");
    while (1) delay(10);
  }
  // 設定範圍 ±2g、輸出速率 100 Hz
  adxl1.setRange(ADXL345_RANGE_2_G);
  adxl1.setDataRate(ADXL345_DATARATE_100_HZ);

  // 初始化 ADXL345 2
  if (! adxl2.begin(ADXL2_ADDR)) {
    Serial.println("錯誤：無法初始化 ADXL345 #2 (0x1D)。請檢查接線！");
    while (1) delay(10);
  }
  adxl2.setRange(ADXL345_RANGE_2_G);
  adxl2.setDataRate(ADXL345_DATARATE_100_HZ);

  Serial.println("兩顆 ADXL345 初始化完成。");

  // 初始化 Joystick 按鈕（使用內部上拉）
  pinMode(JOY_BTN_PIN, INPUT_PULLUP);
  // ADC 腳位可直接 analogRead(JOY_X_PIN) / analogRead(JOY_Y_PIN)
  delay(10);
  Serial.println("Joystick 初始化完成。");
  Serial.println();
}

void loop() {
  // 讀取並顯示 ADXL345 #1
  readADXL(adxl1, 1);

  // 讀取並顯示 ADXL345 #2
  readADXL(adxl2, 2);

  // 讀取並顯示 Joystick
  readJoystick();

  Serial.println("----------------------------------------");
  delay(200);
}

// -----------------------------------------------------------------------------
//  讀取單顆 ADXL345 (x, y, z) 並印出 (m/s²)
// -----------------------------------------------------------------------------
void readADXL(Adafruit_ADXL345 &sensor, int sensorId) {
  sensors_event_t event;
  sensor.getEvent(&event);

  Serial.print("ADXL");
  Serial.print(sensorId);
  Serial.print(": X=");
  Serial.print(event.acceleration.x, 3);
  Serial.print(" m/s^2, Y=");
  Serial.print(event.acceleration.y, 3);
  Serial.print(" m/s^2, Z=");
  Serial.print(event.acceleration.z, 3);
  Serial.println(" m/s^2");
}

// -----------------------------------------------------------------------------
//  讀取 Joystick (X, Y, 按鈕) 並印出
// -----------------------------------------------------------------------------
void readJoystick() {
  int rawX = analogRead(JOY_X_PIN);  // 0 ~ 4095 (12-bit ADC)
  int rawY = analogRead(JOY_Y_PIN);
  float pctX = (rawX / 4095.0f) * 100.0f;
  float pctY = (rawY / 4095.0f) * 100.0f;

  bool btnPressed = (digitalRead(JOY_BTN_PIN) == LOW);

  Serial.print("Joystick: X_ADC=");
  Serial.print(rawX);
  Serial.print(" ("); Serial.print(pctX, 1); Serial.print("%)");
  Serial.print(", Y_ADC=");
  Serial.print(rawY);
  Serial.print(" ("); Serial.print(pctY, 1); Serial.print("%)");
  Serial.print(", Button=");
  Serial.println(btnPressed ? "PRESSED" : "RELEASED");
}
