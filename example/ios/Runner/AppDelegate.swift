import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let sharedDefault = UserDefaults(suiteName: "group.dimitridessus.liveactivities")

    var diChannel: FlutterMethodChannel?
    @objc func pause() {
        diChannel?.invokeMethod("pause", arguments: "{\"test\":\"test\"}")
        sharedDefault?.set(true, forKey: "paused")
        }
    
    @objc func play() {
        diChannel?.invokeMethod("play", arguments: "{\"test\":\"test\"}")
        sharedDefault?.set(false, forKey: "paused")
        }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      if let sharedDefaults = UserDefaults(suiteName: "group.com.example.shared") {
                  // Use sharedDefaults to read or write
                  sharedDefaults.set("YourValue", forKey: "YourKey")
                  // Reading a value
                  let value = sharedDefaults.string(forKey: "YourKey")
                  print("Value from shared defaults: \(String(describing: value))")
              }

    NSLog("hello from native")
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
  if let controller = window?.rootViewController as? FlutterViewController {
          diChannel = FlutterMethodChannel(name: "DI", binaryMessenger: controller.binaryMessenger)
          // You can also set up method call handlers here if needed...
      }
  
  NotificationCenter.default.addObserver(self, selector: #selector(pause), name: NSNotification.Name("pause"), object: nil)
      
  NotificationCenter.default.addObserver(self, selector: #selector(play), name: NSNotification.Name("play"), object: nil)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}




