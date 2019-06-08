//
//  CartItemCell.swift
//  Hermitage
//
//  Created by yogesh on 14/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont

class CartItemCell: UICollectionViewCell {
    var count = UILabel()
    var title = UILabel()
    var removeButton = UIButton()
    let card = UIView()
    let addButton = UIButton()
    let subButton = UIButton()
    let countView = UIView()
    let price = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        count.text = "QTY: 0"
        count.font = count.font.withSize(14)
        price.text = "Price: $350.5"
        price.font = UIFont.boldSystemFont(ofSize: 14)
        
        countView.addSubview(subButton)
        countView.addSubview(count)
        countView.addSubview(addButton)
        countView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        card.addSubview(title)
        card.addSubview(price)
        card.addSubview(countView)
        card.layer.borderWidth = 0.5
        card.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
//        card.addSubview(removeButton)
        
        self.addSubview(card)
        
        addButton.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        
        subButton.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        subButton.setTitle("-", for: .normal)
        subButton.setTitleColor(.white, for: .normal)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: self.topAnchor, constant: 1).isActive = true
        card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        card.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8).isActive = true
        title.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: card.centerXAnchor, constant: -26).isActive = true
        
        price.translatesAutoresizingMaskIntoConstraints = false
        price.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        price.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8).isActive = true
        
        // count view start
        
        countView.translatesAutoresizingMaskIntoConstraints = false
        countView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        countView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        countView.layer.cornerRadius = 15
        countView.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        countView.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        
        subButton.translatesAutoresizingMaskIntoConstraints = false
        subButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor).isActive = true
        subButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        subButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        subButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        count.translatesAutoresizingMaskIntoConstraints = false
        count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: countView.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        //count view end
//
//        removeButton.translatesAutoresizingMaskIntoConstraints = false
//        removeButton.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
//        removeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        removeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        removeButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8).isActive = true
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addButton.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
        subButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15)
    }
}



extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
