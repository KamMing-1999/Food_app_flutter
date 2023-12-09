import 'dart:ui';

import 'package:flutter/cupertino.dart';

// 23. Build a SmallText widget class. Adjust size to 12 and remove overflow attribute. Add height attribute.
class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;
  //TextOverflow overflow;

  SmallText({Key? key, this.color = const Color(0xFFccc7c5),
    required this.text,
    this.size = 12,
    this.height=1.2,
    //this.overflow=TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
            fontFamily: 'Roboto',
            color: color,
            fontSize: size,
            height: height,
            fontWeight: FontWeight.w400,
            //overflow: overflow
        )
    );
  }
}
