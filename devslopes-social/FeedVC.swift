//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Max Furman on 7/21/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    @IBAction func signOutBtnPressed(_ sender: Any) {
        let keychainRemoveResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MAX: Id removed from keychain \(keychainRemoveResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
