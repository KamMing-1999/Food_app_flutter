// 123. Create app constants file to store app constants
class AppConstants {
  static const String APP_NAME = "DBFood";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "https://mvs.bslmeiyu.com";
  static const String POPULAR_PRODUCT_URI = "/api/v1/products/popular";
  static const String RECOMMENDED_PRODUCT_URI = "/api/v1/products/recommended";

  static const String TOKEN = "DBToken";
  static const String CART_LIST = "Cart-List";
  static const String CART_HISTORY = "Cart-History";

  static const String GEOCODE_URI = "/api/v1/config/geocode-api";
  static const String USER_ADDRESS = "user_address";

  static const String GOOGLE_MAP_API_KEY_ANDROID = "AIzaSyCgrWtKQ0qzd8HLHqm19I9P3U6icqnvC_I";
  static const String GOOGLE_MAP_API_KEY_IOS = "AIzaSyDP_oOSa72dvVMY94GKnh1kec9SSODStEk";

  static const String ZONE_URI = "/api/v1/config/get-zone-id";
  static const String SERACH_LOCATION_URL = "/api/v1/config/place-api-autocomplete";

  static const String PLACE_DETAILS_URL = "/api/v1/config/place-api-details";
}