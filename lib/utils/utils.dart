import 'package:flutter/material.dart';

class Utils {
  static showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        duration: Duration(seconds: 2),
        content: Text(msg),
      ),
    );
  }

  static showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
