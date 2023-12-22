//
//  MultiBarcodePlugin.swift
//  v24swift
//
//  Created by 신진우 on 12/22/23.
//

import Foundation
import AVFoundation


enum NexacroPluginConst: String {
    case SVCID = "svcid"
    case REASON = "reason"
    case RETVAL = "returnvalue"
    
    case ONCALLBACK = "_oncallback"
}


@objc
class MultiBarcodePlugin: NXPlugin {
    
    private let CODE_SUCCES = 0
    private let CODE_ERROR = -1
    private let CODE_PERMISSION_ERROR = -9
    
    private var callbackId:Int?
    private var serviceId:String?
    
    @objc
    override func pluginInitialize() {
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
                
                self.serviceId = serviceIDValue
                
                switch serviceId {
                case "scan" :
                    guard let paramDict = params["param"] as? [String: Any] else { return }
                    
                    isGrantCameraPermission(completion: { [weak self]granted in
                        if granted {
                            print("카메라 권한 획득 완료")
                        } else {
                            self?.showCameraPermissionUIAlert()
                        }
                    })
                    
                default : self.sendEx(reason1: CODE_ERROR,
                                      eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                                      serviceID: "",
                                      andMsg: "MultiBarcodePlugin: \(serviceIDValue) is Undefine Service ID")
                }
            } else {
                self.sendEx(reason1: CODE_ERROR,
                            eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                            serviceID: "",
                            andMsg: "MultiBarcodePlugin: Undefine ServiceId")
            }
        }
    }
    
    func isGrantCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    
    func showCameraPermissionUIAlert() {
        
        let alert = UIAlertController(  title: "카메라 권한", message: "바코드 스캐닝을 위해 설정에서 \n카메라 권한을 허용해주세요.", preferredStyle: .alert )
        let okButton = UIAlertAction( title: "OK", style: .default, handler: { _ in } )
        let sysConfigButton = UIAlertAction( title: "설정", style: .default, handler: { _ in self.systemConfigView() } )
        
        alert.addAction(okButton)
        alert.addAction(sysConfigButton)
        
        // Assuming `rootViewController` is the reference to your root view controller
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    func systemConfigView() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:]) { success in
                if !success {
                    print("openURL: \(UIApplication.openSettingsURLString) Failed")
                    self.sendEx(reason1: self.CODE_ERROR, eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                                serviceID: self.serviceId!,
                                andMsg: "openURL: \(UIApplication.openSettingsURLString) Failed")
                }
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
        
        let pluginResult = NXPluginResult(callbackId: self.callbackId!,
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
        
        let pluginResult = NXPluginResult(callbackId: self.callbackId!,
                                          eventName: eventID,
                                          parameters: mdic)
        
        self.nxCommandDelegate.send(pluginResult)
    }
    
}
