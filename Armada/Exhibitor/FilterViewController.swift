import UIKit

protocol FilterDelegate: class {
    func didFilter(_ employments: Set<Employment>, _ locations: Set<Location>, _ sectors: Set<Industry>)
}

class FilterViewController: UIViewController {
    fileprivate var employments: [Employment]?
    var selectedEmployments: Set<Employment> = []
    fileprivate var sectors: [Industry]?
    var selectedSectors: Set<Industry> = []
    fileprivate var locations: [Location]?
    var selectedLocations: Set<Location> = []

    @IBOutlet weak var tableView: UITableView!

    weak var delegate: FilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        ExhibitorsService.sharedInstance.fetchEmployments { employments in
            self.employments = employments
        }
        ExhibitorsService.sharedInstance.fetchLocations { locations in
            self.locations = locations
        }
        ExhibitorsService.sharedInstance.fetchSectors { sectors in
            self.sectors = sectors
        }
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Job opportunitues" }
        if section == 1 { return "Locations" }
        if section == 2 { return "Sector" }
        return ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return employments?.count ?? 0 }
        if section == 1 { return locations?.count ?? 0 }
        if section == 2 { return sectors?.count ?? 0 }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterEmploymentCell", for: indexPath)
            as? FilterEmploymentCell else {
            fatalError("The dequeued cell is not an instance of FilterEmploymentCell.")
        }

        if let employments = employments, indexPath.section == 0 {
            cell.label.text = employments[indexPath.row].name
            if selectedEmployments.contains(employments[indexPath.row]) {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            }
        }
        if let locations = locations, indexPath.section == 1 {
            cell.label.text = locations[indexPath.row].name
            if selectedLocations.contains(locations[indexPath.row]) {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            }
        }
        if let sectors = sectors, indexPath.section == 2 {
            cell.label.text = sectors[indexPath.row].name
            if selectedSectors.contains(sectors[indexPath.row]) {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        if indexPath.section == 0 {
            guard let employments = employments else { return }
            selectedEmployments.insert(employments[indexPath.row])
        }
        if indexPath.section == 1 {
            guard let locations = locations else { return }
            selectedLocations.insert(locations[indexPath.row])
        }
        if indexPath.section == 2 {
            guard let sectors = sectors else { return }
            selectedSectors.insert(sectors[indexPath.row])
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        delegate?.didFilter(selectedEmployments, selectedLocations, selectedSectors)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
        if indexPath.section == 0 {
            guard let employments = employments else { return }
            selectedEmployments.remove(employments[indexPath.row])
        }
        if indexPath.section == 1 {
            guard let locations = locations else { return }
            selectedLocations.remove(locations[indexPath.row])
        }
        if indexPath.section == 2 {
            guard let sectors = sectors else { return }
            selectedSectors.remove(sectors[indexPath.row])
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        delegate?.didFilter(selectedEmployments, selectedLocations, selectedSectors)
    }
}

class FilterEmploymentCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    static var reuseIdentifier: String {
        return "FilterEmploymentCell"
    }
}
