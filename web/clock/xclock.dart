import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';
import 'time.dart';

class Clock extends WebComponent {
  
  static const int TOTAL_WIDTH = 320;
  
  static const int BACKGROUND_RADIUS = TOTAL_WIDTH ~/ 2;
  
  static const int TICK_OUTER_RADIUS = BACKGROUND_RADIUS - 10;
  static const int TICK_HOUR_LENGTH = 50;
  static const int TICK_HOUR_THICKNESS = 7;
  static const int TICK_MINUTE_LENGTH = 30;
  static const int TICK_MINUTE_THICKNESS = 2;
  
  static const int POINTER_HOUR_LENGTH = 70;
  static const int POINTER_HOUR_THICKNESS = 16;
  static const int POINTER_HOUR_OFFSET = 18;
  static const int CENTRAL_RING_RADIUS = 6;
  
  static const int POINTER_MINUTE_LENGTH = 98;
  static const int POINTER_MINUTE_THICKNESS = 10;
  static const int POINTER_MINUTE_OFFSET = 20;
  
  static const int POINTER_SECOND_LENGTH = 98;
  static const int POINTER_SECOND_THICKNESS = 3;
  static const int POINTER_SECOND_OFFSET = 20;
  static const int POINTER_SECOND_HOOK_RADIUS = 1;
  static const int POINTER_SECOND_RING_CENTER = 72;
  static const int POINTER_SECOND_RING_RADIUS = 8;
  
  static num HOUR_PER_HALF_DAY_ANGLE_RAD = 4 * PI / Duration.HOURS_PER_DAY;
  static num MINUTE_PER_HALF_DAY_ANGLE_RAD = 4 * PI / Duration.MINUTES_PER_DAY;
  static num SECOND_PER_HALF_DAY_ANGLE_RAD = 4 * PI / Duration.SECONDS_PER_DAY;
  static num MINUTE_PER_HOUR_ANGLE_RAD = 2 * PI / Duration.MINUTES_PER_HOUR;
  static num SECOND_PER_HOUR_ANGLE_RAD = 2 * PI / Duration.SECONDS_PER_HOUR;
  static num SECOND_PER_MINUTE_ANGLE_RAD = 2 * PI / Duration.SECONDS_PER_MINUTE;
  
  static const String WHITE = "white";
  static const String BLACK = "black";
  static const int SHADOW_OFFSET = 2;
  static const int SHADOW_BLUR = 7;
  
  Time _time = new Time.now();
  
  Time get time => _time;
  set time(Time value) {
    if (_time != null && _time.compareTo(value) != 0) {
      _time = value;
      drawAnalogClock();
    }
  }
  
  void created() {
    super.created();
    drawAnalogClock();
  }

  
  void drawAnalogClock() {
    CanvasElement canvas = this.shadowRoot.query("#canvas")
    ..width = TOTAL_WIDTH
    ..height = TOTAL_WIDTH;
    CanvasRenderingContext2D context = canvas.context2d;
    
    context..clearRect(0, 0, TOTAL_WIDTH, TOTAL_WIDTH)
    ..translate(BACKGROUND_RADIUS, BACKGROUND_RADIUS);
    
    drawBackground(context);
    
    context..fillStyle = WHITE
    ..strokeStyle = WHITE
    ..shadowOffsetX = SHADOW_OFFSET
    ..shadowOffsetY = SHADOW_OFFSET
    ..shadowBlur    = SHADOW_BLUR
    ..shadowColor   = BLACK;
    
    drawTicks(context);
    drawMinutePointer(context);
    drawHourPointer(context);
    drawCentralRing(context);
    drawSecondPointer(context);
  }
  
  void drawBackground(CanvasRenderingContext2D context) {
    context..beginPath()
    ..fillStyle = BLACK
    ..arc(0, 0, BACKGROUND_RADIUS, 0, 2 * PI, false)
    ..fill(); 
  }
  
  
  void drawTicks(CanvasRenderingContext2D context) {
    for (int i = 0; i < 60; i++) {
      num angle = i * MINUTE_PER_HOUR_ANGLE_RAD;
      num cosA = cos(angle);
      num sinA = sin(angle);
      bool isHour = ((i % 5) == 0);
      int tickInnerRadius = TICK_OUTER_RADIUS - (isHour ? TICK_HOUR_LENGTH : TICK_MINUTE_LENGTH);
      
      context..beginPath()
      ..lineWidth = (isHour ? TICK_HOUR_THICKNESS : TICK_MINUTE_THICKNESS)
      ..moveTo(TICK_OUTER_RADIUS * sinA, -TICK_OUTER_RADIUS * cosA)
      ..lineTo(tickInnerRadius * sinA, -tickInnerRadius * cosA)
      ..stroke();
    }
  }
  
  void drawMinutePointer(CanvasRenderingContext2D context) {
    num angle = time.minute * MINUTE_PER_HOUR_ANGLE_RAD + time.second * SECOND_PER_HOUR_ANGLE_RAD;
    num cosA = cos(angle);
    num sinA = sin(angle);
    
    context..beginPath()
    ..lineWidth = (POINTER_MINUTE_THICKNESS)
    ..moveTo(-POINTER_MINUTE_OFFSET * sinA, POINTER_MINUTE_OFFSET * cosA)
    ..lineTo(POINTER_MINUTE_LENGTH * sinA, -POINTER_MINUTE_LENGTH * cosA)
    ..stroke();
  }
  
  void drawHourPointer(CanvasRenderingContext2D context) {
    num angle = time.hour * HOUR_PER_HALF_DAY_ANGLE_RAD + time.minute * MINUTE_PER_HALF_DAY_ANGLE_RAD + time.second * SECOND_PER_HALF_DAY_ANGLE_RAD;
    num cosA = cos(angle);
    num sinA = sin(angle);
    context..beginPath()
    ..lineWidth = (POINTER_HOUR_THICKNESS)
    ..moveTo(-POINTER_HOUR_OFFSET * sinA, POINTER_HOUR_OFFSET * cosA)
    ..lineTo(POINTER_HOUR_LENGTH * sinA, -POINTER_HOUR_LENGTH * cosA)
    ..stroke();
  }
  
  void drawCentralRing(CanvasRenderingContext2D context) {
    context..beginPath()
    ..arc(0, 0, CENTRAL_RING_RADIUS, 0, 2 * PI, false)
    ..fill();
  }
  
  void drawSecondPointer(CanvasRenderingContext2D context) {
    num angleA = time.second * SECOND_PER_MINUTE_ANGLE_RAD;
    num cosA = cos(angleA);
    num sinA = sin(angleA);
    
    context..lineWidth = (POINTER_SECOND_THICKNESS)
    ..beginPath()
    ..moveTo(-POINTER_SECOND_OFFSET * sinA, POINTER_SECOND_OFFSET * cosA)
    ..arc(0, 0, POINTER_SECOND_HOOK_RADIUS, angleA + PI / 2, angleA + 5 * PI / 2, false)
    ..arc(POINTER_SECOND_RING_CENTER * sinA, -POINTER_SECOND_RING_CENTER * cosA, POINTER_SECOND_RING_RADIUS,  angleA + PI / 2, angleA + 5 * PI / 2, false)
    ..moveTo((POINTER_SECOND_RING_CENTER + POINTER_SECOND_RING_RADIUS) * sinA, -(POINTER_SECOND_RING_CENTER + POINTER_SECOND_RING_RADIUS) * cosA)
    ..lineTo(POINTER_SECOND_LENGTH * sinA, -POINTER_SECOND_LENGTH * cosA)
    ..stroke();
  }
}
