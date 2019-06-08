//
//  ProdcutsList.swift
//  Hermitage
//
//  Created by yogesh on 12/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage

public struct productModel {
    var name:String
    var price:[Any]
    var sizes:[Any]
    var gsm:[Any]
    var fabric:[Any]
    var desc: String
    var image: [String]
    var specs: String
    var dictionary: [String: Any] {
        return [
            "name": name,
            "price": price,
            "sizes": sizes,
            "desc": desc,
            "image": image,
            "specs": specs,
            "gsm": gsm,
            "fabric": fabric
        ]
    }
}

class ProductsList: UICollectionViewController {
    var Data = [#imageLiteral(resourceName: "firstproduct"),#imageLiteral(resourceName: "secondproduct"),#imageLiteral(resourceName: "thirdproduct"),#imageLiteral(resourceName: "fourthproduct"),#imageLiteral(resourceName: "fifthproduct")]
    var estimatWidth = 160
    var cellMarginSize = 8.0
    var db: Firestore!
    var type = ""
    
    var productmodel: [productModel]!
     private let cellReuseIdentifier = "collectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ProductsItemCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        fetchData()
    }
    
    
    func fetchData() {
        db.collection("products").whereField("type", isEqualTo: type).getDocuments { (querySnapshot, error) in
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ProductsItemCell
        let imageurl = URL(string: productmodel[indexPath.row].image[0])
        cell.image.sd_setImage(with: imageurl, completed: nil)
        cell.title.text = productmodel[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetailVC()
        let data = productmodel[indexPath.row]
        vc.productTitle.text = data.name
        vc.imageNames = data.image
//        vc.productImage.sd_setImage(with: URL(string: data.image), completed: nil)
        vc.productDescription.text = data.desc
        vc.specifications.text = data.specs
        vc.prices = data.price
        vc.sizes = data.sizes as! [String]
        vc.gsms = data.gsm as! [String]
        vc.fabrics = data.fabric as! [String]
        navigationController?.hidesBottomBarWhenPushed = false
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension ProductsList: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calulateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calulateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimatWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}

extension productModel{
    init?(dictionary: [String : Any]) {
        guard      let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? [Any],
            let sizes = dictionary["sizes"] as? [Any],
            let gsm = dictionary["gsm"] as? [Any],
            let fabric = dictionary["fabric"] as? [Any],
            let desc = dictionary["description"] as? String,
            let specs = dictionary["specification"] as? String,
            let image = dictionary["image"] as? [String]
            else { return nil }
        
        self.init(name: name, price: price, sizes: sizes, gsm: gsm, fabric: fabric, desc: desc, image: image, specs: specs)
    }
}

