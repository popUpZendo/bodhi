//
//  MeVC.swift
//  breakpoint
//
//  Created by Caleb Stultz on 7/24/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    @IBOutlet weak var profile_image: UIImageView!
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
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    @IBOutlet weak var testBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       imagePicker.delegate = self
        nameField.delegate = self
        popUpGroupField.delegate = self
        
        
        
//        if Auth.auth().currentUser?.uid == nil{
//            logout()
//        }
        
        setupProfile()
        setUpProfileText()
        
        
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController()  .tapGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        
    }

    // Function to test
    @IBAction func testBtnPressed(_ sender: Any) {
    }
    
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if nameField.text != nil
            && nameField.text != nil
            && popUpGroupField != nil
            && cityField != nil
            && stateField != nil
            && templeField != nil
            && teacherField != nil
            && practiceField != nil
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
    
    @IBAction func profileWasTapped(sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
   
    
    func setUpProfileText() {
        
        let ref = Database.database().reference(fromURL: "https://pop-up-zendo-d462d.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        let usersRef = ref.child("bodhi").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["Name"] as? String ?? ""
            let popUpGroup = value?["PopUpGroup"] as? String ?? ""
            let city = value?["City"] as? String ?? ""
            let state = value?["State"] as? String ?? ""
            let temple = value?["Temple"] as? String ?? ""
            let teacher = value?["Teacher"] as? String ?? ""
            let practice = value?["Practice"] as? String ?? ""
            self.nameField.text = name
            self.popUpGroupField.text = popUpGroup
            self.cityField.text = city
            self.stateField.text = state
            self.templeField.text = temple
            self.teacherField.text = teacher
            self.practiceField.text = practice
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profile_image.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func saveChanges(){
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.profile_image.image!)
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
    
}

extension MeVC: UITextFieldDelegate {
    private func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}












