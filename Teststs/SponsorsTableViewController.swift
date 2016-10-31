import UIKit


class SponsorsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    class ArmadaSponsorTableViewDataSource: ArmadaTableViewDataSource<Sponsor> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        override func updateFunc(_ callback: @escaping (Response<[[Sponsor]]>) -> Void) {
            ArmadaApi.sponsorsFromServer { response in
                OperationQueue.main.addOperation {
                    callback(response.map { sponsors in
                        return [
                            sponsors.filter { $0.isMainPartner },
                            sponsors.filter { !$0.isMainPartner }
                        ]
                    })
                    OperationQueue().addOperation {
                        Thread.sleep(forTimeInterval: 0.2)
                        OperationQueue.main.addOperation {
                        self.tableViewController?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sponsorName = ["Main Partner", "Sponsor"][section]
            return sponsorName + (values[section].count > 1 ? "s" : "")
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let sponsor = self[indexPath]
            let cell = tableView.dequeueReusableCell(withIdentifier: sponsor.description.isEmpty ? "SponsorsTableViewCellNoText" : "SponsorsTableViewCell") as! SponsorsTableViewCell
            if !sponsor.description.isEmpty {
                cell.sponsorLabel.attributedText = sponsor.description.attributedHtmlString
            }
            if let image = images[sponsor.imageUrl.absoluteString] {
                cell.sponsorImageView.image = image
            } else{
                cell.sponsorImageView.image = nil

                cell.sponsorImageView.hideEmptyMessage()
                cell.sponsorImageView.startActivityIndicator()
                print("Loading IndexPath: \((indexPath as NSIndexPath).section) \((indexPath as NSIndexPath).row)")
                sponsor.imageUrl.getImage() { response in
                    OperationQueue.main.addOperation {
                        cell.sponsorImageView.stopActivityIndicator()
                        switch response {
                        case .success(let image):
                            self.images[sponsor.imageUrl.absoluteString] = image
                            if let cell = self.tableViewController?.tableView.cellForRow(at: indexPath) as? SponsorsTableViewCell {
                                print("Loaded IndexPath: \((indexPath as NSIndexPath).section) \((indexPath as NSIndexPath).row)")
                                cell.sponsorImageView.image = image
                                cell.setNeedsLayout()
                            } else {
                                print("No cell for IndexPath: \((indexPath as NSIndexPath).section) \((indexPath as NSIndexPath).row)")
                            }
                        case .error(let error):
                            cell.sponsorImageView.showEmptyMessage("Could not load image: \((error as NSError).localizedDescription)", fontSize: 15)
                            print("Error for IndexPath: \((indexPath as NSIndexPath).section) \((indexPath as NSIndexPath).row)")
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
        registerForPreviewing(with: self, sourceView: view)
    }
    
    
    var highlightedIndexPath: IndexPath?
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            guard let highlightedIndexPath = tableView.indexPathForRow(at: location),
                let cell = tableView.cellForRow(at: highlightedIndexPath) else  { return nil }
            let sponsor = dataSource[highlightedIndexPath]
            self.highlightedIndexPath = highlightedIndexPath
            let viewController = storyboard!.instantiateViewController(withIdentifier: "SponsorsWebViewController") as! SponsorsWebViewController
            viewController.url = sponsor.websiteUrl
            previewingContext.sourceRect = cell.frame
            return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        openWebsite()
    }
    
    func openWebsite() {
        if let indexPath = tableView.indexPathForSelectedRow ?? highlightedIndexPath {
            let sponsor = dataSource[indexPath]
            if UIApplication.shared.canOpenURL(sponsor.websiteUrl) {
                UIApplication.shared.openURL(sponsor.websiteUrl)
            }
            deselectSelectedCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openWebsite()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    
}

