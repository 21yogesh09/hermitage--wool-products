//
//  ProductTabBar.swift
//  Hermitage
//
//  Created by yogesh on 12/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//
import UIKit
import Tabman
import Pageboy

class ProductTabBar: TabmanViewController {
    var types = [] as [String]
    var tabTitles = [] as [String]
    
//    var types = ["queen", "single"]
//    var tabTitles = ["queen", "single"]
    
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for type in types {
            let SingleController = ProductsList(collectionViewLayout: UICollectionViewFlowLayout())
            SingleController.type = type
            viewControllers.append(SingleController)
        }
        dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .white)
        bar.tintColor = .white
//        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 85.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.layout.transitionStyle = .snap
        
        addBar(bar, dataSource: self , at: .top)
    }
}



extension ProductTabBar: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        let title = tabTitles[index]
        return TMBarItem(title: title)
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return tabTitles.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
