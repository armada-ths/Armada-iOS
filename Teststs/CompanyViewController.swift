import UIKit

class CompanyViewController: UITableViewController, UIWebViewDelegate {
    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var company: Company! = nil
    var companies = [Company]()
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var isStartupImageView: UIImageView!
    
    @IBOutlet weak var companyValuesLabel: UILabel!
    
    @IBOutlet weak var likesEnvironmentImageView: UIImageView!
    
    @IBOutlet weak var hasClimateCompensatedImageView: UIImageView!
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var likesDiversityImageView: UIImageView!
    
    @IBOutlet weak var waysOfWorkingLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.reloadData()
        let continents = self.company!.continents.map { $0.continent }
        mapWebView.delegate = self
        NSOperationQueue().addOperationWithBlock {
            var html = String(try! NSString(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("worldMap", withExtension: "html")!, encoding: NSUTF8StringEncoding))
            let companyStyle = continents.reduce("<style>", combine: {$0 + "#" + $1.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil) + "{ fill:#349939}"})
            html = html.stringByReplacingOccurrencesOfString("<style>", withString: companyStyle)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.mapWebView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
            locationLabel.text = company.locationDescription
            self.locationImageView.loadImageFromUrl(company.locationUrl)
            aboutLabel.text = company.companyDescription
            if company.companyDescription.isEmpty {
                aboutLabel.text = "To be announced"
            }
        
            jobLabel.text = Array(company.jobTypes.map({$0.jobType})).joinWithSeparator(", ")
            fieldsLabel.text = Array(company.workFields.map { $0.workField }).joinWithSeparator(", ")
            companyValuesLabel.text = Array(company.companyValues.map { $0.companyValue }).joinWithSeparator(", ")
            waysOfWorkingLabel.text = Array(company.workWays.map { $0.workWay }).joinWithSeparator(", ")
            websiteLabel.text = company.website

        countriesLabel.text = "\(company.countries) " + (company.countries == 1 ? "Countries" : "Country")
            //adImageView.layer.minificationFilter = kCAFilterTrilinear

            adImageView.loadImageFromUrl(company.adUrl)
            employeeLabel.text = "\(company.employeesWorld.thousandsSeparatedString) Employees"
        
        if company.locationDescription.isEmpty {
            locationImageView.removeFromSuperview()
            locationLabel.text = "To be announced"
        }
        
        let socialMediaButtons = [facebookButton, linkedinButton, twitterButton]
        let socialMediaUrls = [company.facebook, company.linkedin, company.twitter]
        let dummyUrl = NSURL(string: "")!
        for (index, url) in socialMediaUrls.enumerate() {
            socialMediaButtons[index].enabled = UIApplication.sharedApplication().canOpenURL(NSURL(string: url) ?? dummyUrl)        
        }
        
        let armadaFieldsImageViews = [isStartupImageView, likesEnvironmentImageView, hasClimateCompensatedImageView, likesDiversityImageView]
        let companyArmadaFields = [company.isStartup, company.likesEnvironment, company.hasClimateCompensated, company.likesEquality]

        for (i, boolish) in companyArmadaFields.enumerate() {
            armadaFieldsImageViews[i].alpha = boolish ? 1 : 0.1
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parentViewController!.title = company!.name
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    let favoriteCellRow = 1
    let websiteRow = 10
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == favoriteCellRow {
            FavoriteCompanies.append(company!.name)
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.frame = CGRectMake(0, 0, cell.frame.width, 0)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        if indexPath.row == websiteRow {
            if let url = NSURL(string: "http://" + company.website) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if FavoriteCompanies.contains(company!.name) && indexPath.row == favoriteCellRow {
            return 0.000001
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    @IBAction func facebookButtonClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: company!.facebook)!)
    }
    
    @IBAction func linkedinButtonClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: company!.linkedin)!)
    }
    
    @IBAction func twitterButtonClicked(sender: AnyObject) {
        if let twitterAppUrl = NSURL(string: "twitter:///user?screen_name=" + company!.twitter.componentsSeparatedByString("/").last!) where  UIApplication.sharedApplication().canOpenURL(twitterAppUrl) {
            UIApplication.sharedApplication().openURL(twitterAppUrl)
        } else {
            if let url = NSURL(string: company.twitter) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}
