import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // 428. Import/Include the Google Map Credential Key here
    GMSServices.provideAPIKey("AIzaSyDP_oOSa72dvVMY94GKnh1kec9SSODStEk")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
