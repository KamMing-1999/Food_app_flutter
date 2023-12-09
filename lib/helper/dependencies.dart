// 114. Build dependencies folder to make access routes to the data
import 'package:food_app_firebase/controllers/cart_controller.dart';
import 'package:food_app_firebase/controllers/popular_product_controller.dart';
import 'package:food_app_firebase/data/api/api_client.dart';
import 'package:food_app_firebase/data/repository/auth_repo.dart';
import 'package:food_app_firebase/data/repository/cart_repo.dart';
import 'package:food_app_firebase/data/repository/popular_product_repo.dart';
import 'package:food_app_firebase/models/product_model.dart';
import 'package:food_app_firebase/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/location_controller.dart';
import '../data/repository/location_repo.dart';

Future<void> init() async {
  // 306. Use shared Preference here for storing cart history even the app closed Add the nullable sign (?).
  // Set Mock Initial Values to avoid the shared preference is empty before used only for testing purpose.
  // SharedPreferences.setMockInitialValues({AppConstants.CART_LIST: []});  (cannot use in real app)
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: "https://mvs.bslmeiyu.com"));
  // repos
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // controllers
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  
  // cart repos and controller
  // 307. In the Cart Repo, include the shared preference inside it.
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
}