
import UIKit

class SponsorsWebViewController: UIViewController {

    var url: NSURL?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
}
