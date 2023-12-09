import 'package:food_app_firebase/utils/app_constants.dart';
import 'package:get/get.dart';

// 115. Keep sending the request for info/header in the time interval of 30s. Check response.
class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  ApiClient({ required this.appBaseUrl }){
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = "";
    _mainHeaders = {
      'Content-Type':'application/json; charset=UTF-8',
      'Authorization':'Bearer $token'
    };
  }

  Future<Response> getData(String uri, ) async {
    try {
      String baseUrl = AppConstants.BASE_URL;
      Response response = await get(baseUrl+uri);
      return response;
    } catch(e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}