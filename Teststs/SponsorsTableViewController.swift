import UIKit


class SponsorsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    class ArmadaSponsorTableViewDataSource: ArmadaTableViewDataSource<Sponsor> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[Sponsor]]> -> Void) {
            ArmadaApi.sponsorsFromServer { response in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(response.map { sponsors in
                        return [
                            sponsors.filter { $0.isMainPartner },
                            sponsors.filter { $0.isGreenPartner },
                            sponsors.filter { $0.isMainSponsor },
                            sponsors.filter { !$0.isMainPartner && !$0.isMainSponsor && !$0.isGreenPartner }
                        ]
                    })
                }
            }
        }
    
        
        func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sponsorName = ["Main Partner", "Green Partner", "Main Sponsor", "Other Sponsor"][section]
            return sponsorName + (values[section].count > 1 ? "s" : "")
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let sponsor = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(sponsor.description.isEmpty ? "SponsorsTableViewCellNoText" : "SponsorsTableViewCell") as! SponsorsTableViewCell
            if !sponsor.description.isEmpty {
                cell.sponsorLabel.text = sponsor.description
                cell.sponsorLabel.attributedText = sponsor.description.attributedHtmlString
            }
            if let image = images[sponsor.imageUrl.absoluteString] {
                cell.sponsorImageView.image = image
            } else{
                cell.sponsorImageView.image = nil
                cell.sponsorImageView.startActivityIndicator()
                sponsor.imageUrl.getImage() { response in
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        cell.sponsorImageView.stopActivityIndicator()
                        if case .Success(let image) = response {
                            self.images[sponsor.imageUrl.absoluteString] = image
                            if let cell = self.tableViewController?.tableView.cellForRowAtIndexPath(indexPath) as? SponsorsTableViewCell {
                                cell.sponsorImageView.image = image
                            }
                        }
                        if case .Error(let error) = response {
                            print(error)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    var dataSource: ArmadaSponsorTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ArmadaSponsorTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        registerForPreviewingWithDelegate(self, sourceView: view)
    }
    
    
    var highlightedIndexPath: NSIndexPath?
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            guard let highlightedIndexPath = tableView.indexPathForRowAtPoint(location),
                let cell = tableView.cellForRowAtIndexPath(highlightedIndexPath) else  { return nil }
            let sponsor = dataSource[highlightedIndexPath]
            self.highlightedIndexPath = highlightedIndexPath
            let viewController = storyboard!.instantiateViewControllerWithIdentifier("SponsorsWebViewController") as! SponsorsWebViewController
            viewController.url = sponsor.websiteUrl
            previewingContext.sourceRect = cell.frame
            return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        openWebsite()
    }
    
    func openWebsite() {
        if let indexPath = tableView.indexPathForSelectedRow ?? highlightedIndexPath {
            let sponsor = dataSource[indexPath]
            if UIApplication.sharedApplication().canOpenURL(sponsor.websiteUrl) {
                UIApplication.sharedApplication().openURL(sponsor.websiteUrl)
            }
            deselectSelectedCell()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openWebsite()
    }
}

