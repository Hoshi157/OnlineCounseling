//
//  storageProtocol.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/06.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
import Firebase
import UIKit

protocol storageProtocol {
    func storagetToUploadImage(image: UIImage?, childId: String)
    func loadImage(childId: String) -> UIImage?
}

extension storageProtocol {
    // Storageに画像を保存する
    func storagetToUploadImage(image: UIImage?, childId: String) {
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(childId)
        let data: Data? = image?.jpegData(compressionQuality: 0.3) // jpegに変換(データ圧縮しないとダウンロードできない)
        if (data != nil) {
            postRef.putData(data!, metadata: nil) { (data, error) in
                if (error != nil) {
                    print("storage error")
                    return
                }
            }
        }else {
            print("image nil")
        }
    }
    // 画像を取得する(uidから)
    func loadImage(childId: String) -> UIImage? {
        print("呼び出された")
        var image: UIImage?
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(childId)
        postRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription, "error storage")
            }else {
                image = UIImage(data: data!)
            }
        }
        return image
    }
}
