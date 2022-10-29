//
//  Service.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import ProgressHUD

class Service {
    
    static let shared = Service()
 
    let defaultsAvatars = ["ava1", "ava2", "ava3", "ava4", "ava5", "ava6"]
    init() {}
    
    func sendEmailConfirmation() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func getListOfUsers(completion: @escaping ([CurrentUserModel]) -> ()) {
        ProgressHUD.show("Идет загрузка...")
        guard let email = Auth.auth().currentUser?.email else { return }
        
        var currentUsers = [CurrentUserModel]()
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email)
         
            .getDocuments { [weak self] snap, error in
                guard self != nil else { return }
           
            if error == nil {

                if let docs = snap?.documents {
                    for doc in docs {
                        let data = doc.data()
                        let userID = doc.documentID
                        let email = data["email"]
                        let nickname = data["nickname"]
                        let photoURL = data["photoURL"]
                        currentUsers.append(CurrentUserModel(id: userID, email: email as! String, nickname: nickname as! String, photoURL: photoURL as? String))
                    }
                }
                ProgressHUD.dismiss()
                completion(currentUsers)
            }
        }
    }
    
    func getChatID(userID: String, completion: @escaping (String) -> ()) {
        if let uid = Auth.auth().currentUser?.uid {
            let reference = Firestore.firestore()
            reference.collection("users").document(uid).collection("chats").whereField("otherID", isEqualTo: userID).getDocuments { snap, error in
                if error != nil {
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
    
    func createNewUser(_ data: RegistrationModel, completion: @escaping(ResponseCode) -> ()) {
        
        Auth.auth().createUser(withEmail: data.email, password: data.password) { result, error in
            if error == nil {
                if result != nil {
                    guard let userID = result?.user.uid else { return }
                    let nickname = data.nickname
                    let email = data.email
                    let password = data.password
                    let photoURL = data.photoURL
                    let data: [String: Any] = ["nickname": nickname, "email": email, "password": password, "photoURL": photoURL]
                    Firestore.firestore().collection("users").document(userID).setData(data)
                    UserSettings.shared.myselfAva[Auth.auth().currentUser?.uid ?? ""] = "ava1"
                    
                    print("UPDATE REG +++ \(UserSettings.shared.myselfAva)")
                    completion(ResponseCode(code: 1))
                }
            }  else {
                completion(ResponseCode(code: 0))
            }
        }
    }
    
    func login(_ data: RegistrationModel, completion: @escaping (AuthResponse) -> ()) {
        Auth.auth().signIn(withEmail: data.email, password: data.password) { result, error in
        
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

                    }
                }
            } else {
                guard let chatID = chatID else { return }
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                reference.collection("chats").document(chatID).collection("messages").addDocument(data: msg) {  error in
                    if error == nil {
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
                        
                        var sender = Sender(senderId: uid, displayName: "myself", photoURL: "ava1")
                        
                        for doc in snap.documents {
                            let data = doc.data()
                            let userID = data["sender"] as! String
                            
                            let messageID = doc.documentID
                            
                            let date = data["date"] as! Timestamp
                            let sentDate = date.dateValue()
                            let text = data["text"] as! String
                            if userID == uid {
                                sender = Sender(senderId: "1", displayName: "", photoURL: "ava1")
                            } else {
                                sender = Sender(senderId: "2", displayName: "", photoURL: "ava6")
                            }
                           
                            msgs.append(Message(sender: sender, messageId: messageID, sentDate: sentDate, kind: .text(text)))
                        }
                        completion(msgs)
                    }
                }
        }
    }
 
    func sendMessageWithPhoto(userID: String?, chatID: String?, text: UIImage, completion: @escaping (String) -> ()) {
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
                        
                    }
                }
            } else {
                guard let chatID = chatID else { return }
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                reference.collection("chats").document(chatID).collection("messages").addDocument(data: msg) { error in
                    if error == nil {
                        completion(chatID)
                    }
                }
            }
        }
    }

    func updateAvaName(withID: String, newAvaName: String){
        let newAva = newAvaName

        let userID = withID

        let data: [String: Any] = ["photoURL": newAva]
        Firestore.firestore().collection("users").document(userID).updateData(data) { result in
            if result != nil {
         //
            } else {
          //
                }
        }
    }
    
    func updateNickName(withID: String, newNickName: String, completion: @escaping(ResponseCode) -> ()) {
        let newNick = newNickName
        
        let userID = withID
        
        let data: [String: Any] = ["nickname": newNick]
        Firestore.firestore().collection("users").document(userID).updateData(data) { result in
            if result != nil {
            completion(ResponseCode(code: 1))
            } else {
                completion(ResponseCode(code: 0))
            }
    }
    }
 
    func updateUser(withEmail: String, image: UIImage, filename: String, completion: @escaping(ResponseCode) -> ()) {

        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let photoURL = image.pngData() else { return }
        let fileName = filename
        let data: [String: Any] = ["photoURL": photoURL]
    
        Firestore.firestore().collection("users").document(userID).updateData(data) {  result in
                if result != nil {
                    StorageManager.shared.uploadProfilePicture(with: photoURL, fileName: fileName, completion: { results in
                        switch results {
                        case .success(let downloadUrl):
                            Service.shared.updateAvaName(withID: userID, newAvaName: "\(downloadUrl)")
                            print(downloadUrl)
                            UserSettings.shared.myselfAva[Auth.auth().currentUser?.uid ?? ""] = downloadUrl
                            print("WE SAVED \(downloadUrl)")
                            
                            print("WE CHECK = \(UserSettings.shared.myselfAva)")
                        case .failure(let error):
                            print("Storage error: \(error)")
                        }
                    })
                completion(ResponseCode(code: 1))
                } else {
                    completion(ResponseCode(code: 0))
                }
        }
    }

    func updateUserNickname(withEmail: String, newNickname: String, completion: @escaping(ResponseCode) -> ()) {

        guard let userID = Auth.auth().currentUser?.uid else { return }
     
        let nickname = newNickname
        let data: [String: Any] = ["nickname": nickname]
        
    
        Firestore.firestore().collection("users").document(userID).updateData(data) { result in
       
                if result != nil {
                    Service.shared.updateNickName(withID: userID, newNickName: nickname, completion: { error in
                        if error == error {
                            print(error)
                        } else {
                            completion(ResponseCode(code: 1))
                        }
                    })
             
                completion(ResponseCode(code: 1))
                } else {
                    completion(ResponseCode(code: 0))
                    
                }
        }
    }
    
    func loadImage(stringUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        if stringUrl.contains("ava1") || stringUrl == "" {
            guard let image = defaultsAvatars.randomElement() else { return }
            completion(UIImage(named: image))
        } else {
            guard let url = URL(string: stringUrl) else { return }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
            task.resume()
        }
    }
    
    func loadChatImage(stringUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        if stringUrl.contains("ava1") || stringUrl == "" {
            let image = "ava1"
            completion(UIImage(named: image))
        } else {
            guard let url = URL(string: stringUrl) else { return }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
            task.resume()
        }
    }
}
