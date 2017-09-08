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
        
        self.hideKeyboard()
        
        //Function that move view when keyboard will show or hide
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    //Facebook auth
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
                    let userData = [
                        "userName": user.displayName ?? "NoName",
                        "provider": credential.provider
                    ]
                    self.completeSignIn(userId: user.uid, userData: userData)
                }
            }
        }
    }
    
    //Sign in with email and password
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text{
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("MAX: Unable to authenticate in with Firebase")
                    if let user = user {
                        let userName = email.components(separatedBy: "@")[0]
                        let userData = [
                            "userName": userName,
                            "provider": user.uid
                        ]
                        self.completeSignIn(userId: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("MAX: Unable to authenticate in with Firebase using email")
                        } else {
                            print("MAX: Successfully authenticated with Firebase")
                            if let user = user {
                                let userName = email.components(separatedBy: "@")[0]
                                let userData = [
                                    "userName": userName,
                                    "provider": user.providerID
                                ]
                                self.completeSignIn(userId: user.uid, userData: userData)
                            }
                        }
                    
                    })
                }
                
            })
        }
    }
    
    //Save user id to keychain
    func completeSignIn(userId: String, userData: Dictionary<String,String>){
        DataService.ds.createFirebaseDBUser(uid: userId, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(userId, forKey: KEY_UID)
        print("MAX: Data save to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

    //move view when keyboard will show or hide
    @IBOutlet weak var topView: FancyView!
    
    func keyboardWillShow(notification: NSNotification) {
        print("MAX: keyboardWillShow")
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= topView.frame.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("MAX: keyboardWillHide")
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += topView.frame.height
        }
    }
    
}

