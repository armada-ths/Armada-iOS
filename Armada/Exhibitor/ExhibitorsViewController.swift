import SDWebImage
import UIKit

class ExhibitorsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    fileprivate var exhibitors: [Exhibitor]? {
        didSet {
            exhibitors?.sort(by: { a, b -> Bool in
                a.name < b.name
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var filteredExhibitors: [Exhibitor]? {
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

        ExhibitorsService.sharedInstance.fetchExhibitors { exhibitors in
            self.exhibitors = exhibitors
        }
        filteredExhibitors = exhibitors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        let filterViewController = FilterViewController.instance()
        filterViewController.modalPresentationStyle = .overFullScreen
        filterViewController.delegate = self
        present(filterViewController, animated: true, completion: nil)
    }

}

extension ExhibitorsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredExhibitors = []
            showFilteredExhibitors = false
        }

        filteredExhibitors = exhibitors?.filter { exhibitor -> Bool in
            exhibitor.name.lowercased().contains(searchText.lowercased())
        }

        //var types = ["Trainee", "Internship"]
        //testExhibitors = exhibitors.filter{!$0.employments.filter{types.contains($0.name)}.isEmpty};

//        var countries = ["Sweden \u2013 Svealand", "World \u2013 Europe"]
//        testExhibitors = exhibitors.filter{!$0.locations.filter{countries.contains($0.name)}.isEmpty};

//        values is missing in the model
//        var values = ["Sustainability", "Innovation"]
//        testExhibitors = exhibitors.filter{!$0.values.filter{countries.contains($0.name)}.isEmpty};

//          var industries = ["Architecture", "Environmental Sector"]
//          testExhibitors = exhibitors.filter{!$0.industries.filter{countries.contains($0.name)}.isEmpty};

        if !(filteredExhibitors!).isEmpty {
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
        if showFilteredExhibitors {
            return filteredExhibitors?.count ?? 0
        }
        return exhibitors?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exhibitor = exhibitors?[indexPath.row] else { return }
        let exhibitorVC = ExhibitorDetailViewController.instance()
        exhibitorVC.exhibitor = exhibitor
        navigationController?.pushViewController(exhibitorVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exhibitor = exhibitors?[indexPath.row] else {
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
    func didFilter() {
        print("didFilter")
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
