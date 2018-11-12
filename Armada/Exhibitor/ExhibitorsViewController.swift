import SDWebImage
import UIKit

class ExhibitorsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    fileprivate var result: [Exhibitor]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var exhibitors: [Exhibitor]?
    fileprivate var filteredExhibitors: [Exhibitor]?
    fileprivate var showFilteredExhibitors: Bool = false

    fileprivate var selectedEmployments: Set<Employment> = []
    fileprivate var selectedLocations: Set<Location> = []
    fileprivate var selectedSectors: Set<Industry> = []


    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        ExhibitorsService.sharedInstance.fetchExhibitors { exhibitors in
            self.exhibitors = exhibitors
            self.filteredExhibitors = exhibitors
            self.result = exhibitors
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        let filterVC = FilterViewController.instance()
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.delegate = self
        filterVC.selectedEmployments = selectedEmployments
        filterVC.selectedLocations = selectedLocations
        filterVC.selectedSectors = selectedSectors
        present(filterVC, animated: true, completion: nil)
    }

}

extension ExhibitorsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty, !showFilteredExhibitors {
            result = exhibitors
            showFilteredExhibitors = false
        } else if searchText.isEmpty, showFilteredExhibitors {
            result = filteredExhibitors
            showFilteredExhibitors = true
        } else if !searchText.isEmpty, showFilteredExhibitors {
            result = filteredExhibitors?.filter { exhibitor -> Bool in
                exhibitor.name.lowercased().contains(searchText.lowercased())
            }
            showFilteredExhibitors = true
        } else if !searchText.isEmpty, !showFilteredExhibitors {
            result = exhibitors?.filter { exhibitor -> Bool in
                exhibitor.name.lowercased().contains(searchText.lowercased())
            }
            showFilteredExhibitors = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension ExhibitorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exhibitor = result?[indexPath.row] else { return }
        let exhibitorVC = ExhibitorDetailViewController.instance()
        exhibitorVC.exhibitor = exhibitor
        navigationController?.pushViewController(exhibitorVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exhibitor = result?[indexPath.row] else {
            return UITableViewCell()
        }

        let cell: ExhibitorsTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: ExhibitorsTableViewCell.reuseIdentifier,
            for: indexPath) as! ExhibitorsTableViewCell

        cell.name.text = exhibitor.name
        cell.path = exhibitor.logoSquared

        return cell
    }
}

extension ExhibitorsViewController: FilterDelegate {
    func didFilter(_ employments: Set<Employment>, _ locations: Set<Location>, _ sectors: Set<Industry>) {
        filteredExhibitors = exhibitors?.filter { exhibitor in
            self.selectedEmployments = employments
            self.selectedLocations = locations
            self.selectedSectors = sectors
            return employments.isSubset(of: Set(exhibitor.employments)) &&
                locations.isSubset(of: Set(exhibitor.locations)) &&
                sectors.isSubset(of: Set(exhibitor.industries))
        }
        result = filteredExhibitors
        showFilteredExhibitors = true
    }
}

// MARK: TABLE VIEW CELL
class ExhibitorsTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!
    var path: String? {
        didSet {
            guard let path = self.path else { return }
            setImage(path: path)
        }
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    func setImage(path: String) {
        let urlString = "https://ais.armada.nu" + path
        guard let url = URL(string: urlString) else { return }
        logo.sd_setImage(with: url)
    }

    override func prepareForReuse() {
        self.logo.image = nil
    }
}
