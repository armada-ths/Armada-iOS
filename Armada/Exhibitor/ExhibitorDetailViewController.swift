import SDWebImage
import UIKit

class ExhibitorDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fariLocationTextView: UITextView!
    @IBOutlet weak var industriesTextView: UITextView!
    @IBOutlet weak var employmentsTextView: UITextView!

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
        if let logoLink = exhibitor?.logoSquared {
            let urlString = "https://ais.armada.nu" + logoLink
            guard let url = URL(string: urlString) else {return }
            logo.sd_setImage(with: url)
        }
        
        
        //set about
        exhibitorAboutTextView.text = exhibitor?.about
        

        
        
        
        
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
        print("lala")
        
        //set fair locations
        var locationsText = ""
        if let booths = exhibitor?.booths {
            for booth in booths{
                for day in booth.days {
                    locationsText += day + ", "
                    if let par = booth.location.parent {
                        if let parentName = par.name {
                            locationsText += parentName
                            locationsText += ", "
                        }
                    }
                    
                    if let locationName = booth.location.name {
                        locationsText += locationName
                        locationsText += ", "
                    }
                    
                    if let boothName = booth.name {
                        locationsText += boothName
                    }
                    print(locationsText)
                    locationsText += "\n"
                }
                
            }
        }
        fariLocationTextView.text = locationsText
        
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let width = scrollView.frame.width
        scrollView.frame = CGRect(origin: scrollView.frame.origin,
                                  size: CGSize(width: width, height: CGFloat(1000)))
        scrollView.contentSize = CGSize(width: width, height: CGFloat(1300))
        
        
        //print(exhibitor?.name)
    }

    func updateData() {
        // TODO: Set data for the different view object
    }
}
