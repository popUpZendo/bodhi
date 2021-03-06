//
//  readMeVC.swift
//  bodhi
//
//  Created by Joseph Hall on 10/26/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase

class readMeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var emailLbl: UILabel!
        @IBOutlet weak var menuBtn: UIButton!
        @IBOutlet weak var nameLbl: UILabel!
        @IBOutlet weak var sendBtn: UIButton!
        @IBOutlet weak var nameField: UITextField!
        @IBOutlet weak var popUpGroupField: UITextField!
        @IBOutlet weak var cityField: UITextField!
        @IBOutlet weak var stateField: UITextField!
        @IBOutlet weak var templeField: UITextField!
        @IBOutlet weak var teacherField: UITextField!
        @IBOutlet weak var practiceField: UITextField!
        
        
        
        let imagePicker = UIImagePickerController()
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            imagePicker.delegate = self
            nameField.delegate = self
            
            //        photoHelper.completionHandler = { image in
            //            PostService.create(for: image)
            //        }
            
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = false
            //profileImage.layer.borderColor = UIColor.blackColor().CGColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
            
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController()  .tapGestureRecognizer())
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.emailLbl.text = Auth.auth().currentUser?.email
        }
        
        
        @IBAction func sendBtnWasPressed(_ sender: Any) {
            if nameField.text != nil
                //            && textView.text != "Say something here..."
            {
                sendBtn.isEnabled = false
                
                DataService.instance.uploadBodhi(withName: nameField.text!, withPopUpGroup: popUpGroupField.text!, withCity: cityField.text!, withState: stateField.text!, withTemple: templeField.text!, withTeacher: teacherField.text!, withPractice: practiceField.text!, forUID: (Auth.auth().currentUser?.uid)!, withBodhiKey: nil, sendComplete: { (isComplete) in
                    if isComplete {
                        self.sendBtn.isEnabled = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.sendBtn.isEnabled = true
                        print("There was an error!")
                    }
                })
            }
        }
        
        
        @IBAction func profileWasTapped(sender: Any) {
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                profileImage.contentMode = .scaleToFill
                profileImage.image = pickedImage
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        //    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //        userPhoto.image = image
        //        dismissViewControllerAnimated(true, completion: nil)
        //        var data = NSData()
        //        data = UIImageJPEGRepresentation(userPhoto.image!, 0.8)!
        //        // set upload path
        //        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
        //        let metaData = FIRStorageMetadata()
        //        metaData.contentType = "image/jpg"
        //        self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //                return
        //            }else{
        //                //store downloadURL
        //                let downloadURL = metaData!.downloadURL()!.absoluteString
        //                //store downloadURL at database
        //                self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
        //            }
        //
        //        }
        //    }
        //
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        //    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        //        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        //        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
        //            do {
        //                try Auth.auth().signOut()
        //                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
        //                self.present(authVC!, animated: true, completion: nil)
        //            } catch {
        //                print(error)
        //            }
        //        }
        //        logoutPopup.addAction(logoutAction)
        //        present(logoutPopup, animated: true, completion: nil)
        //    }
        
        
    }
    
    extension readMeVC: UITextFieldDelegate {
        private func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
        }
}













