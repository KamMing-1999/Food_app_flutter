import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/widgets/small_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

// 102. make expandable text stateful widget
class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText=true;
  double textHeight = Dimensions.screenHeight/5.63;

  @override
  void initState(){
    super.initState();
    // 103. Check whether the text is expanded or not
    if(widget.text.length>textHeight){
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    }else{
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(color: AppColors.paraColor, size: Dimensions.font16, text: firstHalf):Column(
        children: [
          SmallText(height: 1.8, color: AppColors.paraColor, size: Dimensions.font16, text: hiddenText?(firstHalf+"..."):(firstHalf+secondHalf)),
          // 104. Make an inkwell button to choose whether to expand text or not
          InkWell(
            onTap: () {
              // 106. Make "Show more" button toggle
              setState(() {
                hiddenText=!hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(text: hiddenText?"Show more":"Show less", color: AppColors.mainColor),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up, color: AppColors.mainColor,)
              ],
            )
          )
        ],
      ),
    );
  }
}
