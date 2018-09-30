import UIKit

class ExhibitorViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    fileprivate var exhibitors = [Exhibitor]() {
        didSet {
            exhibitors.sort(by: { a, b -> Bool in
                a.name < b.name
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var filteredExhibitors = [Exhibitor]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var showFilteredExhibitors: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        ExhibitorService.sharedInstance.fetchExhibitors { exhibitors in
            self.exhibitors = exhibitors
        }
        filteredExhibitors = exhibitors
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ExhibitorViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredExhibitors = []
            showFilteredExhibitors = false
        }

        filteredExhibitors = exhibitors.filter { exhibitor -> Bool in
            return exhibitor.name.lowercased().contains(searchText.lowercased())
        }
        if !filteredExhibitors.isEmpty {
            showFilteredExhibitors = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension ExhibitorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFilteredExhibitors {
            return filteredExhibitors.count
        }
        return exhibitors.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(exhibitors[indexPath.row].name)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var exhibitor = exhibitors[indexPath.row]

        if !filteredExhibitors.isEmpty {
            exhibitor = filteredExhibitors[indexPath.row]
        }

        let cell: ExhibitorTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: ExhibitorTableViewCell.reuseIdentifier,
            for: indexPath) as! ExhibitorTableViewCell

        cell.name.text = exhibitor.name
        cell.path = exhibitor.logoSquared

        return cell
    }
}
