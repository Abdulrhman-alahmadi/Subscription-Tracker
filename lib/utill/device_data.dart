import 'package:flutter/cupertino.dart';
class deviceData{

    static double height;
    static double width;

   static void getDeviceInfo(context){
       width = MediaQuery.of(context).size.width;
        height = MediaQuery.of(context).size.height;
 

   }
}