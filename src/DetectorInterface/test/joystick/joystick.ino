// 定義腳位
const int vrxPin = 1;   // ADC1_CHANNEL_0 => GPIO1
const int vryPin = 2;   // ADC1_CHANNEL_1 => GPIO2
// const int swPin  = 3;   // 數位輸入腳位

void setup() {
  Serial.begin(115200);
  // pinMode(swPin, INPUT_PULLUP);      // 按鈕通常接地，使用內部上拉
  analogReadResolution(12);                // 12 位元解析度 (0~4095)
  analogSetAttenuation(ADC_11db);     // 量測範圍 0~950 mV，如需更高請改 ADC_11db
}

void loop() {
  int x = analogRead(vrxPin);
  int y = analogRead(vryPin);
  // int sw = digitalRead(swPin);

  Serial.printf("X=%4d, Y=%4d\n", x, y);
  //Serial.printf("X=%4d, Y=%4d, SW=%d\n", x, y, sw==LOW ? 0 : 1);

  delay(100);
}
