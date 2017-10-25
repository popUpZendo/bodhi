//
//  UIViewControllerExt.swift
//  breakpoint
//
//  Created by Joseph Hall on 9/27/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transistion = CATransition()
        transistion.duration = 0.3
        transistion.type = kCATransitionPush
        transistion.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transistion, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetail() {
    
    let transistion = CATransition()
    transistion.duration = 0.3
    transistion.type = kCATransitionPush
    transistion.subtype = kCATransitionFromLeft
    self.view.window?.layer.add(transistion, forKey: kCATransition)
        
    dismiss(animated: false, completion: nil)
    }
}
