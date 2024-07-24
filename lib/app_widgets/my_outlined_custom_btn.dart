import 'package:flutter/material.dart';

import '../utils/util_helper.dart';

class MyOutlinedCustomBtn extends StatelessWidget {
  VoidCallback? onPressed;
  String title;
  double mWidth;

  MyOutlinedCustomBtn({
    required this.title,
    required this.onPressed,
    this.mWidth = 140,
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mWidth,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: mTextStyle16(),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: BorderSide(width: 1.0, color: Colors.blue),
        ),
      ),
    );
  }
}
