import UIKit

class CompaniesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var companies = [Company]()
    var selectedCompany: Company!

    func viewControllerForCompany(company: Company) -> UIViewController {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CompanyViewController") as! CompanyViewController
        vc.company = company
        vc.companies = companies
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([viewControllerForCompany(selectedCompany)], direction: .Forward, animated: true, completion: {done in })
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (companies.indexOf((viewController as! CompanyViewController).company)! + 1) % companies.count
        return viewControllerForCompany(companies[index])
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (companies.indexOf((viewController as! CompanyViewController).company)! - 1 + companies.count) % companies.count
        return viewControllerForCompany(companies[index])
    }
}