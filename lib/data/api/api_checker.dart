// 510. Create an api checker class to see whether the api is successfully called.
import 'package:food_app_firebase/base/show_custom_snackbar.dart';
import 'package:food_app_firebase/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.offNamed(RouteHelper.getSignInPage());
    } else {
      showCustomSnackBar(response.statusText!);
    }
  }
}
