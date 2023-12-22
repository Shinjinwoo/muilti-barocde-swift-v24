
import Foundation

@objc
class Hello: NXPlugin {
    
    @objc
    override func pluginInitialize() {
        super.pluginInitialize()
    }
    
    @objc
    func showToast(_ id: NSString, withDict params: NSMutableDictionary) {
        let message = params["msg"] as? String
        
        let toastLabel = UILabel(frame: CGRect(x: self.viewController.view.frame.size.width/2 - 75,
                                               y: self.viewController.view.frame.size.height-100,
                                               width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.viewController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc
    func add(_ id: NSString, withDict params: NSMutableDictionary) {
        let a = params["a"] as? Int
        let b = params["b"] as? Int
        
        let calcResult = a! + b!
        let parameters = ["calcMsg": calcResult] as [String : Any]
        let pluginResult = NXPluginResult(callbackId: id.integerValue,
                                          eventName: "_onhello",
                                          parameters: parameters)
        
        self.nxCommandDelegate.send(pluginResult)
    }
}
