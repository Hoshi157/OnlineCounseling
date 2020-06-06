//
//  storageProtocol.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/06.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
import Firebase

protocol storageProtocol {
    func storagetToUploadImage(image: UIImage?, childId: String)
    func loadImage(childId: String) -> UIImage?
}

extension storageProtocol {
    // Storageに画像を保存する
    func storagetToUploadImage(image: UIImage?, childId: String) {
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(childId)
        let data: Data? = image?.pngData() // PNGに変換
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
        var image: UIImage? = nil
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(childId)
        postRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error, "error storage")
            }else {
                image = UIImage(data: data!)
            }
        }
        return image
    }
}
