//
//  UserSetting.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/06.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * 仕様メモ:
 *
 */

class UserSetting: Object {

    @objc dynamic var id = UUID().uuidString

    let userSelectGenre = List<UserSelectGenre>()
    let userSelectFood  = List<UserSelectFood>()
    let userSelectArea  = List<UserSelectArea>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
