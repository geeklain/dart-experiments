import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';
import 'time.dart';

class DraggableClock extends WebComponent {
  
  static const int DRAGGING_NONE = 0;
  static const int DRAGGING_SECOND = 1;
  static const int DRAGGING_MINUTE = 2;
  static const int DRAGGING_HOUR = 3;
  
  Time currentTime = new Time.now();
  String get currentTimeStr => currentTime.toString();
  set currentTimeStr(String value) {
    currentTime = new Time.fromString(value);
  }
  
  int _isDragging = DRAGGING_NONE;
  
  void created() {
    super.created();
    Time currentTime = new Time.now();
  }
  
  void onMouseDownHandler(MouseEvent e) {
    Point currentPoint = new Point.fromTopLeft(e.offsetX, e.offsetY);
    _isDragging = getPointerUnderPoint(currentPoint);
  }
  
  void onMouseUpHandler(MouseEvent e) {
    _isDragging = DRAGGING_NONE;
  }
  
  void onMouseMoveHandler(MouseEvent e) {
    if (_isDragging == DRAGGING_NONE) return;
    
    Point currentPoint = new Point.fromTopLeft(e.offsetX, e.offsetY);
    num mouseAngle = atan2(currentPoint.x, - currentPoint.y);
    if (mouseAngle < 0) {
      mouseAngle += 2 * PI;
    }
    
    Time newTime = new Time.fromTime(currentTime);
    switch (_isDragging) {
      case DRAGGING_SECOND:
        newTime.second = (mouseAngle * 60 / (2 * PI)).toInt();
        if (currentTime.second > 50 && newTime.second < 10) {
          newTime = newTime.addSeconds(60);
        }
        else if (currentTime.second < 10 && newTime.second > 50) {
          newTime = newTime.addSeconds(-60);
        }
        break;
      case DRAGGING_MINUTE:
        newTime.second = (mouseAngle * 60 * 60 / (2 * PI)).toInt() % 60;
        newTime.minute = (mouseAngle * 60 / (2 * PI)).toInt();
        if (currentTime.minute > 50 && newTime.minute < 10) {
          newTime = newTime.addSeconds(3600);
        }
        else if (currentTime.minute < 10 && newTime.minute > 50) {
          newTime = newTime.addSeconds(-3600);
        }
        break;
      case DRAGGING_HOUR:
        newTime.second = (mouseAngle * 12 * 60 * 60 / (2 * PI)).toInt() % 60;
        newTime.minute = (mouseAngle * 12 * 60 / (2 * PI)).toInt() % 60;
        newTime.hour = (mouseAngle * 12 / (2 * PI)).toInt() + (currentTime.hour > 12 ? 12 : 0);
        if (currentTime.hour > 10 && newTime.hour < 2 || currentTime.hour < 2 && newTime.hour > 10) {
          newTime.hour += 12;
        }
        else if (currentTime.hour > 22 && newTime.hour < 14 || currentTime.hour < 14 && newTime.hour > 22) {
          newTime.hour -= 12;
        }
        break;
    }
    currentTime = newTime;
  }
  
  void onScrollHandler(WheelEvent e) {
    e.preventDefault();
    int dx = -e.deltaX;
    int dy = e.deltaY;
    bool isPositive = (dy > 0) || (dy == 0 && dx > 0);
    int delta = ((isPositive ? 1 : -1) * sqrt(dx * dx + dy * dy)).toInt();
    currentTime = currentTime.addSeconds(delta);
  }
  
  int getPointerUnderPoint(Point point) {
    num clickAngle = atan2(point.x, - point.y);
    if (clickAngle < 0) {
      clickAngle += 2 * PI;
    }
    
    num errorMargin = 0.03;
    num lowerBound = clickAngle - 2 * PI * errorMargin;
    num higherBound = clickAngle + 2 * PI * errorMargin;
    
    num secondAngle = currentTime.second * 2 * PI / 60;

    if (lowerBound < secondAngle && secondAngle < higherBound) {
      return DRAGGING_SECOND;
    }
    
    num minuteAngle = currentTime.minute * 2 * PI / 60 + secondAngle / 60;
    if (lowerBound < minuteAngle && minuteAngle < higherBound) {
      return DRAGGING_MINUTE;
    }
    
    num hourAngle = (currentTime.hour % 12) * 2 * PI / 12 + minuteAngle / 12;
    if (lowerBound < hourAngle && hourAngle < higherBound) {
      return DRAGGING_HOUR;
    }
    return DRAGGING_NONE;
  }
  
}

class Point {
  static const int CLOCK_CENTER = 160;
  
  final int x, y;

  Point(this.x, this.y);
  Point.zero() : x = 0, y = 0;
  Point.fromTopLeft(int x, int y) : this.x = x - CLOCK_CENTER, this.y = y - CLOCK_CENTER;

  num distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
  
  num angleTo(Point other) {
    // atan2(x, y) gives the anticlockwise angle between the y-axis and the vector(x, y)
    num angle = atan2(x, y) - atan2(other.x, other.y);
    if (angle > PI) {
      angle = 2 * PI - angle;
    }
    if (angle < -PI) {
      angle += 2 * PI;
    }
    return angle;
  }
}
