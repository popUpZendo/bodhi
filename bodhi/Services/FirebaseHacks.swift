//
//  FirebaseHacks.swift
//  bodhi
//
//  Created by Joseph Hall on 11/2/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation
import Firebase

let storageRef = Storage.storage().reference()
let databaseRef = Database.database().reference()

func setupProfileImage(){
    
    var profile_image: UIImageView!
    
    profile_image.layer.cornerRadius = profile_image.frame.size.width/2
    profile_image.clipsToBounds = true
    if let uid = Auth.auth().currentUser?.uid{
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]
            {
           
                if let profileImageURL = dict["pic"] as? String
                {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            
                            return
                        }
                        DispatchQueue.main.async {
                            profile_image?.image = UIImage(data: data!)
                        }
                    }).resume()
                    
                }
            }
        })
    }
}
