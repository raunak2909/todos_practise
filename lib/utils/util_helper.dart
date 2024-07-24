import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle mTextStyle16(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
    fontSize: 16,
    fontWeight: mFontWeight,
    color: mColor,
    fontFamily: 'mainFont'
  );
}

TextStyle mTextStyle12(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 12,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}

TextStyle mTextStyle22(
    {Color mColor = Colors.black,
      mFontWeight = FontWeight.normal}){
  return TextStyle(
      fontSize: 22,
      fontWeight: mFontWeight,
      color: mColor,
      fontFamily: 'mainFont'
  );
}