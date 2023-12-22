
import Foundation


//enum NexacroPluginConst: String {
//    case SVCID = "svcid"
//    case REASON = "reason"
//    case RETVAL = "returnvalue"
//    
//    case ONCALLBACK = "_oncallback"
//}

@objc
class SamplePlugin: NXPlugin {
    
    private let CODE_SUCCES = 0
    private let CODE_ERROR = -1
    private let CODE_PERMISSION_ERROR = -9
    
    private var callbackId = 0
    
    @objc
    override func pluginInitialize() {
        
//        let webView: WKWebView = self.webView as! WKWebView
//        
//        if #available(iOS 16.4, *) {
//            webView.isInspectable = true
//        }
    
        super.pluginInitialize()
    }
    
    
    /*
     함수인자를 Obj-C 스타일로 받아야함.
     */
    
    @objc
    func callMethod(_ id:NSString,withDict params:NSMutableDictionary) {
        
        callbackId = id.integerValue
        
        if let swiftDictionary = params as? [String: Any] {
            if let serviceIDValue = swiftDictionary["serviceid"] as? String {
                print("ServiceID: \(serviceIDValue)")
                
                switch serviceIDValue {
                case "TestNativeService" :
                    self.sendEx(reason1: CODE_SUCCES,
                                eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                                serviceID: serviceIDValue,
                                andMsg: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
                    
                case "TestService" :
                    if let paramDict = params["param"] as? [String: Any],
                       let sValue = paramDict["sValue"] as? String {
                        print("Inner Value: \(sValue)")
                        
                        let param: [String:String] = ["test":"test"]
                        
                        self.sendEx(reason1: CODE_SUCCES,
                                    eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                                    serviceID: serviceIDValue,
                                    andMsg: param)
                    }
                default : break;
                }
            } else {
                self.sendEx(reason1: CODE_ERROR,
                            eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                            serviceID: "",
                            andMsg: "svcid is null")
            }
        }
    }
    
    func sendEx(reason1: Int, eventID: String, serviceID svcId: String, andMsg retval: [String: Any]?) {
        var mdic = [String: Any]()
        
        mdic[NexacroPluginConst.REASON.rawValue] = reason1
        mdic[NexacroPluginConst.SVCID.rawValue] = svcId
        
        if let returnValue = retval {
            mdic[NexacroPluginConst.RETVAL.rawValue] = returnValue
        }
        
        let pluginResult = NXPluginResult(callbackId: self.callbackId,
                                          eventName: eventID,
                                          parameters: mdic)
        
        self.nxCommandDelegate.send(pluginResult)
    }

    func sendEx(reason1: Int, eventID: String, serviceID svcId: String, andMsg retval: String?) {
        var mdic = [String: Any]()
        
        mdic[NexacroPluginConst.REASON.rawValue] = reason1
        mdic[NexacroPluginConst.SVCID.rawValue] = svcId
        
        let returnValue = retval ?? "" // nil인 경우 빈 문자열로 대체
        mdic[NexacroPluginConst.RETVAL.rawValue] = returnValue
        
        let pluginResult = NXPluginResult(callbackId: self.callbackId,
                                          eventName: eventID,
                                          parameters: mdic)
        
        self.nxCommandDelegate.send(pluginResult)
    }

}
