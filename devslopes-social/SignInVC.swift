//
//  ViewController.swift
//  devslopes-social
//
//  Created by Max Furman on 7/19/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class SignInVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        
    }
    
    @IBAction func facebooLoginBtnPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential){ (user, error) in
            if (error != nil) {
                print("Unable to sign in with firebase")
            } else {
                print("Sucessful sign in with firebase")
            }
        }
    }


}

