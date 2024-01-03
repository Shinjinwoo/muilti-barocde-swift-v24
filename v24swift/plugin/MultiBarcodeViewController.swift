//
//  MultiBarcodePluginViewController.swift
//  v24swift
//
//  Created by 신진우 on 12/22/23.
//

import UIKit
enum Constant {
    static let CODE_SUCCES = 0
    static let CODE_ERROR = -1
    static let CODE_PERMISSION_ERROR = -9
    
    static let NEXA_FORMAT_ALL = 0;
    static let MLKIT_FORMAT_ALL = 0xFFFF;
    
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
}

class MultiBarcodeViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cemeraView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    
    var isUseFrontCamera: Bool?
    var isUseTextLabel: Bool?
    var isUseSoundEffect: Bool?
    var isUseTimer: Bool?
    var isUseAutoCapture: Bool?
    var isUseVibration: Bool?
    var isUsePinchZoom: Bool?
    var isUnlimitedTime: Bool?
    
    var selectingCount: Int?
    var barcodeFormat: Int?
    var limitCount: Int?
    
    var limitTime: CGFloat?
    var zoomFactor: CGFloat?
    
    var boxColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func test(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
}
