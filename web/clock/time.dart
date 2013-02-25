library time;

class Time implements Comparable {
  
  int hour;
  int minute;
  int second;
  
  Time.now() : this.fromDateTime(new DateTime.now());
  
  Time.fromTime(Time time) {
    hour = time.hour;
    minute = time.minute;
    second = time.second;
  }
  
  Time.fromDateTime(DateTime time) {
    hour = time.hour;
    minute = time.minute;
    second = time.second;
  }
  
  Time.fromString(String timeStr) {
    List<String> splitted = timeStr.split(':');
    hour = splitted.length > 0 ? int.parse(splitted[0]) : 0;
    minute = splitted.length > 1 ? int.parse(splitted[1]) : 0;
    second = splitted.length > 2 ? int.parse(splitted[2]) : 0;
  }
  
  Time addSeconds(int addedSeconds) {
    DateTime date = new DateTime(1000, 1, 1, hour, minute, second + addedSeconds);
    return new Time.fromDateTime(date);
  }
  
  int toSeconds() {
    return hour * Duration.SECONDS_PER_HOUR + minute * Duration.SECONDS_PER_MINUTE + second;
  }
  
  String toString() {
    String h = (hour <= 9) ? '0$hour' : '$hour';
    String m = (minute <= 9) ? '0$minute' : '$minute';
    String s = (second <= 9) ? '0$second' : '$second';
    return '$h:$m:$s';
  }
  
  int compareTo(Time other) {
    if (other == null) return 1;
    return toSeconds().compareTo(other.toSeconds());
  }
}

