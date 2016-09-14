import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ArmadaApi.pagesFromServer { response in
            OperationQueue.main.addOperation {
                switch response {
                case .success(let armadaPages):
                    self.aboutTextView.attributedText = (Json(object: armadaPages)["about_ths_armada"]["app_text"].string)?.attributedHtmlString ?? NSAttributedString(string: (Json(object: armadaPages)["about_ths_armada"]["app_text"].string) ?? "")
                case .error(let error):
                    print(error)
                }
            }
        }
    }
}
