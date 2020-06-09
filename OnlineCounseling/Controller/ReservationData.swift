//
//  ReservationData.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/06/09.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation

class ReservationData {
    var uid: String?
    var name: String?
    var dateSt: String?
    
    init(uid: String, name: String, dateSt: String) {
        self.uid = uid
        self.name = name
        self.dateSt = dateSt
    }
}
