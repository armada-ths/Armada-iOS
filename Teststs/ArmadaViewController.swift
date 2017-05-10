import UIKit

class ArmadaViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var containedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containedViewControllers = ["NewsTableViewController", "OrganisationGroupsTableViewController"].map { storyboard!.instantiateViewController(withIdentifier: $0) }
        segmentedControlChanged(segmentedControl)
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        for viewController in containedViewControllers {
            if let viewController = viewController as? OrganisationGroupsTableViewController {
                viewController.searchBar?.resignFirstResponder()
            }
        }
        
        let viewController = containedViewControllers[sender.selectedSegmentIndex]
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
    }
}
