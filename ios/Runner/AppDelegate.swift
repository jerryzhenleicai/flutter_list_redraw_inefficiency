import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self);
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery",
                                                   binaryMessenger: controller);
    batteryChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // Handle battery messages.
    });

    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
    
    
    
    func setupNetworkCommunication() {
        // 1
//        var readStream: Unmanaged<CFReadStream>?
  //      var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        /*
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "agentliu.gaocan.com" as CFString,
                                           80,
                                           &readStream,
                                           &writeStream);
        
        */
       // CFReadStream stream = readStream?.takeRetainedValue();
       // stream.
    }
}
