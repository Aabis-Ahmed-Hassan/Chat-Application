import 'package:flutter/material.dart';

class TimeFormatterModal {
  static String format(String inputTime, BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.parse(inputTime));

    return TimeOfDay.fromDateTime(time).format(context);
  }
}
