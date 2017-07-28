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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        //Get posts from Firebase
        DataService.ds.REF_POSTS.observe(.value, with: { snapshot in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configure(post: post, img: img)
            } else {
                cell.configure(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = img
            imageSelected = true
        } else {
            print("MAX: A valid image wasn't selected")
        }
        dismiss(animated: true, completion: nil)
    }


    @IBAction func addImagePressed(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Send data to Firebase
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("MAX: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
           print("MAX: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imageData, metadata: metadata){(metadata, error) in
                if error != nil {
                    print("MAX: Unable to upload image to Firebase storage")
                } else {
                    print("MAX: Successfully uploaded image to Firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl{
                        DataService.ds.REF_USER_CURRENT.child("userName").observe(.value, with: {(snapshot) in
                            if let name = snapshot.value as? String {
                                let userName = name
                                print(userName)
                                self.postToFirebase(userName: userName, imgUrl: url)
                            } else {
                                self.postToFirebase(userName: "NoName", imgUrl: url)
                            }
                        })
                    }
                }
                
            }
        }
    }
    
    //Send post to Firebase and update tableview
    func postToFirebase(userName: String, imgUrl: String){
        
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "userName": userName,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        self.tableView.reloadData()
        self.dismissKeyboard()
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let keychainRemoveResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MAX: Id removed from keychain \(keychainRemoveResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        print("back to sign in")
    }

}
