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
    case NEXA_FORMAT_ALL
    case MLKIT_FORMAT_ALL
}


@objc
class MultiBarcodePlugin: NXPlugin {
    
    private let CODE_SUCCES = 0
    private let CODE_ERROR = -1
    private let CODE_PERMISSION_ERROR = -9
    
    private var callbackId:Int?
    private var serviceId:String?
    
    private let NEXA_FORMAT_ALL = 0;
    private let MLKIT_FORMAT_ALL = 0xFFFF;
    
    @objc
    override func pluginInitialize() {
        super.pluginInitialize()
    }
    
    
    /*
     함수인자를 Obj-C 스타일로 받아야함.
     */
    
    @objc
    func callMethod(_ id:NSString,withDict params:Dictionary<String,Any>) {
        
        callbackId = id.integerValue
        
        if let serviceIDValue = params["serviceid"] as? String {
            print("ServiceID: \(serviceIDValue)")
            self.serviceId = serviceIDValue
            
            switch serviceId {
            case "scan" :
                guard let paramDict = params["param"] as? Dictionary<String,Any> else { return }
                
                isGrantCameraPermission(completion: { [weak self]granted in
                    if granted {
                        self?.startScan(dic:paramDict)
                    } else {
                        self?.showCameraPermissionUIAlert()
                    }
                })
                
            default : self.sendEx(reason1: CODE_ERROR,
                                  eventID: NexacroPluginConst.ONCALLBACK.rawValue,
                                  serviceID: "",
                                  andMsg: "MultiBarcodePlugin: \(serviceIDValue) is Undefine Service ID")
            }
            
        }
    }
    
    func startScan(dic: Dictionary<String,Any>) {
        
        let multiBarcodeVC = MultiBarcodeViewController(nibName: "MultiBarcodeViewController", bundle: nil)
        
        if let cameraID = dic["cameraID"] as? String {
            switch cameraID {
            case "1" : multiBarcodeVC.isUseFrontCamera = true
            default : multiBarcodeVC.isUseFrontCamera = false
            }
        }
        
        if let useTextLabel = dic["useTextLabel"] as? String {
            switch useTextLabel {
            case "true" : multiBarcodeVC.isUseTextLabel = true
            default : multiBarcodeVC.isUseTextLabel = false
            }
        }
        
        if let useAutoCapture = dic["useAutoCapture"] as? String {
            switch useAutoCapture {
            case "true" : multiBarcodeVC.isUseAutoCapture = true
            default : multiBarcodeVC.isUseAutoCapture = false
            }
        }
        
        if let useSound = dic["useSound"] as? String {
            switch useSound {
            case "true" : multiBarcodeVC.isUseSoundEffect = true
            default : multiBarcodeVC.isUseSoundEffect = false
            }
        }
        
        if let useVibration = dic["useVibration"] as? String {
            switch useVibration {
            case "true" : multiBarcodeVC.isUseVibration = true
            default : multiBarcodeVC.isUseVibration = false
            }
        }

        if let zoomFactorValue = dic["zoomFactor"] as? NSString {
            multiBarcodeVC.zoomFactor = CGFloat(zoomFactorValue.floatValue)
        }
        
        if let limitTime = dic["limitTime"] as? NSString {
            multiBarcodeVC.limitTime = CGFloat(limitTime.floatValue)
        }
        
        if let limitCount = dic["limitCount"] as? String {
            multiBarcodeVC.limitCount = Int(limitCount)
        }

        if let barcodeFormat = dic["scanFormat"] {
            multiBarcodeVC.barcodeFormat = getSacnFormat(setBarcodeFormat:barcodeFormat as! [Any] )
        } else {
            multiBarcodeVC.barcodeFormat  = MLKIT_FORMAT_ALL
        }
        
        
        multiBarcodeVC.modalPresentationStyle = .fullScreen
        
        print(multiBarcodeVC)
        self.viewController.present(multiBarcodeVC, animated: true, completion: nil)

        
    }
    
    func getSacnFormat(setBarcodeFormat: [Any]) -> Int {
        var result = setBarcodeFormat[0] as! Int
        for i in 0..<setBarcodeFormat.count {
            if setBarcodeFormat[i] as! Int == NEXA_FORMAT_ALL {
                result |= MLKIT_FORMAT_ALL
            }
            result |= setBarcodeFormat[i] as! Int
        }
        return result
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

