// 143. Create a route helper class to help organize which pages we are going to direct to
import 'package:food_app_firebase/pages/address/add_address_page.dart';
import 'package:food_app_firebase/pages/auth/sign_in_page.dart';
import 'package:food_app_firebase/pages/cart/cart_page.dart';
import 'package:food_app_firebase/pages/food/popular_food_detail.dart';
import 'package:food_app_firebase/pages/home/home_page.dart';
import 'package:food_app_firebase/pages/home/main_food_page.dart';
import 'package:food_app_firebase/pages/splash/splash_screen.dart';
import 'package:food_app_firebase/pages/address/pick_address_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../models/order_model.dart';
import '../pages/address/pick_address_map.dart';
import '../pages/food/recommended_food_detail.dart';
import '../pages/payment/payment_page.dart';

class RouteHelper {
  static const String initial="/";
  static const String popularFood="/popular-food";
  static const String recommendedFood="/recommended-food";
  static const String cartPage="/cart-page";
  static const String splashPage="/splash-page";
  static const String signInPage="/signin-page";
  static const String addAddress="/add-address";
  static const String pickAddressMap="/pick-address";
  // 523. Create payment and order successful routes.
  static const String payment="/payment";
  static const String orderSuccess="/order-successful";


  // 148. Take parameter for passing inside the popular food function
  static String getInitial()=>'$initial';
  // 153. Get popular food page by passing through the index
  // 264. Add another parameter to keep track of the previous page.
  static String getPopularFood(int pageId, String page)=>'$popularFood?pageId=$pageId&page=$page';
  // 164. Get recommended food page by passing through the index
  // 265. Add another parameter to keep track of the previous page.
  static String getRecommendedFood(int pageId, String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  // 245. Create a getCartPage route
  static String getCartPage()=>'$cartPage';
  // 295. Create a route to go to the splash page.
  static String getSplashPage()=>'$splashPage';
  // 425. Create a route to go to the sign in page.
  static String getSignInPage()=>'$signInPage';
  // 442. Create a route to go to the address page.
  static String getAddressPage()=>'$addAddress';
  // 479. Create a route to pick address route.
  static String getPickAddressPage()=>'$pickAddressMap';
  // 524. Create payment and get order success page. Pass the id and userId.
  static String getPaymentPage(String id, int userID)=>'$payment?id=$id&userID=$userID';
  static String getOrderSuccessPage()=>'$orderSuccess';

  // 145. Make page routing dynamic
  static List<GetPage> routes = [
    // 480. Pass everything to the address map.
    GetPage(name: pickAddressMap, page: () {
      PickAddressMap _pickAddress = Get.arguments;
      return _pickAddress;
    }),

    GetPage(name: splashPage, page: ()=>SplashScreen()),
    // 278. Change the initial page from MainFoodPage to HomePage.
    GetPage(name: initial, page: () => HomePage()),

    GetPage(name: signInPage, page: (){
      return SignInPage();
    }, transition: Transition.fade),

    GetPage(name: popularFood, page: () {
      var pageId = Get.parameters['pageId'];
      // 266. Add another parameter page to keep track of the previous page.
      var page = Get.parameters['page'];
      // 154. Catch the page Id here
      return PopularFoodDetail(pageId:int.parse(pageId!), page:page!);
    },
      transition: Transition.fadeIn
    ),

    GetPage(name: recommendedFood, page: () {
      // 165. Follow the upper one
      var pageId = Get.parameters['pageId'];
      // 266. Add another parameter page to keep track of the previous page.
      var page = Get.parameters['page'];
      return RecommendedFoodDetail(pageId:int.parse(pageId!), page:page!);
    },
        transition: Transition.fadeIn
    ),

    GetPage(name: cartPage, page: () {
      return CartPage();
    },
        transition: Transition.fadeIn
    ),

    GetPage(name: addAddress, page: () {
      return AddAddressPage();
    }),

    // 525. Create get page route for the payment page.
    GetPage(name: payment, page: ()=>PaymentPage(
      orderModel: OrderModel(
        id: int.parse(Get.parameters['id']!),
        userId: int.parse(Get.parameters['userID']!),
      )
    )),
    // GetPage(name: orderSuccess, page: ()=>OrderSuccessPage())
  ];
}