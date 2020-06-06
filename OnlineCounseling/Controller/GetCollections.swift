//
//  GetCollections.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/01.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
// コレクションに表示するデータ
class GetCollections {
    var name: String?
    var jobs: String?
    // uidはタップした時の処理に使用
    var uid: String?
    
    init(name: String, jobs: String, uid: String) {
        self.name = name
        self.jobs = jobs
        self.uid = uid
    }
}
