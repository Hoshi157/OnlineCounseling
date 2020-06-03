//
//  MockMessage.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
import MessageKit

struct MockMessage: MessageType {
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
    
    init(messageId:String,sender:SenderType,sentDate:Date,kind:MessageKind){
        self.messageId = messageId
        self.sender = sender
        self.sentDate = sentDate
        self.kind = kind
    }
    
    init(messageId:String,sender:SenderType,sentDate:Date,text:String) {
        self.init(messageId: messageId, sender: sender, sentDate: sentDate, kind: .text(text))
    }
}

struct senderUser: SenderType {
    var senderId: String
    var displayName: String
}
