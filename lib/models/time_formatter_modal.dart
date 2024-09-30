import 'package:flutter/material.dart';

class TimeFormatterModal {
  static String format(String inputTime, BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.parse(inputTime));

    return TimeOfDay.fromDateTime(time).format(context);
  }

  static String formatTimeForSentAndReadMessage(
      String time, BuildContext context) {
    DateTime input = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    DateTime now = DateTime.now();
    if (input.year == now.year &&
        input.month == now.month &&
        input.day == now.day) {
      return '${TimeOfDay.fromDateTime(input).format(context)} Today';
    } else if (input.year == now.year &&
        input.month == now.month &&
        input.day == now.subtract(Duration(days: 1)).day) {
      return '${TimeOfDay.fromDateTime(input).format(context)} Yesterday';
    } else {
      return '${TimeOfDay.fromDateTime(input).format(context)} on ${input.day} ${getMonth(input)}, ${input.year}';
    }
  }

  static String formatForMessageTimeOnChatCard(
      String time, BuildContext context) {
    DateTime inputTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    DateTime currentTime = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(inputTime).format(context);
    if (currentTime.year == inputTime.year &&
        currentTime.month == inputTime.month &&
        currentTime.day == inputTime.day) {
      return formattedTime;
    }

    return inputTime.year == currentTime.year
        ? '$formattedTime - ${inputTime.day} ${getMonth(inputTime)}'
        : '$formattedTime - ${inputTime.day} ${getMonth(inputTime)} ${inputTime.year}';
  }

  static String formatForProfileLastSeenAtChatScreen(
      String time, BuildContext context) {
    DateTime inputTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    DateTime currentTime = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(inputTime).format(context);
    if (currentTime.year == inputTime.year &&
        currentTime.month == inputTime.month &&
        currentTime.day == inputTime.day) {
      return '$formattedTime';
    }

    // yesterday
    else if ((currentTime.difference(inputTime).inHours / 24).round() == 1) {
      return '$formattedTime';
    } else {
      return '$formattedTime on ${inputTime.day} ${getMonth(inputTime)}';
    }
  }

  static String formatForShowingAccountCreationDate(
      String time, BuildContext context) {
    DateTime inputTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    DateTime currentTime = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(inputTime).format(context);

    return '${inputTime.day} ${getMonth(inputTime)}, ${inputTime.year}';
  }

  static String getMonth(DateTime time) {
    switch (time.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'no date';
    }
  }
}
