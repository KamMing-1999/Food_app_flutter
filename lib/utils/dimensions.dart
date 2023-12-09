// 63. create a Dimension class in order to cope with devices with different sizes
import 'package:get/get.dart';
class Dimensions {
  // 65. get screen width and height
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  // scale factor = screenHeight / hardcoded height

  // 72. Find all hardcoded height and apply the dynamic height to all the places
  // iphone 12 is 844
  static double pageView = screenHeight/2.64;
  static double pageViewContainer = screenHeight/3.84;   // 844/220
  static double pageViewTextContainer = screenHeight/7.03;   // 844/120

  // dynamic heights
  static double height10 = screenHeight/84.4;
  static double height15 = screenHeight/56.3;
  static double height20 = screenHeight/42.2;

  // dynamic widths
  static double width10 = screenHeight/84.4;
  static double width15 = screenHeight/56.3;
  static double width20 = screenHeight/42.2;
  static double width30 = screenHeight/28.1;

  static double font16 = screenHeight/52.75;
  static double font20 = screenHeight/42.2;
  static double font26 = screenHeight/32.46;

  // dynamic radius
  static double radius20 = screenHeight/42.2;
  static double radius30 = screenHeight/28.1;
  static double radius15 = screenHeight/56.3;

  // icon size
  static double iconSize24 = screenHeight/35.17;
  static double iconSize16 = screenHeight/52.75;

  // list view size
  static double listViewImgSize = screenWidth/3.25;
  static double listViewTextContainerSize = screenWidth/3.9;

  // popular food
  static double popularFoodImgSize = screenHeight/2.41;

  // splash screen dimensions
  static double splashImg = screenHeight/3.38;
}