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
    func loadImage(targetUid: String?, completionClosure: @escaping CompletionClosure)
}

extension storageProtocol {
    // Storageに画像を保存する
    func storagetToUploadImage(image: UIImage?, childId: String) {
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(childId)
        let data: Data? = image?.jpegData(compressionQuality: 0.2) // jpegに変換(データ圧縮しないとダウンロードできない)
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
    // クロージャの型定義
    typealias CompletionClosure = ((_ result: UIImage?) -> Void)
    
    // Storageから画像取得
    func loadImage(targetUid: String?, completionClosure: @escaping CompletionClosure) { // @escapingにimageの結果が入る
        guard let _targetUid = targetUid else { return }
        let postRef = Storage.storage().reference(forURL: "gs://onlinecounseling-3c1ac.appspot.com").child(_targetUid)
        postRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription, "error storage")
                completionClosure(nil)
            }else {
                let image = UIImage(data: data!)
                completionClosure(image)
            }
        }
    }
}
