import 'package:intl/intl.dart';

String getFormattedDateTime(DateTime dt, String pattern){
  return DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch));
}

String getFormattedDateTimeNum(num dt, String pattern){
  return DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(dt.toInt()));
}