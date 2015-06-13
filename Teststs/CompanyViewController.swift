import UIKit

class CompanyViewController: UITableViewController, UIWebViewDelegate {
    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var company: Company! = nil
    var companies = [Company]()
    
    @IBOutlet weak var mapWebView: UIWebView!
    
    @IBOutlet weak var employeeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.reloadData()
        positionLabel.alpha = 0
        
        mapWebView.delegate = self
        NSOperationQueue().addOperationWithBlock {
            var html = String(try! NSString(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("worldMap", withExtension: "html")!, encoding: NSUTF8StringEncoding))
            let companyStyle = self.company!.continents.reduce("<style>", combine: {$0 + "#" + $1.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil) + "{ fill:#349939}"})
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
        
            positionLabel.text = "\(companies.indexOf(company)!+1)/\(companies.count)"
            logoImageView.image = company.image
            
            if let image = company.image {
                logoImageView.image = image
                companyNameLabel.hidden = true
            } else {
                logoImageView.image = nil
                companyNameLabel.hidden = false
                companyNameLabel.text = company.shortName
            }
            
            locationLabel.text = company.locationDescription
            company.asyncLocationImage { image in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    UIView.transitionWithView(self.locationImageView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        self.locationImageView.image = image
                        }, completion: nil)
                }
                
            }
            aboutLabel.text = company.description
            jobLabel.text = ", ".join(company.jobTypes ?? [])
            fieldsLabel.text = ", ".join(company.workFields ?? [])
            websiteLabel.text = company.website
            countriesLabel.text = "\(company.countries)"
            employeeLabel.text = "\(company.employeesWorld.thousandsSeparatedString)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parentViewController!.title = company!.shortName
        UIView.animateWithDuration(0.1) {
            self.positionLabel.alpha = 1
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animateWithDuration(0.1) {
            self.positionLabel.alpha = 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            FavoriteCompanies.append(company!.name)
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.frame = CGRectMake(0, 0, cell.frame.width, 0)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        if indexPath.row == 9 {
            if let url = NSURL(string: "http://" + company.website) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if let y = navigationController?.navigationBar.frame.maxY where y > 0 {
                return y
            }
            return 64
        }
        if FavoriteCompanies.contains(company!.name) && indexPath.row == 3 {
            return 0.000001
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
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
