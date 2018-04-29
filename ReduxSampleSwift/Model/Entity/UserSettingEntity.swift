//
//  UserSettingEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/03/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

class UserSettingEntity: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var postalCode = ""
    @objc dynamic var selectedResidentPeriod = 0
    @objc dynamic var freeWord = ""
    @objc dynamic var nickname = ""
    @objc dynamic var gender = 0
    @objc dynamic var selectedAge = 0
    @objc dynamic var createdAt = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
