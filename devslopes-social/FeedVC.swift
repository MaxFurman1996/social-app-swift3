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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }


    @IBAction func signOutBtnPressed(_ sender: Any) {
        let keychainRemoveResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MAX: Id removed from keychain \(keychainRemoveResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
