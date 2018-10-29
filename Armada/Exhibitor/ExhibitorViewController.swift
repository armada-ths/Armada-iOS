import UIKit
import SDWebImage

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
    fileprivate var testExhibitors = [Exhibitor]() {
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
    
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let filterViewController = FilterViewController.instance()
        filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
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
        
        
        //var types = ["Trainee", "Internship"]
        //testExhibitors = exhibitors.filter{!$0.employments.filter{types.contains($0.name)}.isEmpty};
        
//        var countries = ["Sweden \u2013 Svealand", "World \u2013 Europe"]
//        testExhibitors = exhibitors.filter{!$0.locations.filter{countries.contains($0.name)}.isEmpty};
        
        
//        values is missing in the model
//        var values = ["Sustainability", "Innovation"]
//        testExhibitors = exhibitors.filter{!$0.values.filter{countries.contains($0.name)}.isEmpty};
        
//          var industries = ["Architecture", "Environmental Sector"]
//          testExhibitors = exhibitors.filter{!$0.industries.filter{countries.contains($0.name)}.isEmpty};
        
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
        print(exhibitors[indexPath.row].employments[0].name)
        
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

// MARK: TABLE VIEW CELL
class ExhibitorTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!
    var path: String? {
        didSet {
            guard let path = self.path else { return }
            setImage(path: path)
        }
    }
    
    static var reuseIdentifier: String {
        return "ExhibitorTableViewCell"
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
