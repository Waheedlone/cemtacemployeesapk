import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

BoxDecoration RadialDecoration() {
  return BoxDecoration(
    image: DecorationImage(image: AssetImage("assets/images/back.png"),fit: BoxFit.fitHeight,opacity: .7,alignment: Alignment.center),
      gradient: RadialGradient(colors: [
    //     HexColor("#79C9F3"),
    //  HexColor("#011754"),
    // HexColor("#041033"),
        HexColor("#C2C1FD"),
        HexColor("#99B4FF"),
        HexColor("#4E7BFF"),

  ]));
}
