import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  MediaQueryData? _queryData;
  static var screenWidth;
  static var screenHeight;
  static var safeScreenWidth;
  static var safeScreenHeight;
  static var _safeAreaHorizontal;
  static var _safeAreaVertical;
  static var blockSizeHorizontal;
  static var blockSizeVertical;
  static var safeBlockSizeHorizontal;
  static var safeBlockSizeVertical;

  void init(BuildContext context) {
    _queryData = MediaQuery.of(context);

    _safeAreaHorizontal = _queryData!.padding.left + _queryData!.padding.right;
    _safeAreaVertical = _queryData!.padding.top + _queryData!.padding.bottom;

    screenWidth = _queryData!.size.width;
    screenHeight = _queryData!.size.height;

    safeScreenHeight = screenHeight - _safeAreaVertical;
    safeScreenWidth = screenWidth - _safeAreaHorizontal;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeBlockSizeHorizontal = safeScreenWidth / 100;
    safeBlockSizeVertical = safeScreenHeight / 100;
  }
}
