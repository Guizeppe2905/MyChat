//
//  Service.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Service {
    
    static let shared = Service()
    
    init() {}
    
    func createNewUser(_ data: RegistrationModel, completion: @escaping(ResponseCode) -> ()) {
        
        Auth.auth().createUser(withEmail: data.email, password: data.password) { [weak self] result, error in
            if error == nil {
                if result != nil {
                    guard let userID = result?.user.uid else { return }
                    let nickname = data.nickname
                    let email = data.email
                    let password = data.password
                    let data: [String: Any] = ["nickname": nickname, "email": email, "password": password]
                    Firestore.firestore().collection("users").document(userID).setData(data)
                    completion(ResponseCode(code: 1))
                }
            }  else {
                completion(ResponseCode(code: 0))
            }
        }
    }
    
    func sendEmailConfirmation() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func login(_ data: RegistrationModel, completion: @escaping (AuthResponse) -> ()) {
        Auth.auth().signIn(withEmail: data.email, password: data.password) { [weak self] result, error in
            guard let self = self else { return }
            if error != nil {
                completion(.isUnknown)
            } else {
                if let result = result {
                    if result.user.isEmailVerified {
                        completion(.isVerified)
                    } else {
                        completion(.isRegistered)
                    }
                }
            }
        }
        
    }
    
    func getListOfUsers(completion: @escaping ([CurrentUserModel]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        var currentUsers = [CurrentUserModel]()
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email)
         
            .getDocuments { [weak self] snap, error in
            guard let self = self else { return }
           
            if error == nil {
              //  var emailList = [String]()
                if let docs = snap?.documents {
                    for doc in docs {
                        let data = doc.data()
                        let userID = doc.documentID
                        let email = data["email"]
                        let nickname = data["nickname"]
                        currentUsers.append(CurrentUserModel(id: userID, email: email as! String, nickname: nickname as! String))
                    }
                }
                completion(currentUsers)
            }
            
        }
    }
    
    func sendMessage(userID: String?, chatID: String?, text: String, completion: @escaping (String) -> ()) {
        let reference = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            if chatID == nil {
                guard let userID = userID else { return }
                let chatID = UUID().uuidString
                let selfData: [String : Any] = [
                    "date": Date(),
                    "otherID": userID
                ]
                let otherData: [String : Any] = [
                    "date": Date(),
                    "otherID": uid
                ]
                reference.collection("users").document(uid).collection("chats").document(chatID).setData(selfData)
                reference.collection("users").document(userID).collection("chats").document(chatID).setData(otherData)
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                
                let chatInfo: [String: Any] = [
                    "date": Date(),
                    "firstSender": uid,
                    "otherSender": userID
                ]
                reference.collection("chats").document(chatID).setData(chatInfo) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    reference.collection("chats").document(chatID).collection("messages").addDocument(data: msg) { error in
                        if error == nil {
                            completion(chatID)
                        }
//                        else {
//                            completion(false)
//                        }
                    }
                }
            } else {
                guard let chatID = chatID else { return }
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                reference.collection("chats").document(chatID).collection("messages").addDocument(data: msg) { [weak self] error in
                    if error == nil {
                        completion(chatID)
                    }
//                    else {
//                        completion(false)
//                    }
                }
            }
        }
    }
    
    func updateChats() {
        
    }
    
    func getChatID(userID: String, completion: @escaping (String) -> ()) {
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Firestore.firestore()
            reference.collection("users").document(uid).collection("chats").whereField("otherID", isEqualTo: userID).getDocuments { snap, error in
                if let error = error {
                    return
                }
                if let snap = snap, !snap.documents.isEmpty {
                    let doc = snap.documents.first
                    if let chatID = doc?.documentID {
                        completion(chatID)
                    }
                }
            }
        }
    }
    
    func getAllMessages(chatID: String, completion: @escaping ([Message]) -> ()) {
        if let uid = Auth.auth().currentUser?.uid {
 
            let reference = Firestore.firestore()
            reference.collection("chats").document(chatID).collection("messages").limit(to: 50).order(by: "date", descending: false)
                .addSnapshotListener { snap, error in
                    if error != nil {
                        return
                    }
                    if let snap = snap, !snap.documents.isEmpty {
                        var msgs = [Message]()
                        var sender = Sender(senderId: uid, displayName: "myself")
                        
                        for doc in snap.documents {
                            let data = doc.data()
                            let userID = data["sender"] as! String
                            
                            let messageID = doc.documentID
                            
                            let date = data["date"] as! Timestamp
                            let sentDate = date.dateValue()
                            let text = data["text"] as! String
                            if userID == uid {
                                sender = Sender(senderId: "1", displayName: "")
                            } else {
                                sender = Sender(senderId: "2", displayName: "")
                            }
                           
                            msgs.append(Message(sender: sender, messageId: messageID, sentDate: sentDate, kind: .text(text)))
                        }
                        completion(msgs)
                    }
                }
        }
    }
    
    func getOneMessage() {
        
    }
}
