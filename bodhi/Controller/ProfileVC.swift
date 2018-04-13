//
//  ProfileVC.swift
//  bodhi
//
//  Created by Joseph Hall on 10/22/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //variables
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    //outlets
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var popUpGroupLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var templeLbl: UILabel!
    @IBOutlet weak var teacherLbl: UILabel!
    @IBOutlet weak var practiceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }
        
        setupProfile()
        setUpProfileText()
        
        
    }
    
    //actions
    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    @IBAction func saveChanges(_ sender: Any) {
        saveChanges()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutButton(_ sender: Any) {
        logout()
    }
    
    // app is not logging in new users.  I think this is the cause of the crash below.
    
    //func
    func setUpProfileText() {
        
        let ref = Database.database().reference(fromURL: "https://pop-up-zendo-d462d.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        let usersRef = ref.child("bodhi").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let name = value?["Name"] as? String ?? ""
            let popUpGroup = value?["PopUpGroup"] as? String ?? ""
            let city = value?["City"] as? String ?? ""
            let state = value?["State"] as? String ?? ""
            let temple = value?["Temple"] as? String ?? ""
            let teacher = value?["Teacher"] as? String ?? ""
            let practice = value?["Practice"] as? String ?? ""
            //self.nameLbl.text = name
            self.popUpGroupLbl.text = popUpGroup
            self.cityLbl.text = city
            self.stateLbl.text = state
            self.templeLbl.text = temple
            self.teacherLbl.text = teacher
            self.practiceLbl.text = practice
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setupProfile(){
        
        
        profile_image.layer.cornerRadius = profile_image.frame.size.width/2
        profile_image.clipsToBounds = true
        if let uid = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.usernameLabel.text = dict["username"] as? String
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
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
        present(loginViewController, animated: true, completion: nil)
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




