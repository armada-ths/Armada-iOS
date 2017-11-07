import UIKit

class CompanyViewController: UIViewController {
   // @IBOutlet var mapH: NSLayoutConstraint!
    
    @IBOutlet var jobTypes: UILabel!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var webButton: UIButton!
    @IBOutlet var contentview: UIView!
    @IBOutlet var mapImage: UIImageView!
   // @IBOutlet var imageHeight: NSLayoutConstraint!
   // @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet var aboutText: UITextView!
    
    @IBOutlet var mapWidth: NSLayoutConstraint!
    @IBOutlet var mapHeight: NSLayoutConstraint!
    @IBOutlet var headerW: NSLayoutConstraint!
    @IBOutlet var headerH: NSLayoutConstraint!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var coreIcon: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var borderview: UIView!
    @IBOutlet var whiteView: UIView!
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
        if(company.localImage != nil){
//            headerHeight = UIScreen.main.bounds.width * (company.image!.size.height/company.image!.size.width)
           // imageHeight.constant = headerHeight
            let image = company.localImage
            if(Float((image?.size.width)!) > Float((image?.size.height)!)){
                headerW.constant = 100
                headerH.constant = headerW.constant * ((image?.size.height)! / (image?.size.width)!)
            }
        else{
            headerH.constant = 100
            headerW.constant = headerH.constant * ((image?.size.width)! / (image?.size.height)!)
            }
        headerImageView.image = image
        }
    else{
        let image = company.image
        if(Float((image?.size.width)!) > Float((image?.size.height)!)){
            headerW.constant = 100
            headerH.constant = headerW.constant * ((image?.size.height)! / (image?.size.width)!)
        }
        else{
            headerH.constant = 100
            headerW.constant = headerH.constant * ((image?.size.width)! / (image?.size.height)!)
            }
        headerImageView.image = image
        }
           // whiteView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "companyBackground"))
           // backgroundView.backgroundColor = ColorScheme.armadaLicorice
         //   self.whiteView.sendSubview(toBack: backgroundImage)

        super.viewDidLoad()
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = true
        
        if (company.jobTypes.count == 0){
           // jobTitleLabel.removeFromSuperview()
            jobTypes.removeFromSuperview()
            
        }
        else{
            jobTypes.text = Array(company.jobTypes.map({$0.jobType})).sorted().joined(separator: "\n")
            jobTypes.font=UIFont(name: "Lato-Regular", size: 14)
        }
        
        aboutText.text = company.companyDescription.strippedFromHtmlString
        if company.companyDescription.isEmpty {
            aboutText.text = "To be announced"
        }
        companyName.text = company.name
        if(company.website == nil || company.website == ""){
            webButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(company.likesEquality){
            backgroundView.backgroundColor = ColorScheme.diversityRed
            scrollView.backgroundColor = ColorScheme.diversityRed
            companyName.textColor = ColorScheme.diversityRed
            jobTitleLabel.textColor = ColorScheme.diversityRed
            companyName.textColor = ColorScheme.diversityRed
            webButton.setImage(#imageLiteral(resourceName: "redWeb"), for: .normal)
            coreIcon.image = #imageLiteral(resourceName: "div")

        }
        else if (company.likesEnvironment){
           backgroundView.backgroundColor = ColorScheme.sustainabilityGreen
            scrollView.backgroundColor = ColorScheme.sustainabilityGreen
            coreIcon.image = #imageLiteral(resourceName: "sus")


        }
        else{
            backgroundView.backgroundColor = ColorScheme.armadaLicorice
            scrollView.backgroundColor = ColorScheme.armadaLicorice

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationLabel.text = company.locationDescription
        if(company.locationUrl == "" || company.locationUrl == "https://ais.armada.nu/static/missing.png"){
            self.mapImage.isHidden = true
            return
        }
        URLSession.shared.dataTask(with: URL(string: company.locationUrl)!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                let width = image?.size.width
                let height = image?.size.height
                self.mapWidth.constant = 250
                self.mapHeight.constant = 250 * (height! / width!)
                self.mapImage.image = image
            })
        }).resume()
    }

    
    
    @IBAction func openWebsite(_ sender: Any) {
        if(UIApplication.shared.canOpenURL(URL(string: company.website)!)){
            UIApplication.shared.openURL(URL(string: company.website)!)
        }
    }
}

