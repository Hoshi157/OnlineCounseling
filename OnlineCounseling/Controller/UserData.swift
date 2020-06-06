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
    @objc dynamic var imagePath: String = "" // imageはファイルのパスを保存
    
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
    @objc dynamic var lastText = "" // チャットの最後の文のみ格納
}

protocol imageSaveProtocol {
    // DocumentディレクトリのfileURLを取得
    func getDoumentsURL() -> NSURL
    // DocumentのpathにFilenameを繋げてファイルのフルパスを作成
    func fileInDocumentsDirectory(filename: String) -> String
    // ファイルに書き込み(pathは画像のpathを入れる)
    func saveImage (image: UIImage, path: String ) -> Bool
    // pathから画像をロード
    func loadImageFromPath(path: String) -> UIImage?
}

// 画像のFileフルパスを作成し書き込む
extension imageSaveProtocol {
    // DocumentディレクトリのfileURLを取得
    func getDoumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }
    // DocumentのpathにFilenameを繋げてファイルのフルパスを作成(filenameは自分のuidにする)
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDoumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    // ファイルに書き込み(判定処理あり) tureならRealmに保存する
    func saveImage(image: UIImage, path: String) -> Bool {
        let pngImageData: Data? = image.pngData() // imageをpngDataに変換
        do {
            try pngImageData!.write(to: URL(fileURLWithPath: path), options: .atomic) // imageDataをpathに書き込む
        }catch {
            print(error, "saveImage error")
            return false
        }
        return true
    }
    // pathからUIImageを取得
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if (image == nil) {
            print(path, "image nil")
        }
        return image
    }
}
