//
//  UserData.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/27.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import RealmSwift
import UIKit
// Realmに保存するデータ
class User: Object {
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
    @objc dynamic var birthdayDate: Date? = nil
    @objc dynamic var gender = ""
    @objc dynamic var jobs = ""
    @objc dynamic var area = ""
    @objc dynamic var hobby = ""
    @objc dynamic var selfintroText = ""
    @objc dynamic var singlewordText = ""
    @objc dynamic var medicalhistoryText = ""
    @objc dynamic var type = "user"
    @objc dynamic var imagePath: String = "" // imageはファイルのパスを保存
    @objc dynamic var loginFlg: Bool = false // ログインしているかFlgを設置
    
    let reservations = List<Reservation>()
    let bookmarks = List<BookmarkHistory>()
    let messages = List<MessageHistory>()
    let otherUsers = List<OtherUser>()
    let counselings = List<CounselingHistory>()
}
// 予約データ
class Reservation: Object {
    @objc dynamic var reservation: Date? = nil
    @objc dynamic var name = ""
    @objc dynamic var uid = ""
}
// お気に入りした人の履歴
class BookmarkHistory: Object {
    @objc dynamic var otherUid = ""
    @objc dynamic var otherName = ""
}
// チャット履歴
class MessageHistory: Object {
    @objc dynamic var otherUid = ""
    @objc dynamic var otherName = ""
    @objc dynamic var otherRoomNumber = ""
    @objc dynamic var lastText = "" // チャットの最後の文のみ格納
}
// 他のユーザーの情報
class OtherUser: Object {
    @objc dynamic var uid = ""
    @objc dynamic var imagePath = ""
}
// カウンセリング履歴(ビデオチャット)　roomIdは保持せずに一回ずつ生成した方がいいか？
class CounselingHistory: Object {
    @objc dynamic var uid = ""
    @objc dynamic var name = ""
}
