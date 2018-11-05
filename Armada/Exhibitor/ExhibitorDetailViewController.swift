import SDWebImage
import UIKit

class ExhibitorDetailViewController: UIViewController {
    var exhibitor: Exhibitor? {
        didSet {
            updateData()
        }
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(exhibitor?.name)
    }

    func updateData() {
        // TODO: Set data for the different view object
    }
}
