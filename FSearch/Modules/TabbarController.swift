//
//  TabbarController.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 03.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNavigationController(), createHistoryNavigationController()]
    }
    // creating Search tab
    private func createSearchNavigationController() -> UINavigationController {
        let searchPresenter = SearchPresenter()
        let searchViewController = SearchViewController(presenter: searchPresenter)
        searchPresenter.view = searchViewController
        searchViewController.title = Constants.Tabs.search
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search , tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    // creating History tab
    private func createHistoryNavigationController() -> UINavigationController {
        let historyPresenter = HistoryPresenter()
        let historyViewController = HistoryViewController(presenter: historyPresenter)
        historyPresenter.view = historyViewController
        historyViewController.title = Constants.Tabs.history
        historyViewController.view.backgroundColor = .yellow
        historyViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
       
        return UINavigationController(rootViewController: historyViewController)
    }
}
