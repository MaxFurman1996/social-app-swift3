//
//  Post.swift
//  devslopes-social
//
//  Created by Max Furman on 7/23/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _userName: String!
    private var _postRef: DatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
    var likes: Int{
        return _likes
    }
    
    var postKey: String{
        return _postKey
    }
    
    var userName: String{
        return _userName
    }
    
    init(caption: String, imageUrl: String, userName: String, likes: Int) {
        self._caption = caption
        self._likes = likes
        self._imageUrl = imageUrl
        self._userName = userName
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>) {
        self._postKey = postKey

        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        if let userName = postData["userName"] as? String{
            self._userName = userName
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool){
        if addLike{
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
