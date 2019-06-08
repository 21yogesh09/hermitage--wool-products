//
//  GiftItemCell.swift
//  Hermitage
//
//  Created by yogesh on 23/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import LBTATools

class GiftItemCell: UICollectionViewCell {
    var image = UIImageView()
    var title = UILabel()
    var size = UILabel()
    let bgcolor = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
    let Button = UIButton(title: "Select", titleColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Button.backgroundColor = bgcolor
        Button.withWidth(self.frame.width / 1.2)
        Button.withHeight(40)
        Button.layer.cornerRadius = 20
        size.textColor = .gray
        size.withHeight(25)
        
        stack(image.withHeight(150),
              title,
              size,
              Button,
              alignment: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}
