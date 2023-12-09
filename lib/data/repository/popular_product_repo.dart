import 'package:get/get.dart';
import '../api/api_client.dart';
import 'dart:convert';

// 116. Create the popular product repo data type and get data from the uri
class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async {

    // 122. Get the firestore data from the link formatted below.
    // For dbestech links
    // Link to get popular products data: https://mvs.bslmeiyu.com/api/v1/products/popular
    // Link for dbestech main page: https://www.dbestech.com
    // Base Firestore URL: https://firestore.googleapis.com/v1/projects/foodappfirebase-7a670/databases/(default)/documents/[Document_id]?key=[Web_api_key]
    const firestore_url = 'https://firestore.googleapis.com/v1/projects/foodappfirebase-7a670/databases/(default)/documents/products?key=AIzaSyD8WNWsDceNmvu5xRi19-_-sTjQr7cUkns';
    const url = "/api/v1/products/popular";
    // const url = "https://mvs.bslmeiyu.com/api/v1/products/popular";
    return await apiClient.getData(url);
  }


}

