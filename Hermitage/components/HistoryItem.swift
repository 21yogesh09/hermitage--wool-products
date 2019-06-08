//
//  HistoryItem.swift
//  Hermitage
//
//  Created by yogesh on 17/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import LBTATools

class HistoryItem: UICollectionViewCell {
    
    var title = UILabel()
    var price = UILabel()
    var address = UILabel()
    var date = UILabel()
    var status = UILabel()
    var card = UIView()
    let nameandDateStack = UIStackView()
    let addressPriceStack = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        date.numberOfLines = 0
        price.numberOfLines = 0
        nameandDateStack.addArrangedSubview(title)
        nameandDateStack.addArrangedSubview(date)
        addressPriceStack.addArrangedSubview(address)
        addressPriceStack.addArrangedSubview(price)
        card.addSubview(nameandDateStack)
        card.addSubview(addressPriceStack)
        card.addSubview(status)
        
        self.addSubview(card)
        setupCard()
        setupNameandDate()
        setupAddressPrice()
    }
    
    func setupCard(){
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.shadowColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        card.layer.cornerRadius = 4
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 10
        card.backgroundColor = .white
        
        card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        card.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        card.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupNameandDate(){
        title.font = .boldSystemFont(ofSize: 16)
        date.font = .boldSystemFont(ofSize: 16)
        date.textColor = .gray
        date.textAlignment = .right
        
        nameandDateStack.translatesAutoresizingMaskIntoConstraints = false
        nameandDateStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10).isActive = true
        nameandDateStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10).isActive = true
        nameandDateStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10).isActive = true
    }
    
    func setupAddressPrice(){
        address.font = address.font.withSize(13)
        address.textColor = .gray
        price.font = .boldSystemFont(ofSize: 16)
        price.textColor = UIColor(red:0.27, green:0.80, blue:0.27, alpha:1.0)
        price.textAlignment = .right
        
        addressPriceStack.translatesAutoresizingMaskIntoConstraints = false
        addressPriceStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10).isActive = true
        addressPriceStack.topAnchor.constraint(equalTo: nameandDateStack.bottomAnchor, constant: 10).isActive = true
        addressPriceStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10).isActive = true
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10).isActive = true
        status.topAnchor.constraint(equalTo: addressPriceStack.bottomAnchor, constant: 10).isActive = true
        status.textColor = UIColor(red:0.14, green:0.59, blue:0.95, alpha:1.0)
         status.font = .boldSystemFont(ofSize: 14)
    }
    
}
