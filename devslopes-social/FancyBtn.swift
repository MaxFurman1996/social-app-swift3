//
//  FancyBtn.swift
//  devslopes-social
//
//  Created by Max Furman on 7/20/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
        layer.cornerRadius = 2.0
    }
    
    //Configure custom shadow
    func configureShadow() {
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }

}
