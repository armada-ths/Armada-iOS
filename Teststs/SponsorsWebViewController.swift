
import UIKit

class SponsorsWebViewController: UIViewController {

    var url: URL?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            webView.loadRequest(URLRequest(url: url))
        }
    }
}
