import UIKit

class ExhibitorViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!

    fileprivate var exhibitors = [Exhibitor]() {
        didSet {
            exhibitors.sort(by: { a, b -> Bool in
                a.name < b.name
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showFilteredExhibitors = true
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

        button.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func filterTapped() {
        present(FilterViewController(), animated: true)
    }
}

extension ExhibitorViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            showFilteredExhibitors = false
            return
        }
        showFilteredExhibitors = true

        filteredExhibitors = exhibitors.filter ({
            print($0.name)
            return $0.name.lowercased().hasPrefix(searchText.lowercased())
        })
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
        let exhibitor = exhibitors[indexPath.row]

        let cell: ExhibitorTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: ExhibitorTableViewCell.reuseIdentifier,
            for: indexPath) as! ExhibitorTableViewCell

        cell.name.text = exhibitor.name
        cell.path = exhibitor.logoSquared

        return cell
    }
}
