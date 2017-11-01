//
//  DataService.swift
//  breakpoint
//
//  Created by Caleb Stultz on 7/22/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_BUDDHA = DB_BASE.child("Buddha")
    private var _REF_BODHI = DB_BASE.child("bodhi")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    var REF_BUDDHA: DatabaseReference {
        return _REF_BUDDHA
    }
    
    var REF_BODHI: DatabaseReference {
        return _REF_BODHI
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    

    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    
    func uploadBodhi(withName name: String, withPopUpGroup popUpGroup: String, withCity city: String, withState state: String, withTemple temple: String, withTeacher teacher: String, withPractice practice: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
                if bodhiKey != nil {
                    REF_BODHI.child(bodhiKey!).child("profile").childByAutoId().setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice, "senderId": uid])
                    sendComplete(true)
                } else {
                    REF_BODHI.child(uid).setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice,"senderId": uid])
                    sendComplete(true)
                }
            }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
    }
    
    func getAllBodhi(handler: @escaping (_ bodhi: [Bodhi]) -> ()) {
        var bodhiArray = [Bodhi]()
        REF_BODHI.observeSingleEvent(of: .value) { (bodhiSnapshot) in
            guard let bodhiSnapshot = bodhiSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for bodhi in bodhiSnapshot {
                let name = bodhi.childSnapshot(forPath: "Name").value as! String
                let popUpGroup = bodhi.childSnapshot(forPath: "PopUpGroup").value as! String
                let city = bodhi.childSnapshot(forPath: "City").value as! String
                let state = bodhi.childSnapshot(forPath: "State").value as! String
                let temple = bodhi.childSnapshot(forPath: "Temple").value as! String
                let teacher = bodhi.childSnapshot(forPath: "Teacher").value as! String
                let practice = bodhi.childSnapshot(forPath: "Practice").value as! String
                let senderId = bodhi.childSnapshot(forPath: "senderId").value as! String
                //let key = bodhi.childSnapshot(forPath: "key").value as! String
                let bodhi = Bodhi(name: name, popUpGroup: popUpGroup, city: city, state: state, temple: temple, teacher: teacher, practice: practice, senderId: senderId, key: bodhi.key)
                bodhiArray.append(bodhi)
                print(bodhiArray)
            }
            
            handler(bodhiArray)
        }
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String] ()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        //    need to add code here for slow internet: if successful connection true else error
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return}
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    //    func getBuddha(handler: @escaping (_ buddhaArray: [Buddha]) -> ()) {
    //        var buddhaArray = [Buddha]()
    //        REF_BUDDHA.observeSingleEvent(of: .value) { (buddhaSnapshot) in
    //            guard let buddhaSnapshot = buddhaSnapshot.children.allObjects as? [DataSnapshot] else { return}
    //            for buddha in buddhaSnapshot {
    //                let memberArray = buddha.childSnapshot(forPath: "members").value as! [String]
    //                if buddhaArray.contains((Auth.auth().currentUser?.uid)!) {
    //                    let name = buddha.childSnapshot(forPath: "name").value as! String
    //                    let popUpGroup = buddha.childSnapshot(forPath: "popUpGroup").value as! String
    //                    let buddha = Buddha(name: name, city: city, key: key, temple: temple, popUpGroup: popUpGroup, teacher: teacher, practice: practice)
    //                    buddhaArray.append(buddha)
    //                }
    //            }
    //            handler(buddhaArray)
    //        }
    //    }
    //
}














