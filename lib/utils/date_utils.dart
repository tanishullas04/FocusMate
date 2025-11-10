import 'package:intl/intl.dart';

String formatDate(DateTime d) => DateFormat.yMMMd().add_jm().format(d);
String formatDateOnly(DateTime d) => DateFormat.yMMMMd().format(d);
