//
//  CompaniesPageViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 27/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class CompaniesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var companies = [Company]()

    func viewControllerForCompany(company: Company) -> UIViewController {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CompanyViewController") as! CompanyViewController
        vc.company = company
        vc.companies = companies
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        delegate = self
        dataSource = self
        if let company = selectedCompany {
            setViewControllers([viewControllerForCompany(company)], direction: .Forward, animated: true, completion: {done in })
        } else {
            self.view.userInteractionEnabled = false
            setViewControllers([self.storyboard!.instantiateViewControllerWithIdentifier("NoCompanySelectedViewController")! as! UIViewController], direction: .Forward, animated: true, completion: { done in })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (find(companies, (viewController as! CompanyViewController).company!)! + 1) % companies.count
        return viewControllerForCompany(companies[index])
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (find(companies, (viewController as! CompanyViewController).company!)! - 1 + companies.count) % companies.count
        return viewControllerForCompany(companies[index])
    }
    
}