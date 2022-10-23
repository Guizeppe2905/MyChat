//
//  ChatViewController.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    var chatID: String?
    var otherUserID: String?
    
    let myself = Sender(senderId: "1", displayName: "")
    let otherUser = Sender(senderId: "2", displayName: "")
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        showMessageTimestampOnSwipeLeft = true
        messageInputBar.delegate = self
        
        if chatID == nil {
            guard let id = otherUserID else { return }
            Service.shared.getChatID(userID: id) { [weak self] chatId in
                self?.chatID = chatId
                
                self?.getMessages(chatID: chatId)
            }
        }
//        else {
//            guard let chatID = chatID else { return }
//            getMessages(chatID: chatID)
//
//        }
        
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
        return myself
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let msg = Message(sender: myself, messageId: "", sentDate: Date(), kind: .text(text))
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
