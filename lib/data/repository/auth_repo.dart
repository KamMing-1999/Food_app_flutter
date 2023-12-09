import 'package:food_app_firebase/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 399. Create an auth repo class.

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences
  });
}