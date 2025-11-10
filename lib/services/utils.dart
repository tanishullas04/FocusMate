import 'package:intl/intl.dart';

String formatDate(DateTime d) {
  return DateFormat.yMMMd().add_jm().format(d);
}

String formatDateOnly(DateTime d) {
  return DateFormat.yMMMMd().format(d);
}
