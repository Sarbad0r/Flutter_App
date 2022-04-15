import UIKit
import Flutter
import GoogleMaps
import YandexMapsMobile
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    MKMapKit.setApiKey("162cc3e0-4c39-40e6-9f36-6201a2ebec56")
    GMSServices.provideAPIKey("AIzaSyBXaCLybH2X7Lp1iXxigM3_3U-F2f6t6Zs")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
