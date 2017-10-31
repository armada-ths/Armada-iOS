import UIKit

class CompaniesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var companies = [Company]()
    var selectedCompany: Company!
    
    func viewControllerForCompany(_ company: Company) -> UIViewController {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CompanyView") as! CompanyViewController
        viewController.company = company
       // viewController.companies = companies
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([viewControllerForCompany(selectedCompany)], direction: .forward, animated: true, completion: {done in })
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (companies.index(of: (viewController as! CompanyViewController).company)!) % companies.count
        return viewControllerForCompany(companies[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (companies.index(of: (viewController as! CompanyViewController).company)! - 1 + companies.count) % companies.count
        return viewControllerForCompany(companies[index])
    }
}

