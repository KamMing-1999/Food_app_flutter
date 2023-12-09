// 288. Create a splash screen page when tap in the app.
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// 290. Use the Ticker Provider State Mixin class
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  // 289. Declare variables of animation and controller.
  late Animation<double> animation;
  late AnimationController controller;
  // 297. Add a function to load resources here.

  Future<void> _loadResources() async {
    // 303. Call the built-in loadResources function here.
    await Get.find<PopularProductController>().getPopularProductListFromFirebase();
    await Get.find<PopularProductController>().getRecommendedProductListFromFirebase();
  }

  // 291. Set the init state before the class starts.
  @override
  void initState() {
    super.initState();
    //_loadResources();  loadResources function is not used because it affects the cart image click functioning.
    controller = new AnimationController(vsync: this, duration: Duration(seconds:1))..forward();
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(
      // 294. After the duration of the food logo, go to the main food page.
      Duration(seconds: 2),
        ()=>Get.offNamed(RouteHelper.getInitial())
    );
  }

  @override
  void dispose() {
    controller.dispose(); // 423. Dispose the AnimationController
    super.dispose();
  }

  // 292. Use the logo for the splash screen here and centers it.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 293. Insert the animation above for the scale attribute.
          ScaleTransition(scale: animation,
          child: Center(child: Image.asset("assets/image/food_logo.png", width: Dimensions.height10*25,)))
        ],
      ),
    );
  }
}
