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
    @objc dynamic var birthdayDate = Date()
    @objc dynamic var gender = ""
    @objc dynamic var jobs = ""
    @objc dynamic var area = ""
    @objc dynamic var hobby = ""
    @objc dynamic var selfintroText = ""
    @objc dynamic var singlewordText = ""
    @objc dynamic var medicalhistoryText = ""
    @objc dynamic var type = ""
    @objc dynamic var avaterimage: UIImage? {
        set{
           let maxImageSize = 15*1024*1024
            var quarity: CGFloat = 0.9
            var jpegSize = 0
            
            if let value = newValue {
                self.imageData = value.jpegData(compressionQuality: quarity)! as NSData
                if let data = self.imageData {
                    jpegSize = data.length
                    print("imageData.size", jpegSize)
                    
                    while (quarity > 0 && jpegSize > maxImageSize) {
                        quarity = quarity - 0.15
                        self.imageData = value.jpegData(compressionQuality: quarity)! as NSData
                        jpegSize = self.imageData!.length
                    }
                }
                print("imageData.size", jpegSize)
            }
        }
        get{
            if let image = imagePhoto {
                return image
            }
            if let data = self.imageData {
                self.imagePhoto = UIImage(data: data as Data)
                return self.imagePhoto
            }
            return nil
        }
    }
    @objc dynamic private var imageData: NSData? = nil
    @objc dynamic private var imagePhoto: UIImage? = nil
    
    override static func ignoredProperties() -> [String] {
        return ["avaterimage", "imagePhoto"]
    }
    
    let reservations = List<Reservation>()
    let bookmarks = List<BookmarkHistory>()
    let messages = List<MessageHistory>()
}
// 予約データ
class Reservation: Object {
    @objc dynamic var reservation = ""
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
    // チャットの最後の文のみ格納
    @objc dynamic var lastText = ""
}
