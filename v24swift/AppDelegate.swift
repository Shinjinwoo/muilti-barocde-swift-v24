
import UIKit

@main
class AppDelegate: NXAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        viewController = ViewController()
        
        viewController.projectUrl = "http://smart.tobesoft.co.kr/NexacroN/MultiQRBarcodePlugin/_ios_/"
        viewController.bootstrapUrl = "http://smart.tobesoft.co.kr/NexacroN/MultiQRBarcodePlugin/_ios_/start_ios.json"
        
//        viewController.projectUrl = "http://smart.tobesoft.co.kr/techService/NexacroN/97_HelloSwift/"
//        viewController.bootstrapUrl = "http://smart.tobesoft.co.kr/techService/NexacroN/97_HelloSwift/start_ios.json"
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
 
