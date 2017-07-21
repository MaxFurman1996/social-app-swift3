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
    
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passField: FancyTextField!
    
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
                print("Unable to sign in with Firebase")
            } else {
                print("Sucessful sign in with Firebase")
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text{
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("Unable to authenticate in with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate in with Firebase using email")
                        } else {
                            print("Successfully authenticated with Firebase")
                        }
                    
                    })
                }
                
            })
        }
    }
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var fancyView: FancyView!
    



}

