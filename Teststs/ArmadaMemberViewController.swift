import UIKit

class ArmadaMemberViewController: UIViewController {
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var member: ArmadaMember!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.isHidden = true
        roleLabel.isHidden = true
        nameLabel.text = member.name
        roleLabel.text = member.role
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.hideEmptyMessage()
        view.startActivityIndicator(hasNavigationBar: false)
        member.imageUrl.getImage() { response in
            OperationQueue.main.addOperation {
                self.view.stopActivityIndicator()
                switch response {
                case .success(let image):
                    self.nameLabel.isHidden = false
                    self.roleLabel.isHidden = false
                    self.memberImageView.image = image
                case .error(let error):
                    self.view.showEmptyMessage((error as NSError).localizedDescription)
                }
            }
        }
    }
}
