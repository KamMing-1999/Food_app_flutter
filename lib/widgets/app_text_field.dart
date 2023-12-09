import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  // 370. Add the several text filed attributes here.
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  bool isObscure = false;
  AppTextField({Key? key, required this.textController, required this.hintText, required this.icon, this.isObscure = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 369. Build the reusable text field widget here.
      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        boxShadow: [
          BoxShadow(blurRadius: 10, spreadRadius: 7, offset: Offset(1, 10),
              color: Colors.grey.withOpacity(0.2)),
        ],
      ),
      child: TextField(
          controller: textController,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color:AppColors.mainColor),
            // focused border
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide: BorderSide(width: 1.0, color: Colors.white)
            ),
            // enabled border
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide: BorderSide(width: 1.0, color: Colors.white)
            ),
          )
      ),
    );
  }
}
