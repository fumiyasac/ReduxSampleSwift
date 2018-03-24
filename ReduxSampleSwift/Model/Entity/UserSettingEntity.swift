//
//  UserSettingEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/03/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * 仕様メモ:
 * ユーザーデータの記録用
 */

class UserSettingEntity: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var nickname = ""
    @objc dynamic var postalCode = ""
    @objc dynamic var residentPeriod = 0
    @objc dynamic var age = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}
