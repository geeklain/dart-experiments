import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watchers;

class RealTimeClock extends WebComponent {
   
  String currentTimeStr = 'HH:MM:SS';
  DateTime currentTime = new DateTime.now();
  
  
  void created() {
    super.created();
    updateClock();
  }
  
  void updateClock() {
    updateRealTime();
    scheduleNextUpdate();
  }
  
  String formatTime(int h, int m, int s, int ms) {
    String minute = (m <= 9) ? '0$m' : '$m';
    String second = (s <= 9) ? '0$s' : '$s';
    String milliseconds = (ms <= 9) ? '00$ms' : (ms <= 99) ? '0$ms' : '$ms';
    return '$h:$minute:$second:$milliseconds';
  }
  
  void scheduleNextUpdate() {
    int nextUpdate = Duration.MILLISECONDS_PER_SECOND - new DateTime.now().millisecond + 1;
    
    new Timer(new Duration(milliseconds: nextUpdate), updateClock);
  }
  
  void updateRealTime() {
    currentTime = new DateTime.now();
    currentTimeStr = formatTime(currentTime.hour, currentTime.minute, currentTime.second, currentTime.millisecond);
    // manually call the dispatch https://github.com/dart-lang/web-ui/issues/156
    watchers.dispatch();
  }
  
}
