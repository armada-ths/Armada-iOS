import UIKit

class CompanyViewController: UIViewController {
   // @IBOutlet var mapH: NSLayoutConstraint!
    
    @IBOutlet var mapImage: UIImageView!
   // @IBOutlet var imageHeight: NSLayoutConstraint!
   // @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet var aboutText: UITextView!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var companyName: UILabel!
    // @IBOutlet weak var aboutLabel: UILabel!
//    @IBOutlet weak var jobLabel: UILabel!
//    @IBOutlet weak var fieldsLabel: UILabel!
//    @IBOutlet weak var websiteLabel: UILabel!
//    @IBOutlet weak var countriesLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var mapWebView: UIWebView!
//    @IBOutlet weak var isStartupImageView: UIImageView!
//    @IBOutlet weak var companyValuesLabel: UILabel!
  //  @IBOutlet weak var likesEnvironmentImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
//    @IBOutlet weak var twitterButton: UIButton!
//    @IBOutlet weak var facebookButton: UIButton!
//    @IBOutlet weak var linkedinButton: UIButton!
//    @IBOutlet weak var likesDiversityImageView: UIImageView!
//    @IBOutlet weak var videoLabel: UILabel!
//    @IBOutlet weak var employeeLabel: UILabel!
//    @IBOutlet weak var locationCell: UITableViewCell!
    
    var company: Company!
    var companies = [Company]()

    
    override func viewDidLoad() {
        if(company.image != nil){
           // headerHeight = UIScreen.main.bounds.width * (company.image!.size.height/company.image!.size.width)
           /// imageHeight.constant = headerHeight
            headerImageView.image = company.image
        }

        super.viewDidLoad()
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = true
        
        aboutText.text = company.companyDescription.strippedFromHtmlString
        if company.companyDescription.isEmpty {
            aboutText.text = "To be announced"
        }
        companyName.text = company.name
//        jobLabel.text = Array(company.jobTypes.map({"● " + $0.jobType})).sorted().joined(separator: "\n")
//        fieldsLabel.text = Array(company.workFields.map { "● " + $0.workField }).sorted().joined(separator: "\n")
//        companyValuesLabel.text = Array(company.companyValues.map { "● " + $0.companyValue }).sorted().joined(separator: "\n")
//        websiteLabel.text = company.website
//        websiteLabel.textColor = ColorScheme.armadaDarkMelon
//        videoLabel.text = company.videoUrl
//        videoLabel.textColor = ColorScheme.armadaDarkMelon
//        countriesLabel.text = "\(company.countries) " + (company.countries == 1 ?  "Country" : "Countries")
//        employeeLabel.text = "\(company.employeesWorld.thousandsSeparatedString) Employees"
//
//        let socialMediaButtons = [facebookButton, linkedinButton, twitterButton]
//        let socialMediaUrls = [company.facebook, company.linkedin, company.twitter]
//        for (index, url) in socialMediaUrls.enumerated() {
//            socialMediaButtons[index]?.isEnabled = false
//            if let url = URL(string: url) , UIApplication.shared.canOpenURL(url) {
//                socialMediaButtons[index]?.isEnabled = true
//            }
//        }
        
//        let armadaFieldsImageViews = [isStartupImageView, likesEnvironmentImageView, likesDiversityImageView]
//        let companyArmadaFields = [company.isStartup, company.likesEnvironment, company.likesEquality]
//
//        for (i, boolish) in companyArmadaFields.enumerated() {
//            armadaFieldsImageViews[i]?.alpha = boolish ? 1 : 0.1
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parent?.title = company.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationLabel.text = company.locationDescription + " Booth:" +  String(company.booth)
//        if(company.locationUrl == ""){
//            return
//        }
        URLSession.shared.dataTask(with: URL(string: company.locationUrl)!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                var ratio:CGFloat
                let image = UIImage(data: data!)
                self.mapImage.image = image
            })
        }).resume()
    }

    

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let viewController = segue.destination as? LocationViewController {
//            viewController.company = company
//            deselectSelectedCell()
//        }
//    }
    
}

