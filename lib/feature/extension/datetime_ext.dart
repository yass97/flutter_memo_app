import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format({String format = 'yyyy/MM/dd HH:mm'}) {
    return DateFormat(format).format(this);
  }
}
