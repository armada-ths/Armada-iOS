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
        
        // TODO: Set title of the target viewcontroller to member.name
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let imageUrl = member.imageUrl {
            self.view.hideEmptyMessage()
            view.startActivityIndicator(hasNavigationBar: false)
            imageUrl.getImage() { response in
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
        }else{
            self.view.showEmptyMessage("No image")
        }
    }
}
