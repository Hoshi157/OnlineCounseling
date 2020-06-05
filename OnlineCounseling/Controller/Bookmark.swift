//
//  Bookmark.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/05.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
// bookmark配列のデータ
class Bookmark {
    var name: String?
    var uid: String?
    
    init(name: String, uid: String?) {
        self.name = name
        self.uid = uid
    }
}
