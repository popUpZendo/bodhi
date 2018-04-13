//
//  ChannelVC.swift
//  Smack
//
//  Created by Joseph Hall on 9/30/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        func logOut(completion:@escaping(_ errorOccured: Bool) -> Void)  {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
            } catch let signOutError as NSError {
                completion(true)
            }
            
            completion(false)
            
            
        }
    }
}
