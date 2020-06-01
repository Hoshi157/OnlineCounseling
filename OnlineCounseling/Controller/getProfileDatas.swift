//
//  getProfileDatas.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/01.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
// セルタップした画面のプロフィールデータ
class getProfileDatas {
    var name: String?
    var jobs: String?
    var gender: String?
    var singlewordText: String?
    var selfintroText: String?
    var area: String?
    var hobby: String?
    var medicalhistoryText: String?
    var uid: String?
    var birthdayDate: Date?
    
    init(name: String, jobs: String, gender: String, singlewordText: String, selfintroText: String, area: String, hobby: String, medicalhistoryText: String, uid: String, birthdayDate: Date) {
        self.name = name
        self.jobs = jobs
        self.gender = gender
        self.singlewordText = singlewordText
        self.selfintroText = selfintroText
        self.area = area
        self.hobby = hobby
        self.medicalhistoryText = medicalhistoryText
        self.uid = uid
        self.birthdayDate = birthdayDate
    }
}
