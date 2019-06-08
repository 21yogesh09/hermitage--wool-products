//
//  ConnectedDeviceVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont

class Dashboard: UIViewController {
    
    let homecard = UIButton()
    let BarCard = UIButton()
    let NotificationCard = UIButton()
    let healthCard = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Dashboard"
        view.backgroundColor = .white
        setupProduct()
        setupBar()
        setupNotification()
        setupHealth()
        setGradientBackground()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Dashboard"
        setGradientBackground()
    }
    
    @objc func openItem(sender: UIButton){
        let tag = sender.tag
       tabBarController?.selectedViewController = tabBarController?.viewControllers![tag]
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red:0.25, green:0.36, blue:0.90, alpha:1.0).cgColor
        let colorMed = UIColor(red:0.51, green:0.23, blue:0.71, alpha:1.0).cgColor
        let colorBottom = UIColor(red:0.88, green:0.19, blue:0.42, alpha:1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorMed, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setupProduct(){
         let scanimage = UIImage(from: .iconic, code: "spreadsheet", textColor:.white, backgroundColor: .clear, size: CGSize(width: view.frame.width/5, height: view.frame.height / 10))
        let title = UILabel(text: "Products")
        let icon = UIImageView(image: scanimage)
        homecard.layer.borderColor = UIColor.white.cgColor
         title.textColor = .white
        homecard.tag = 1
        
        homecard.addTarget(self, action: #selector(openItem(sender:)), for: .touchUpInside)
        
        setupViews(icon: icon, title: title, main: homecard)
        
        homecard.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 8).isActive = true
        homecard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        setupIcon(icon: icon, title: title, main: homecard)
    }
    
    func setupBar(){
        let scanimage = UIImage(from: .fontAwesome, code: "qrcode", textColor: .white, backgroundColor: .clear, size: CGSize(width: view.frame.width/5, height: view.frame.height / 10))
        let title = UILabel(text: "Scan Qr Code")
        let icon = UIImageView(image: scanimage)
        BarCard.layer.borderColor = UIColor.white.cgColor
        title.textColor = .white
        BarCard.tag = 2
        
        BarCard.addTarget(self, action: #selector(openItem(sender:)), for: .touchUpInside)
        
        setupViews(icon: icon, title: title, main: BarCard)
        
        BarCard.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 8).isActive = true
        BarCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
      setupIcon(icon: icon, title: title, main: BarCard)
    }
    
    func setupNotification(){
       let scanimage = UIImage(from: .fontAwesome, code: "bell", textColor: .white, backgroundColor: .clear, size: CGSize(width: view.frame.width/5, height: view.frame.height / 10))
        let title = UILabel(text: "Notifications")
        let icon = UIImageView(image: scanimage)
        NotificationCard.layer.borderColor = UIColor.white.cgColor
        title.textColor = .white
        NotificationCard.tag = 3
        
        NotificationCard.addTarget(self, action: #selector(openItem(sender:)), for: .touchUpInside)
        
        setupViews(icon: icon, title: title, main: NotificationCard)

        NotificationCard.topAnchor.constraint(equalTo: homecard.bottomAnchor, constant: 16).isActive = true
        NotificationCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
      setupIcon(icon: icon, title: title, main: NotificationCard)
    }
    
    func setupHealth(){
         let scanimage = UIImage(from: .materialIcon, code: "healing", textColor: .white, backgroundColor: .clear, size: CGSize(width: view.frame.width/5, height: view.frame.height / 10))
        
        let title = UILabel(text: "Health Status")
        let icon = UIImageView(image: scanimage)
        healthCard.layer.borderColor = UIColor.white.cgColor
        title.textColor = .white
        
        healthCard.tag = 4
        
        healthCard.addTarget(self, action: #selector(openItem(sender:)), for: .touchUpInside)
        
        setupViews(icon: icon, title: title, main: healthCard)
        healthCard.topAnchor.constraint(equalTo: homecard.bottomAnchor, constant: 16).isActive = true
        healthCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        setupIcon(icon: icon, title: title, main: healthCard)
    }
    
    func setupViews(icon: UIImageView, title: UILabel, main: UIView){
      
        main.layer.cornerRadius = 7
        main.layer.borderWidth = 0.5
        
        main.addSubview(icon)
        main.addSubview(title)
        view.addSubview(main)
        
        main.translatesAutoresizingMaskIntoConstraints = false
        main.widthAnchor.constraint(equalToConstant: view.frame.width / 2.2).isActive = true
        main.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
    }
    
    
    func setupIcon(icon: UIView, title: UILabel, main: UIView){
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerXAnchor.constraint(equalTo: main.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: main.centerYAnchor).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16).isActive = true
        title.centerXAnchor.constraint(equalTo: icon.centerXAnchor).isActive = true
    }
    

}
