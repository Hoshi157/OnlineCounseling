//
//  getProfileDatas.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/01.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
// セルタップした画面のtableviewのプロフィールデータ
class getProfileDatas {
    var area: String?
    var hobby: String?
    var birthdayDate: Date?
    var medicalhistoryText: String?
    
    init(area: String, hobby: String, birthdayDate: Date, medicalhistoryText: String) {
        self.area = area
        self.hobby = hobby
        self.birthdayDate = birthdayDate
        self.medicalhistoryText = medicalhistoryText
    }
}
