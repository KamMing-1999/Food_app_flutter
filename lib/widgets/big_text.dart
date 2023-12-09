import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../utils/dimensions.dart';

class BigText extends StatelessWidget {
  // 14. Create a folder inside lib folder called widgets to store reusable widgets
  // 15. First we create a stateless class called BigText

  // 17. Declare variables inside the stateless class to make attributes dynamic
  Color? color;  // 19. make color field optional
  final String text;
  double size;
  TextOverflow overFlow;

  // 18. add final fields to the parameter and set their values where necessary
  BigText({Key? key, this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    this.overFlow = TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 16. Return a Text Widget
    // 19. Call the fields values
    return Text(
      text,
      overflow: overFlow,
      maxLines: 1,  // 24. Add maxLines attribute to limit the number of line rows
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        // 71. Dynamic font size used here and avoid passing size value equal to 0
        fontSize: size==0?Dimensions.font20:size,
        fontWeight: FontWeight.w400
      )
    );
  }
}
