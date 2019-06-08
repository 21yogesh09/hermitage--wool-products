//
//  HomeVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont
import FirebaseAuth


class HomeVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.barTintColor =  .white
       
        let logoutIcon =  UIImage(from: .ionicon, code: "ios-log-out", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        let cartIcon =  UIImage(from: .iconic, code: "cart", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        
        let cartButtonItem = UIBarButtonItem(image: cartIcon, style: .plain, target: self, action: #selector(goToCart))
        let signoutItem = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logOut))
        
        navigationItem.rightBarButtonItems = [signoutItem, cartButtonItem]
        
        let historyIcon =  UIImage(from: .iconic, code: "spreadsheet", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: historyIcon, style: .plain, target: self, action: #selector(goToHistory))

        let Products = ProductsVC()
        let productImage = UIImage(from: .iconic, code: "spreadsheet", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        Products.tabBarItem = UITabBarItem(title: "Products", image:productImage , tag: 0)
        
        let Scan = ScanQRVC()
         let scanimage = UIImage(from: .fontAwesome, code: "qrcode", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        Scan.tabBarItem = UITabBarItem(title: "Scan QR", image:scanimage , tag: 1)

        let Notification = NotificationVC(collectionViewLayout: UICollectionViewFlowLayout())
        let bellImage = UIImage(from: .fontAwesome, code: "bell", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        Notification.tabBarItem = UITabBarItem(title: "Notification", image:bellImage , tag: 2)

        let dash = Dashboard()
        let connectImage = UIImage(from: .materialIcon, code: "home", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        dash.tabBarItem = UITabBarItem(title: "Dashboard", image:connectImage , tag: 3)

        let Health = HealthStatusVC()
        let healthImage = UIImage(from: .materialIcon, code: "healing", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        Health.tabBarItem =  UITabBarItem(title: "Health Status", image:healthImage , tag: 4)
        
        let tabBarList = [dash, Products, Scan, Notification, Health]
        viewControllers = tabBarList
    }
    
    @objc func goToCart(){
        let Cart = CartVC(collectionViewLayout: UICollectionViewFlowLayout())
       self.navigationController?.pushViewController(Cart, animated: true)
    }
    
    @objc func goToHistory(){
        let History = HistoryVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(History, animated: true)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logOut(){
      try! Auth.auth().signOut()
        let login = Login()
        let navigationController = UINavigationController(rootViewController: login)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        tabBar.tintColor = .black
        tabBar.barTintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        tabBar.unselectedItemTintColor = .white
         navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
       //        self.navigationController?.isNavigationBarHidden = true
    }
    

}
