
import UIKit

class ViewController: NXViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        

    }
    
    // 웹페이지 로딩 완료시 호출 됩니다.
    override func onWebViewPageDidLoad(_ notification: Notification) {
        super.onWebViewPageDidLoad(notification)
    }
}

