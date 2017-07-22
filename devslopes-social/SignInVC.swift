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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passField: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebooLoginBtnPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("MAX: User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential){ (user, error) in
            if (error != nil) {
                print("MAX: Unable to sign in with Firebase")
            } else {
                print("MAX: Sucessful sign in with Firebase")
                if let user = user {
                    self.completeSignIn(userId: user.uid)
                }
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text{
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("MAX: Unable to authenticate in with Firebase")
                    if let user = user {
                        self.completeSignIn(userId: user.uid)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("MAX: Unable to authenticate in with Firebase using email")
                        } else {
                            print("MAX: Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(userId: user.uid)
                            }
                        }
                    
                    })
                }
                
            })
        }
    }
    
    //Save user id to keychain
    func completeSignIn(userId id: String){
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("MAX: Data save to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }


}

