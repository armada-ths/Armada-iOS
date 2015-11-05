import UIKit

class ArmadaMembersPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var members = [ArmadaMember]()
    var selectedMember: ArmadaMember!
    
    func viewControllerForMember(member: ArmadaMember) -> UIViewController {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ArmadaMemberViewController") as! ArmadaMemberViewController
        viewController.member = member
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([viewControllerForMember(selectedMember)], direction: .Forward, animated: true, completion: {done in })
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let member = (viewController as! ArmadaMemberViewController).member
        let index = (members.indexOf(member)! + 1) % members.count
        return viewControllerForMember(members[index])
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let member = (viewController as! ArmadaMemberViewController).member
        let index = (members.indexOf(member)! - 1 + members.count) % members.count
        return viewControllerForMember(members[index])
    }
}