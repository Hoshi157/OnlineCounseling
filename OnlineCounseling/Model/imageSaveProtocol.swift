//
//  imageSaveProtocol.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/06.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
import UIKit
// Documentディレクトリに画像を保存する処理
protocol imageSaveProtocol {
    // DocumentディレクトリのfileURLを取得
    func getDoumentsURL() -> NSURL
    // DocumentのpathにFilenameを繋げてファイルのフルパスを作成
    func fileInDocumentsDirectory(filename: String) -> String
    // ファイルに書き込み(pathはfileInDocumentsDirectoryを入れる)
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
    // DocumentのpathにFilenameを繋げてファイルのフルパスを作成(filenameはuidにする)
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDoumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    // ファイルに書き込み(判定処理あり)
    func saveImage(image: UIImage, path: String) -> Bool {
        let pngImageData: Data? = image.jpegData(compressionQuality: 0.2)// imageをjpegDataに変換
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
            return nil
        }
        return image
    }
}
