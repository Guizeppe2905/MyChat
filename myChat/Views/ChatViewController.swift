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
    
    let myselfTrue = Sender(senderId: "1", displayName: "", photoURL: "")
    let otherUserTrue = Sender(senderId: "2", displayName: "", photoURL: "")
    
    var myAva: String?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userNick
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        messageInputBar.sendButton.layer.cornerRadius = 10
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.sendButton.backgroundColor = .systemPink
        messageInputBar.sendButton.tintColor = .white
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.inputTextView.placeholder = "Введите текст сообщения..."
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
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        let myNewTryAva = UserSettings.shared.myselfAva[myUID]

        if chatID == "kjhk" {
            if message.sender.senderId == myselfTrue.senderId {
                guard let myFinalAva = myNewTryAva else {
                    avatarView.image = UIImage(named: "ava1")
                    return
                }
                
                if myNewTryAva == nil || myFinalAva == "" || myFinalAva == "ava1" {
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    Service.shared.loadChatImage(stringUrl: myFinalAva, completion: { (image) in
                        avatarView.image = image
                    })
                }
                
            } else {
                let defaultsAvatars = ["ava1", "ava2", "ava3", "ava4", "ava5", "ava6"]
                avatarView.image = UIImage(named: defaultsAvatars.randomElement() ?? "ava6")
            }
            
        } else {
            if message.sender.senderId == myselfTrue.senderId {
                
                guard let myFinalAva = myNewTryAva else {
                    avatarView.image = UIImage(named: "ava1")
                    return
                }
                
                if myNewTryAva == nil || myFinalAva == "" || myFinalAva == "ava1" {
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    Service.shared.loadChatImage(stringUrl: myFinalAva, completion: {  (image) in
                        avatarView.image = image
                    })
                    
                }
                
            } else if message.sender.senderId == otherUserTrue.senderId {
                guard let viewModel = otherUserVM else { return }
                guard let secondUserAva = viewModel.photoURL else { return }
                if viewModel.photoURL == nil || secondUserAva == "" || secondUserAva == "ava1" {
                    avatarView.image = UIImage(named: "ava1")
                } else {
                    guard let otherUserAva = userAva else { return }
                    Service.shared.loadChatImage(stringUrl: otherUserAva, completion: { (image) in
                        avatarView.image = image
                    })
                }
                
            } else {
                avatarView.image = UIImage(named: "ava1")
            }
        }
    }
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let size = CGSize(width: 50, height: 50)
        return size
    }
    }

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
