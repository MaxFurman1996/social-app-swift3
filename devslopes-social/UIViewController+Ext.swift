//
//  UIViewController+Ext.swift
//  devslopes-social
//
//  Created by Max Furman on 7/24/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit


extension UIViewController {
    //Hide keyboard when you tap outside of keyboard
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
}
