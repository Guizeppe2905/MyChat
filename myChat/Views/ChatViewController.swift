//
//  ChatViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    var chatID: String?
    var userAva: String?
    var otherUserID: String?
    var userNick: String?
    
    var tempUsers: [CurrentUserModel] = []
    var otherUserVM: CurrentUserModel?
    var getMyself: CurrentUserModel?
    
   // let myself = Sender(senderId: "1", displayName: "", ava: UserSettings.shared.myselfAva)
    let myselfTrue = Sender(senderId: "1", displayName: "", photoURL: "")
    let otherUserTrue = Sender(senderId: "2", displayName: "", photoURL: "")
    
    var myAva: String?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .yellow
        
        self.title = userNick
      //  navigationItem.largeTitleDisplayMode = .never
//        let pm = PrivateRoomChatViewController()
//        self.chatID = pm.chatID
//        self.otherUserID = pm.otherUserID
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
       
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        messageInputBar.sendButton.layer.cornerRadius = 10
        messageInputBar.sendButton.setTitle("", for: .normal)
      //  messageInputBar.sendButton.frame = CGRect(x: 300, y: 600, width: 150, height: 30)
//        messageInputBar.sendButton.translatesAutoresizingMaskIntoConstraints = false
//        messageInputBar.sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
//        messageInputBar.sendButton.widthAnchor.constraint(equalToConstant: 250).isActive = true;
//        messageInputBar.sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true;
//        messageInputBar.sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageInputBar.sendButton.backgroundColor = .systemPink
        messageInputBar.sendButton.tintColor = .white
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.inputTextView.placeholder = "Введите текст сообщения..."
//        messagesCollectionView.contentInsetAdjustmentBehavior = .automatic
//        messagesCollectionView.clipsToBounds = true
        showMessageTimestampOnSwipeLeft = true
        messageInputBar.delegate = self
        
        if chatID == nil {
            guard let id = otherUserID else { return }
            Service.shared.getChatID(userID: id) { [weak self] chatId in
                self?.chatID = chatId
                self?.getMessages(chatID: chatId)
            }
        } else {
            guard let chatID = chatID else { return }
            getMessages(chatID: chatID)

        }
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
    }
    
    private func getMessages(chatID: String) {
        Service.shared.getAllMessages(chatID: chatID) { [weak self] messages in
            self?.messages = messages
            self?.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        return myselfTrue
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        let borderColor: UIColor = isFromCurrentSender(message: message) ? .systemPink: .clear
        return .bubbleTailOutline(borderColor, corner, .curved)
    }
    
   
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? .systemPink: .lightGray
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        print("THE  FULL LIST +++++ \(UserSettings.shared.myselfAva)")
        print("MY UID NOW - \(Auth.auth().currentUser?.uid)")
        guard let test444 = Auth.auth().currentUser?.uid else {
            print("fuck fuck strange here")
            return }
        
//        guard let currentChatID = chatID else {
//            print("fuck fuck strange here222222")
//            return }
 
        let myNewTryAva = UserSettings.shared.myselfAva[test444]
        
        print("NOR BAD IF WE GOT IT \(myNewTryAva)")
        
        if chatID == "kjhk" {
            print("THIS IS FORUM")
            if message.sender.senderId == myselfTrue.senderId {
                
                guard let myFinalAva = myNewTryAva else {
                    "WTF WTF WTF"
                    avatarView.image = UIImage(named: "ava1")
                    return
                }
                
                if myNewTryAva == nil || myFinalAva == "" || myFinalAva == "ava1" {
                    print("WE ARE HERERERERE!!!!!")
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    print("NOW HERE MYSEFL")
                    Service.shared.loadChatImage(stringUrl: myFinalAva, completion: { [weak self] (image) in
                        print("MY AVA FROM GALARY")
                        avatarView.image = image
                    })
                    
                }
                
            } else {
                print("ANOUTH FORRUM USERS")
                let defaultsAvatars = ["ava1", "ava2", "ava3", "ava4", "ava5", "ava6"]
                avatarView.image = UIImage(named: defaultsAvatars.randomElement() ?? "ava6")
            }
            
        } else {
            if message.sender.senderId == myselfTrue.senderId {
                
                guard let myFinalAva = myNewTryAva else {
                    "WTF WTF WTF"
                    avatarView.image = UIImage(named: "ava1")
                    return
                }
                
                if myNewTryAva == nil || myFinalAva == "" || myFinalAva == "ava1" {
                    print("WE ARE HERERERERE!!!!!")
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    print("NOW HERE MYSEFL")
                    Service.shared.loadChatImage(stringUrl: myFinalAva, completion: { [weak self] (image) in
                        print("MY AVA FROM GALARY")
                        avatarView.image = image
                    })
                    
                }
                
            } else if message.sender.senderId == otherUserTrue.senderId {
                print("CHECK \(otherUserVM)")
                guard let viewModel = otherUserVM else {
                    print("UPS")
                    return }
                print("AVAVAVAVAVAV \(viewModel.photoURL)")
                
                guard let secondUserAva = viewModel.photoURL else { return }
                if viewModel.photoURL == nil || secondUserAva == "" || secondUserAva == "ava1" {
                    print("HERE")
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    print("NOW HERE")
                    guard let otherUserAva = userAva else {
                        print("JUST IN CSE")
                        return }
                    Service.shared.loadChatImage(stringUrl: otherUserAva, completion: { [weak self] (image) in
                        avatarView.image = image
                        print("GOT IT")
                    })
                }
                
            } else {
                avatarView.image = UIImage(named: "ava1")
                print("fuck ======")
            }
        }
    }
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let size = CGSize(width: 50, height: 50)
        return size
    }
    }
 
//}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let msg = Message(sender: myselfTrue, messageId: "", sentDate: Date(), kind: .text(text))
        messages.append(msg)
        
        Service.shared.sendMessage(userID: self.otherUserID, chatID: self.chatID, text: text) { [weak self] chatId in
            
            DispatchQueue.main.async {
                inputBar.inputTextView.text = nil
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
            self?.chatID = chatId
        }
    }
}
