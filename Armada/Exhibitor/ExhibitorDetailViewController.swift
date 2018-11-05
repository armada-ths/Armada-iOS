import SDWebImage
import UIKit

class ExhibitorDetailViewController: UIViewController {
    
    @IBOutlet weak var industriesTextView: UITextView!
    @IBOutlet weak var employmentsTextView: UITextView!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPersonLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var exhibitorAboutTextView: UITextView!
    var exhibitor: Exhibitor? {
        didSet {
            updateData()
        }
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        
        //set logo
        let urlString = "https://ais.armada.nu" + (exhibitor?.logoSquared)!
        guard let url = URL(string: urlString) else {return }
        logo.sd_setImage(with: url)
        
        //set about
        exhibitorAboutTextView.text = exhibitor?.about
        
        //set contact
        contactPersonLabel.text = "Contact Person: \(exhibitor?.contactName ?? "")"
        contactEmailLabel.text = "Email : \(exhibitor?.contactEmail ?? "")"
        contactPhoneLabel.text = "Phone: \(exhibitor?.contactPhoneNumber ?? "")"
        
        
        
        //set employment types
        var employments = ""
        
        for em in (exhibitor?.employments)! {
            employments += em.name + ", "
        }
        employments = employments.trimmingCharacters(in: .whitespacesAndNewlines)
        employments = employments.trimmingCharacters(in: [","])
        employmentsTextView.text = employments
        
        //set industries
        
        var industries = ""
        
        for ind in (exhibitor?.industries)! {
            industries += ind.name + ", "
        }
        industries = industries.trimmingCharacters(in: .whitespacesAndNewlines)
        industries = industries.trimmingCharacters(in: [","])
        industriesTextView.text = industries
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //print(exhibitor?.name)
    }

    func updateData() {
        // TODO: Set data for the different view object
    }
}
