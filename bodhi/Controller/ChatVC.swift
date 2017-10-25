//
//  ChatVC.swift
//  Smack
//
//  Created by Joseph Hall on 9/30/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController()  .tapGestureRecognizer())
        
    }
    
}
