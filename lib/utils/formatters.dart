/// Small helpers that turn raw values into the short labels used in the UI.
class Formatters {
  Formatters._();

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// "now", "40m", "3h", "2d" ...
  static String timeAgo(DateTime time, {DateTime? now}) {
    final Duration diff = (now ?? DateTime.now()).difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }

  /// 640 -> "640", 1200 -> "1.2k", 15000 -> "15k".
  static String compactCount(int value) {
    if (value.abs() < 1000) return '$value';
    final double thousands = value / 1000;
    final String text = thousands >= 10
        ? thousands.toStringAsFixed(0)
        : thousands.toStringAsFixed(1);
    return '${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}k';
  }

  /// "Oct 2026"
  static String monthYear(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
  }

  /// "1 comment", "4 comments"
  static String commentCount(int count) {
    return count == 1 ? '1 comment' : '$count comments';
  }
}
