import UIKit

public struct Sponsor {
    let name: String
    let imageUrl: NSURL
    let description: String
    let websiteUrl: NSURL
    
    let isMainPartner: Bool
    let isMainSponsor: Bool
    let isGreenPartner: Bool
}


class NewSponsorsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    class ArmadaSponsorTableViewDataSource: ArmadaTableViewDataSource<Sponsor> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(callback: Response<[[Sponsor]]> -> Void) {
            ArmadaApi.sponsorsFromServer { callback($0.map {
                sponsors in
                let sponsorGroups: [[Sponsor]] = [
                    sponsors.filter { $0.isMainPartner },
                    sponsors.filter { $0.isMainSponsor },
                    sponsors.filter { $0.isGreenPartner },
                    sponsors.filter { !$0.isMainPartner && !$0.isMainSponsor && !$0.isGreenPartner }
                ]
                return sponsorGroups
                })
            }
            
        }
        
        func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return ["Main Partners", "Main Sponsors", "Green Partners", "Other Sponsors"][section]
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let sponsor = values[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(sponsor.description.isEmpty ? "NewSponsorsTableViewCellNoText" : "NewSponsorsTableViewCell") as! NewSponsorsTableViewCell
            if !sponsor.description.isEmpty {
                cell.sponsorLabel.text = sponsor.description
                cell.sponsorLabel.attributedText = sponsor.description.attributedHtmlString
            }
            if let image = images[sponsor.imageUrl.absoluteString]{
                cell.sponsorImageView.image = image
                cell.sponsorImageUrl = sponsor.imageUrl.absoluteString
            } else{
                cell.sponsorImageView.image = nil
                cell.sponsorImageUrl = sponsor.imageUrl.absoluteString
                cell.sponsorImageView.loadImageFromUrl(sponsor.imageUrl.absoluteString){
                    if let image = $0{
                        if cell.sponsorImageUrl == sponsor.imageUrl.absoluteString{
                            self.images[sponsor.imageUrl.absoluteString]=image
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
        if #available(iOS 9.0, *) {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
    
    
    var highlightedSponsor: Sponsor?
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            guard let highlightedIndexPath = tableView.indexPathForRowAtPoint(location),
                let cell = tableView.cellForRowAtIndexPath(highlightedIndexPath) else  { return nil }
            
            
            let sponsor = dataSource.values[highlightedIndexPath.section][highlightedIndexPath.row]
            highlightedSponsor = sponsor
            let viewController = storyboard!.instantiateViewControllerWithIdentifier("SponsorsWebViewController") as! SponsorsWebViewController
            viewController.url = sponsor.websiteUrl
            if #available(iOS 9.0, *) {
                previewingContext.sourceRect = cell.frame
            }
            return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        openWebsite()
        
    }
    
    
    func openWebsite() {
        if let sponsor = selectedSponsor ?? highlightedSponsor {
            if UIApplication.sharedApplication().canOpenURL(sponsor.websiteUrl) {
                UIApplication.sharedApplication().openURL(sponsor.websiteUrl)
            }
            deselectSelectedCell()
        }
    }
    
    var selectedSponsor: Sponsor? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return dataSource.values[indexPath.section][indexPath.row]
        }
        return nil
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

