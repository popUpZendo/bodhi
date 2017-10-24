//
//  LogInVC.swift
//  bodhi
//
//  Created by Joseph Hall on 10/22/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    //variables
    let databaseRef = Database.database().reference(fromURL: "https://codebeanprofile.firebaseio.com/")
    
    //outlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //actions
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        signup()
    }
    
    //func
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func login() {
        guard let email = email.text else{
            print("email issue")
            return
        }
        guard let password = password.text else{
            print("password issue")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func signup() {
        guard let username = username.text else{
            print("email issue")
            return
        }
        guard let email = email.text else{
            print("password issue")
            return
        }
        guard let password = password.text else{
            print("password issue")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            let userReference = self.databaseRef.child("users").child(uid)
            let values = ["username": username, "email": email, "pic": ""]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        })
    }
    
}


