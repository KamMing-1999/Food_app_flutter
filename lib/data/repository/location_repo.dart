// 430. Create Location Repo.
import 'package:food_app_firebase/data/api/api_client.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  // 448. Create a function to get Address from geocode for address picked.
  Future getAddressfromGeocode(LatLng latlng) async {
    String GoogleMapApiKey = '';

    if (Platform.isIOS) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_IOS;
    } else if (Platform.isAndroid) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_ANDROID;
    } else {
      print('Running on Unknown Platform');
    }

    // 449. Get the google map api key, latitude and longitude here.
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?'+
        'latlng=${latlng.latitude},${latlng.longitude}&key=${GoogleMapApiKey}';

    http.Response response = await http.get(Uri.parse(url));
    final decodedResponse = json.decode(response.body);

    // 451. Find if the response is returned successfully.
    if (response.statusCode ==  200) {
      // Successful API Call.
      final results = decodedResponse['results'];
      if (results.isNotEmpty) {
        final formattedAddress = results[0]['formatted_address'];
        // print('Formatted address: ${formattedAddress}');
      }
      return response;
    } else {
      // Error in API call.
      final errorMessage = decodedResponse['error_message'];
      print('Error: $errorMessage');
      return response;
    }
  }

  // 457. Create get user address function to get user address from shared preferences.
  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }

  // 497. Create a function to get the zone (for local test only).
  Future<Response> getZone(String lat, String lng) async {
    // This link is invalid so this part is abandoned.
    print('${AppConstants.BASE_URL}${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
    return await apiClient.getData('${AppConstants.BASE_URL}${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  // 506. Build a search location method to get the searched result.
  Future searchLocation(String text) async {
    // return await apiClient.getData('${AppConstants.SERACH_LOCATION_URL}?search_text=$text');
    String GoogleMapApiKey = '';

    if (Platform.isIOS) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_IOS;
    } else if (Platform.isAndroid) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_ANDROID;
    } else {
      print('Running on Unknown Platform');
    }

    // 514. Go to the google cloud console to enable the Places API.
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='+
        '${text}&key=${GoogleMapApiKey}';

    http.Response response = await http.get(Uri.parse(url));
    final decodedResponse = json.decode(response.body);

    if (response.statusCode ==  200) {
      // Successful API Call.
      final predictions = decodedResponse['predictions'];
      return response;
    } else {
      // Error in API call.
      final errorMessage = decodedResponse['error_message'];
      print('Error: $errorMessage');
      return response;
    }
  }

  // 516. Create set location function.
  // 506. Build a search location method to get the searched result.
  Future setLocation(String placeId) async {
    // return await apiClient.getData('${AppConstants.SERACH_LOCATION_URL}?search_text=$text');
    String GoogleMapApiKey = '';

    if (Platform.isIOS) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_IOS;
    } else if (Platform.isAndroid) {
      GoogleMapApiKey = AppConstants.GOOGLE_MAP_API_KEY_ANDROID;
    } else {
      print('Running on Unknown Platform');
    }

    https://maps.googleapis.com/maps/api/place/details/json?placeid=YOUR_PLACE_ID&key=YOUR_API_KEY

    // 515. Go to the google cloud console to enable the Places API.
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid='+
        '${placeId}&key=${GoogleMapApiKey}';

    http.Response response = await http.get(Uri.parse(url));
    final decodedResponse = json.decode(response.body);

    if (response.statusCode ==  200) {
      // Successful API Call.
      final result = decodedResponse['result'];
      return response;
    } else {
      // Error in API call.
      final errorMessage = decodedResponse['error_message'];
      print('Error: $errorMessage');
      return response;
    }
  }
}