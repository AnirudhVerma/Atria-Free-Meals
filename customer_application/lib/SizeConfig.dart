import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SizeConfig{

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double permanentBlockSize;

  void initialize(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    if(MediaQuery.of(context).orientation == Orientation.landscape){
      permanentBlockSize = screenWidth / 100;
    }
    else{
      permanentBlockSize = screenHeight / 100;
    }
  }

}