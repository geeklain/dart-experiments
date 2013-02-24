import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';
import 'time.dart';

class DraggableClock extends WebComponent {
  
  Time currentTime = new Time.now();
  String get currentTimeStr => currentTime.toString();
  set currentTimeStr(String value) {
    currentTime = new Time.fromString(value);
  }
  
  bool _isDragging = false;
  Point _lastPoint;
  Time _lastTime;
  
  void created() {
    super.created();
    Time currentTime = new Time.now();
  }
  
  void onMouseDownHandler(MouseEvent e) {
    _isDragging = true;
    _lastPoint = new Point.fromTopLeft(e.offsetX, e.offsetY);
    _lastTime = currentTime;
  }
  
  void onMouseUpHandler(MouseEvent e) {
    _isDragging = false;
  }
  
  void onMouseMoveHandler(MouseEvent e) {
    if (!_isDragging) return;
    
    Point currentPoint = new Point.fromTopLeft(e.offsetX, e.offsetY);
    num angle = currentPoint.angleTo(_lastPoint);

    currentTime = _lastTime.addSeconds((angle * 1000).toInt());
    _lastTime = currentTime;
    _lastPoint = currentPoint;
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
    num angle = atan2(y, x) - atan2(other.y, other.x);
    if (angle > PI) {
      angle = 2 * PI - angle;
    }
    if (angle < -PI) {
      angle += 2 * PI;
    }
    return angle;
  }
}
