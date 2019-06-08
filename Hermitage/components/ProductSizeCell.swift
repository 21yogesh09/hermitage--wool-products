//
//  ProductSizeCell.swift
//  Hermitage
//
//  Created by yogesh on 16/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit

class ProductSizeCell: UICollectionViewCell {
    
    var wrapper = UIView()
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        wrapper.layer.cornerRadius = 20
        wrapper.layer.borderColor = UIColor.gray.cgColor
        wrapper.layer.borderWidth = 0.4
        
        title.font = title.font.withSize(14)
        wrapper.addSubview(title)
        
        self.addSubview(wrapper)
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wrapper.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor).isActive = true
        
    }
    
}
