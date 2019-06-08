//
//  NotificationVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont
import FirebaseFirestore
import FirebaseAuth

public struct NotificationModel: Codable {
    var name:String
    var date:String
    var uid:String
}


class NotificationVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    
    let newUpdateLabel = UILabel()
    let connectLabel = UILabel()
    let bluetoothImage = UIImageView()
    let card = UIView()
    private let cellReuseIdentifier = "notification"
    var data:[NotificationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(NotificationItemCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
//        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.title = "Notifications"
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! NotificationItemCell
        let item = self.data[indexPath.row]
        
        cell.title.text = item.name
        cell.date.text = item.date
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func fetchData() {
        let uid = Auth.auth().currentUser?.uid
        db.collection("notifications").whereField("uid", isEqualTo: uid!).getDocuments { (snapshot, err) in
            if err == nil{
                snapshot?.documents.forEach({ (document) in
                    let item = document.data()
                    let jsonData = try! JSONSerialization.data(withJSONObject: item,
                                                               options: JSONSerialization.WritingOptions.prettyPrinted)
                    let json = try! JSONDecoder().decode(NotificationModel.self, from: jsonData)
                    print(item)
                    self.data.append(json)
                })
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.layoutIfNeeded()
                }
            }else{
                print(err)
            }
        }
    }
    
    func setupView(){
        newUpdateLabel.text = "New Updates"
        newUpdateLabel.font = newUpdateLabel.font.withSize(30)
        connectLabel.text = "Connect Your Device"
        bluetoothImage.image =  UIImage(from: .materialIcon, code: "bluetooth", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        card.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        
        view.addSubview(newUpdateLabel)
        
        card.addSubview(connectLabel)
        card.addSubview(bluetoothImage)
        view.addSubview(card)
        
        newUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        newUpdateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        newUpdateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        card.heightAnchor.constraint(equalToConstant: 45).isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
        connectLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: 0).isActive = true
        
        bluetoothImage.translatesAutoresizingMaskIntoConstraints = false
        bluetoothImage.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20).isActive = true
        bluetoothImage.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: 0).isActive = true
        
    }
    



}
