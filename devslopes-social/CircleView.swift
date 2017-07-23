//
//  CircleView.swift
//  devslopes-social
//
//  Created by Max Furman on 7/22/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    


}
