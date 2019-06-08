//
//  ProdcutsItemCell.swift
//  Hermitage
//
//  Created by yogesh on 12/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import LBTATools

class ProductsItemCell: UICollectionViewCell {
    
    var image = UIImageView()
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(image.withHeight(150),
              title,
              alignment: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupView(){
//       self.addSubview(image)
//        self.addSubview(title)
//
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
//        image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
//        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.topAnchor.constraint(equalTo: image.topAnchor, constant: 160).isActive = true
//        title.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
//
//    }
    
}
