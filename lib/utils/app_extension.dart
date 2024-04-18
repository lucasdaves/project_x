import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime? formatDatetime() {
    try {
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(this);
      return dateTime;
    } catch (error) {
      return null;
    }
  }
}

extension DateTimeExtension on DateTime {
  String? formatString() {
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      String formattedDate = dateFormat.format(this);
      return formattedDate;
    } catch (error) {
      return null;
    }
  }
}
