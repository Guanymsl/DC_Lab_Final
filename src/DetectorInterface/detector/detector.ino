#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

// I2C pins
#define SDA_PIN 8
#define SCL_PIN 9

// Joystick pins
#define VX_PIN 1
#define VY_PIN 2
#define SW_PIN 3

#define UART_TX 17
#define UART_RX 16

const float alpha = 0.95;

Adafruit_ADXL345_Unified accel(12345);

float prev_raw_x = 0, prev_raw_y = 0, prev_raw_z = 0;
float prev_filt_x = 0, prev_filt_y = 0, prev_filt_z = 0;

// UART1 pins
// #define ESP32_UART_TX 17
// #define ESP32_UART_RX 16

void setup() {
    Serial.begin(115200);
    Wire.begin(SDA_PIN, SCL_PIN);

    if (!accel.begin()) {
        Serial.println("ADXL345 init failed!");
        while (1) delay(10);
    }
    accel.setRange(ADXL345_RANGE_2_G);

    pinMode(SW_PIN, INPUT_PULLUP);
    analogReadResolution(12);        // 12 bits resolution (0~4095)
    analogSetAttenuation(ADC_11db);

    // UART1 for FPGA (8N1, 115200)
    // Serial1.begin(115200, SERIAL_8N1, ESP32_UART_RX, ESP32_UART_TX);

    Serial1.begin(115200, SERIAL_8N1, UART_RX, UART_TX);
}

void loop() {
    sensors_event_t ev;
    accel.getEvent(&ev);

    // Raw (static acceleration)
    float raw_x = ev.acceleration.x;
    float raw_y = ev.acceleration.y;
    float raw_z = ev.acceleration.z;

    // Derivative (dynamic acceleration)
    float filt_x = alpha * (prev_filt_x + raw_x - prev_raw_x);
    float filt_y = alpha * (prev_filt_y + raw_y - prev_raw_y);
    float filt_z = alpha * (prev_filt_z + raw_z - prev_raw_z);

    // Update
    prev_raw_x  = raw_x;   prev_raw_y  = raw_y;   prev_raw_z  = raw_z;
    prev_filt_x = filt_x;  prev_filt_y = filt_y;  prev_filt_z = filt_z;

    // Serial.printf("X:%+6.3f   Y:%+6.3f   Z:%+6.3f\n", raw_x, raw_y, raw_z);
    // Serial.printf("dX:%+6.3f  dY:%+6.3f  dZ:%+6.3f\n", filt_x, filt_y, filt_z);

    int x = analogRead(VX_PIN);
    int y = analogRead(VY_PIN);
    int sw = digitalRead(SW_PIN);

    // Serial.printf("rX=%4d     rY=%4d     SW=%d\n", x, y, sw==LOW ? 0 : 1);

    bool right = (y < 1000);
    bool left = (y > 3000);
    bool jump = (x < 1000);
    bool squat = (x > 3000);

    bool attack = (filt_y > 10);
    bool defend = (raw_x > 8);

    bool select = 1 - sw;

    if (defend) attack = false;

    Serial.printf("R = %d, L = %d, J = %d, Q = %d, A = %d, D = %d, S = %d\n", right, left, jump, squat, attack, defend, select);

    uint8_t packet = 0;
    packet |= right  << 0;
    packet |= left   << 1;
    packet |= jump   << 2;
    packet |= squat  << 3;
    packet |= attack << 4;
    packet |= defend << 5;
    packet |= select << 6;

    Serial1.write(packet);

    delay(13);
}
