import UIKit

class ArmadaTableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    var values = [[T]]()
    weak var tableViewController: UITableViewController?
    
    let separatorStyle: UITableViewCellSeparatorStyle
    
    init(tableViewController: UITableViewController) {
        self.separatorStyle = tableViewController.tableView.separatorStyle
        super.init()
        self.tableViewController = tableViewController
        tableViewController.tableView.separatorStyle = .none
    }
    
    subscript(indexPath: IndexPath) -> T {
        return values[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    }
    
    var hasNavigationBar: Bool {
        return true
    }
    
    func refresh(_ refreshControl: UIRefreshControl? = nil) {
        if refreshControl == nil {
            tableViewController?.tableView.startActivityIndicator(hasNavigationBar: hasNavigationBar)
            tableViewController?.showEmptyMessage(false, message: "")
            self.tableViewController?.tableView.separatorStyle = .none
        }
        updateFunc { response in
                switch response {
                case .success(let values):
                    self.values = values
                    self.tableViewController?.showEmptyMessage(self.values.isEmpty, message: "Nothing to be seen")
                    print("Refreshed")
                case .error(let error):
                    self.tableViewController?.showEmptyMessage(self.values.isEmpty, message: (error as NSError).localizedDescription)
                    if !self.values.isEmpty {
                        let alertController = UIAlertController(title: nil, message: (error as NSError).localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.tableViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
                self.tableViewController?.refreshControl?.endRefreshing()
                self.tableViewController?.tableView.separatorStyle = self.values.isEmpty ? .none : self.separatorStyle
                self.tableViewController?.tableView.reloadData()
                self.tableViewController?.tableView.stopActivityIndicator()
                self.tableViewController?.refreshControl = UIRefreshControl()
                self.tableViewController?.refreshControl!.addTarget(self, action: #selector(ArmadaTableViewDataSource.refresh(_:)), for: UIControlEvents.valueChanged)
        }
    }
    
    var isEmpty: Bool {
        return values.isEmpty
    }
    
    func updateFunc(_ callback: @escaping (Response<[[T]]>) -> Void) {}
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(false)
        return tableView.dequeueReusableCell(withIdentifier: "")!
    }
    
}

