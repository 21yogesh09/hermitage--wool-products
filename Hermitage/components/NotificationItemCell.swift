
//
//  NotificationItemCell.swift
//  Hermitage
//
//  Created by yogesh on 24/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit

class NotificationItemCell: UICollectionViewCell {
    var title = UILabel()
    var date = UILabel()
    var card = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        card.addSubview(title)
        card.addSubview(date)
        
        self.addSubview(card)
        setupCard()
        setupElements()
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
    
    func setupElements(){
        title.font = .boldSystemFont(ofSize: 16)
        date.font = .boldSystemFont(ofSize: 16)
        title.numberOfLines = 0
        date.textColor = .gray
        date.textAlignment = .right
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: card.topAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10).isActive = true
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10).isActive = true
        date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        date.textAlignment = .right
    }

    
}

