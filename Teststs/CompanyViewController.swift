import UIKit


class CompanyViewController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var company: Company? = nil
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        positionLabel.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        positionLabel.text = "\(find(companies, company!)!+1)/\(companies.count)"
        logoImageView.image = company?.image
        
        if let image = company!.image {
            logoImageView.image = image
            companyNameLabel.hidden = true
        } else {
            logoImageView.image = nil
            companyNameLabel.hidden = false
            companyNameLabel.text = company!.shortName
        }
        
        descriptionLabel.text = company?.description
        
        company?.asyncLocationImage { image in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.locationImageView.image = image
            }
        }

        aboutLabel.text = company?.description
        jobLabel.text = ", ".join(company?.jobTypes ?? [])
        fieldsLabel.text = ", ".join(company?.workFields ?? [])
        educationLabel.text = ", ".join(company?.programmes ?? [])
        websiteLabel.text = company?.website
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parentViewController!.title = company!.name
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
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return navigationController!.navigationBar.frame.maxY
        }
        if contains(FavoriteCompanies, company!.name) && indexPath.row == 3 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}
