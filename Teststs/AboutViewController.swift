import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ArmadaApi.pagesFromServer { response in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch response {
                case .Success(let armadaPages):
                    self.aboutTextView.attributedText = (armadaPages["about_ths_armada"]??["app_text"] as? String)?.attributedHtmlString ?? NSAttributedString(string: (armadaPages["about_ths_armada"]??["app_text"] as? String) ?? "")
                case .Error(let error):
                    print(error)
                }
            }
        }
    }    
}
