import UIKit

class ArmadaMemberViewController: UIViewController {
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var member: ArmadaMember!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.hidden = true
        roleLabel.hidden = true
        nameLabel.text = member.name
        roleLabel.text = member.role
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.hideEmptyMessage()
        view.startActivityIndicator(hasNavigationBar: false)
        member.imageUrl.getImage() { response in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.stopActivityIndicator()
                switch response {
                case .Success(let image):
                    self.nameLabel.hidden = false
                    self.roleLabel.hidden = false
                    self.memberImageView.image = image
                case .Error(let error):
                    self.view.showEmptyMessage((error as NSError).localizedDescription)
                }
            }
        }
    }
}