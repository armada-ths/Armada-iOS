import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var locationImageView: UIImageView!
    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationImageView.loadImageFromUrl(company.locationUrl)
    }
}
