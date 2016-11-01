import UIKit

class CompanyViewController: FixedHeaderTableViewController, UIWebViewDelegate {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapWebView: UIWebView!
    @IBOutlet weak var isStartupImageView: UIImageView!
    @IBOutlet weak var companyValuesLabel: UILabel!
    @IBOutlet weak var likesEnvironmentImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var likesDiversityImageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    var company: Company!
    var companies = [Company]()
    
    let favoriteRow = 0
    let websiteRow = 8
    let videoRow = 9
    let infoRow = 10
    
    override func viewDidLoad() {
        headerHeight = UIScreen.main.bounds.width * 3 / 4
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let continents = self.company.continents.map { $0.continent }
        mapWebView.delegate = self
        
        OperationQueue().addOperation {
            var html = String(try! NSString(contentsOf: Bundle(for: type(of: self)).url(forResource: "worldMap", withExtension: "html")!, encoding: String.Encoding.utf8.rawValue))
            let companyStyle = continents.reduce("<style>", {$0 + "#" + $1.replacingOccurrences(of: " ", with: "", options: [], range: nil) + "{ fill:#349939}"})
            html = html.replacingOccurrences(of: "<style>", with: companyStyle)
            OperationQueue.main.addOperation {
                self.mapWebView.loadHTMLString(html, baseURL: nil)
            }
        }
        
        aboutLabel.text = company.companyDescription.strippedFromHtmlString
        if company.companyDescription.isEmpty {
            aboutLabel.text = "To be announced"
        }
        
        jobLabel.text = Array(company.jobTypes.map({"● " + $0.jobType})).sorted().joined(separator: "\n")
        fieldsLabel.text = Array(company.workFields.map { "● " + $0.workField }).sorted().joined(separator: "\n")
        companyValuesLabel.text = Array(company.companyValues.map { "● " + $0.companyValue }).sorted().joined(separator: "\n")
        websiteLabel.text = company.website
        videoLabel.text = company.videoUrl
        countriesLabel.text = "\(company.countries) " + (company.countries == 1 ?  "Country" : "Countries")
        employeeLabel.text = "\(company.employeesWorld.thousandsSeparatedString) Employees"
        
        let socialMediaButtons = [facebookButton, linkedinButton, twitterButton]
        let socialMediaUrls = [company.facebook, company.linkedin, company.twitter]
        for (index, url) in socialMediaUrls.enumerated() {
            socialMediaButtons[index]?.isEnabled = false
            if let url = URL(string: url) , UIApplication.shared.canOpenURL(url) {
                socialMediaButtons[index]?.isEnabled = true
            }
        }
        
        let armadaFieldsImageViews = [isStartupImageView, likesEnvironmentImageView, likesDiversityImageView]
        let companyArmadaFields = [company.isStartup, company.likesEnvironment, company.likesEquality]
        
        for (i, boolish) in companyArmadaFields.enumerated() {
            armadaFieldsImageViews[i]?.alpha = boolish ? 1 : 0.1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parent?.title = company.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerImageView.loadImageFromUrl(company.adUrl)
        locationLabel.text = company.locationDescription
        if company.locationDescription.isEmpty {
            locationImageView.removeFromSuperview()
            locationLabel.text = "To be announced"
        } else {
            locationImageView.loadImageFromUrl(company.locationUrl)
            locationCell.selectionStyle = .default
            locationCell.accessoryType = .disclosureIndicator
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case favoriteRow:
            FavoriteCompanies.append(company!.name)
            tableView.beginUpdates()
            tableView.endUpdates()
        case websiteRow:
            if let url = company.website.httpUrl {
                UIApplication.shared.openURL(url as URL)
                deselectSelectedCell()
            }
        case videoRow:
            if let url = company.videoUrl.httpUrl {
                UIApplication.shared.openURL(url as URL)
                deselectSelectedCell()
            }
        //Info row should not be clickable. Readd if you want that
        /*case infoRow:
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "InfoSegue", sender: self)
            }*/
        default:
            break
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "LocationSegue" && company.locationDescription.isEmpty {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? LocationViewController {
            viewController.company = company
            deselectSelectedCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let zeroHeight: CGFloat = 0.000001
        switch (indexPath as NSIndexPath).row {
        case videoRow where company.videoUrl.isEmpty: return zeroHeight
        case websiteRow where company.website.isEmpty: return zeroHeight
        case favoriteRow where FavoriteCompanies.contains(company.name): return zeroHeight
        default: return UITableViewAutomaticDimension
        }
    }
    
    
    @IBAction func facebookButtonClicked(_ sender: AnyObject) {
        if let url = company.facebook.httpUrl {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func linkedinButtonClicked(_ sender: AnyObject) {
        if let url = company.linkedin.httpUrl {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func twitterButtonClicked(_ sender: AnyObject) {
        if let url = company.twitter.httpUrl {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
