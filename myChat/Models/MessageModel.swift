//
//  MessageModel.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

import MessageKit

struct Message: MessageType {
    
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
}


