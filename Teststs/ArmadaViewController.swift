import UIKit

class ArmadaViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var containedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containedViewControllers = ["NewsTableViewController", "AboutViewController", "OrganisationGroupsTableViewController"].map { self.storyboard!.instantiateViewControllerWithIdentifier($0) }
        segmentedControlChanged(segmentedControl)
    }

    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        let viewController = containedViewControllers[sender.selectedSegmentIndex]
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}
