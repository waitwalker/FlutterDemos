/// 毫秒转时分秒如 01:12:23
String toHMS(int microsecond) {
  int minutesPerHour = 60;
  int secondsPerMinute = 60;
  int microsecondsPerSecond = 1000;
  int microsecondsPerMillisecond = 1000;
  int inMilliseconds = microsecond ~/ microsecondsPerMillisecond;
  int inSeconds = inMilliseconds ~/ microsecondsPerSecond;
  int inMinutes = inSeconds ~/ secondsPerMinute;
  int inHours = inMinutes ~/ minutesPerHour;
  // String sixDigits(int n) {
  //     if (n >= 100000) return "$n";
  //     if (n >= 10000) return "0$n";
  //     if (n >= 1000) return "00$n";
  //     if (n >= 100) return "000$n";
  //     if (n >= 10) return "0000$n";
  //     return "00000$n";
  //   }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  // if (inMicroseconds < 0) {
  //   return "-${-this}";
  // }
  String twoDigitMinutes = twoDigits(inMinutes.remainder(minutesPerHour));
  String twoDigitSeconds = twoDigits(inSeconds.remainder(secondsPerMinute));
  // String sixDigitUs =
  //     sixDigits(inMicroseconds.remainder(microsecondsPerSecond));
  if (inHours == 0) {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  return "$inHours:$twoDigitMinutes:$twoDigitSeconds";
}

String secToHMS(second) => toHMS(second * 1000 * 1000);
