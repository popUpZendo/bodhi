//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Joseph Hall on 9/25/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedCell: UITableViewCell {
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    var sender = ""
    
    
    func configureCell(profile_image: UIImage, email: String, content: String, senderId: String) {
        setupProfile()
        self.profile_image.image = profile_image
        self.emailLbl.text = email
        self.contentLbl.text = content
        //print (senderId)
        let sender = "\"\(senderId)\""
        print (sender)
    }
    
    func setupProfile(){
        
        
        profile_image.layer.cornerRadius = profile_image.frame.size.width/2
        profile_image.clipsToBounds = true
        if let uid = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    //self.usernameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["pic"] as? String
                        
                    {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.profile_image?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
        }
    }
    
}
