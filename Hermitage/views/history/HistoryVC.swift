//
//  HistoryVC.swift
//  Hermitage
//
//  Created by yogesh on 17/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

private let reuseIdentifier = "Cell"

public struct historyModel: Codable {
    var items:[cartModel]
    var address: String
    var price: Int
    var status: String
    var date: String
}


class HistoryVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var height:[Int] = []
    var historyData:[historyModel] = []
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.title = "Order History"
        self.collectionView!.register(HistoryItem.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchHistory()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HistoryItem
        
        let item = historyData[indexPath.row]
        
        cell.title.text = item.items[0].name
        cell.title.numberOfLines = 0
        cell.address.numberOfLines = 0
        cell.address.text = "Address: \(item.address)"
        cell.date.text = "Date: \(item.date)"
        cell.price.text = "Amount Paid: \(item.price)$"
        cell.status.text = "Status: \(item.status)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func fetchHistory(){
        let uid = Auth.auth().currentUser?.uid
        db.collection("orders").whereField("uid", isEqualTo: uid!).getDocuments { (snapshot, err) in
            if err == nil{
                snapshot?.documents.forEach({ (document) in
                    let item = document.data()
                    let jsonData = try! JSONSerialization.data(withJSONObject: item,
                                                              options: JSONSerialization.WritingOptions.prettyPrinted)
                    let json = try! JSONDecoder().decode(historyModel.self, from: jsonData)
                    print(item)
                    self.historyData.append(json)
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
    
    
  
  
}
