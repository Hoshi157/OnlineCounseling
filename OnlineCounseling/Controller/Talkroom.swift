//
//  Talkroom.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/04.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation

// トールルームの配列データ
class Talkroom {
    var name: String?
    var uid: String?
    var roomNumber: String?
    var lastText: String?
    
    init(name: String, uid: String, roomNumber: String, lastText: String?) {
        self.name = name
        self.uid = uid
        self.roomNumber = roomNumber
        self.lastText = lastText
    }
}
