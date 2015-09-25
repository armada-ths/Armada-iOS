import UIKit

class ArmadaTableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    var values = [T]()
    weak var tableViewController: UITableViewController?
    
    init(tableViewController: UITableViewController) {
        super.init()
        self.tableViewController = tableViewController
        self.tableViewController!.refreshControl = UIRefreshControl()
        self.tableViewController!.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        refresh()
        
    }
    
    func refresh(refreshControl: UIRefreshControl? = nil) {
        updateFunc {
            switch $0 {
            case .Success(let values):
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableViewController!.refreshControl!.endRefreshing()
                    self.values = values
                    if self.values.isEmpty {
                        self.tableViewController?.showEmptyMessage(true, message: "No Values")
                    }
                    self.tableViewController!.tableView.reloadData()
                    print("Refreshed")
                }
            case .Error(let error):
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableViewController!.refreshControl?.endRefreshing()
                    let alertController = UIAlertController(title: nil, message: (error as NSError).localizedDescription, preferredStyle: .Alert)
                    self.tableViewController!.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateFunc(callback: Response<[T]> -> Void) {
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        assert(false)
        return tableView.dequeueReusableCellWithIdentifier("")!
    }
    
}

