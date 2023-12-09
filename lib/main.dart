import 'package:flutter/material.dart';
import 'package:food_app_firebase/controllers/auth_controller.dart';
import 'package:food_app_firebase/controllers/cart_controller.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:food_app_firebase/pages/auth/sign_in_page.dart';
import 'package:food_app_firebase/pages/auth/sign_up_page.dart';
import 'package:food_app_firebase/pages/cart/cart_page.dart';
import 'package:food_app_firebase/pages/food/popular_food_detail.dart';
import 'package:food_app_firebase/pages/food/recommended_food_detail.dart';
import 'package:food_app_firebase/pages/home/food_page_body.dart';
import 'package:food_app_firebase/pages/home/home_page.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:food_app_firebase/pages/splash/splash_screen.dart';
import 'package:food_app_firebase/routes/route_helper.dart';
import 'package:food_app_firebase/utils/colors.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

// 119. Once configured, a firebase_options.dart file will be generated for you containing all the options required for initialization.
import 'firebase_options.dart';

// 118. Import necessary Firebase packages;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Thanks and acknowledge to dbestech.

// push modified files to github:
// 1. git add .
// 2. git commit -m "description"
// 3. git push -u origin branchName

// 86. Refactor: Move the home folder inside the newly created pages folder

// 410. Keep the main() function return type to void().
void main() async {
  // 120. Binding Firebase App using the option file.
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init(); // 175. Important: Enable the dependencies by dep.init(); to use the controllers
  // 407. Pass the auth controller for Firebase Auth in the firebase initialize App.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 69. Use GetMaterialApp and import package:get/get.dart. It enables dynamic dimensions
    // 304. Wrap the GetMaterialApp class with GetBuilder PopularProductController
    // 324. Call the getCartData() function here.
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(builder: (_) {
      return GetMaterialApp(
        // 6. Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // 488. Change the theme color.
          primaryColor: AppColors.mainColor,
          fontFamily: "Lato"
          //primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // 5. Call MainFoodPage here
        // 87. Temporary set PopularFoodDetail/MainFoodPage/RecommendedFoodDetail as home page for development
        // 276. You can safely comment the home: MainFoodPage() out because the initialRoute has already been set to route to mainFoodPage.
        home: HomePage(), //RecommendedFoodDetail()//PopularFoodDetail(), //MainFoodPage(),
        // 296. Get the splash page here.
        initialRoute: RouteHelper.getSplashPage(),
        //initialRoute: RouteHelper.initial, // 144. Call the initial route inside route helper class here
        getPages: RouteHelper.routes,  // 146. Call the dynamic routes management here
      );
    });
  }
}
