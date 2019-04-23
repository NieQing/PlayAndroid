class TimeUtil {
  static String readTimestamp(int targetTime) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.fromMillisecondsSinceEpoch(targetTime);
    Duration duration = now.difference(time);

    if (duration.inDays > 0) {
      return '${duration.inDays}天前';
    }

    if (duration.inHours > 0) {
      return '${duration.inHours}小时前';
    }

    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}分钟前';
    }

    if (duration.inSeconds > 0) {
      return '${duration.inSeconds}秒前';
    }

    return '';
  }
}
