//
//  ChooseProductVC.swift
//  Hermitage
//
//  Created by yogesh on 23/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class ChooseProductVC: UICollectionViewController {
    
    var estimatWidth = 160
    var cellMarginSize = 8.0
    var db: Firestore!
    var type = ""
    
    var productmodel: [productModel]!
    private let cellReuseIdentifier = "collectionCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.title = "Choose a Gift"
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(GiftItemCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        db.collection("products").whereField("offerid", isEqualTo: type).getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!)
            }
            let results = querySnapshot?.documents.map { (document) -> productModel in
                if let task = productModel(dictionary: document.data()){
                    return task
                } else {
                    print(document)
                    fatalError("Unable to initialize type \(productModel.self) with dictionary \(document.data())")
                }
            }
            self.productmodel = results
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productmodel?.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GiftItemCell
        let imageurl = URL(string: productmodel[indexPath.row].image[0])
        cell.image.sd_setImage(with: imageurl, completed: nil)
        cell.title.text = productmodel[indexPath.row].name
        cell.size.text = "Size: \(productmodel[indexPath.row].sizes[0])"
        cell.Button.tag = indexPath.row
        cell.Button.addTarget(self, action: #selector(openItem(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func openItem(sender: UIButton){
        let tag = sender.tag
        let vc = SendGiftVC()
        let data = productmodel[tag]
        vc.giftItem = data
        //        vc.productTitle.text = data.name
        //        vc.productImage.sd_setImage(with: URL(string: data.image), completed: nil)
        //        vc.productDescription.text = data.desc
        //        vc.specifications.text = data.specs
        //        vc.prices = data.price
        //        vc.sizes = data.sizes
        navigationController?.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc = SendGiftVC()
//        let data = productmodel[indexPath.row]
//        vc.giftItem = data
////        vc.productTitle.text = data.name
////        vc.productImage.sd_setImage(with: URL(string: data.image), completed: nil)
////        vc.productDescription.text = data.desc
////        vc.specifications.text = data.specs
////        vc.prices = data.price
////        vc.sizes = data.sizes
//        navigationController?.hidesBottomBarWhenPushed = false
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension ChooseProductVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calulateWidth()
        return CGSize(width: width, height: 240)
    }
    
    func calulateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimatWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}
  

