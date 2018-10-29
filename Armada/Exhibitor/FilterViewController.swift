import UIKit

class FilterViewController: UIViewController {
    var employmentTypes = ["Trainee",
                           "Internship",
                           "Summer job",
                           "Part time job",
                           "Master thesis",
                           "Bachelor thesis",
                           "Full time job"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)

    }
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employmentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterEmploymentCell", for: indexPath) as? FilterEmploymentCell else {
            fatalError("The dequeued cell is not an instance of FilterEmploymentCell.")
        }
        
        cell.label.text = employmentTypes[indexPath.row]
        
        return cell
    }
}

class FilterEmploymentCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    static var reuseIdentifier: String {
        return "FilterEmploymentCell"
    }
}

