import UIKit

class ArmadaMembersPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var members = [ArmadaMember]()
    var selectedMember: ArmadaMember!
    
    func viewControllerForMember(_ member: ArmadaMember) -> UIViewController {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ArmadaMemberViewController") as! ArmadaMemberViewController
        viewController.member = member
        // TODO: Set title of the target viewcontroller to member.name
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([viewControllerForMember(selectedMember)], direction: .forward, animated: true, completion: {done in })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let member = (viewController as! ArmadaMemberViewController).member!
        let index = (members.index(of: member)! + 1) % members.count
        return viewControllerForMember(members[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let member = (viewController as! ArmadaMemberViewController).member!
        let index = (members.index(of: member)! - 1 + members.count) % members.count
        return viewControllerForMember(members[index])
    }
}
