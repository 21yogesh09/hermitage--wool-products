//
//  ProductsVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseFirestore

public struct tabModel {
    var name:String
    var type:String
    var dictionary: [String: Any] {
        return [
            "name": name,
            "type": type,
        ]
    }
}


class ProductsVC: UIViewController {
    var tabMod: [tabModel]!
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
         self.tabBarController?.title = "Products"
        db = Firestore.firestore()
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        
        self.view.addSubview(loadingIndicator)
        fetchTabs()
    }
    
    func fetchTabs(){
        db.collection("tabs").getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error ?? "some error")
            }
            let results = querySnapshot?.documents.map { (document) -> tabModel in
                if let task = tabModel(dictionary: document.data()){
                    return task
                } else {
                    print(document.data())
                    fatalError("Unable to initialize type \(tabModel.self) with dictionary \(document.data())")
                }
            }
            self.tabMod = results
            let tab = ProductTabBar()
            for currentTab in self.tabMod{
                tab.types.append(currentTab.type)
                tab.tabTitles.append(currentTab.name)
            }
            self.addChild(tab)
            self.view.addSubview(tab.view)
            tab.didMove(toParent: self)
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Products"
    }
    

}

extension tabModel{
    init?(dictionary: [String : Any]) {
        guard      let name = dictionary["name"] as? String,
            let type = dictionary["type"] as? String
            else { return nil }
        
        self.init(name: name, type: type)
    }
}
