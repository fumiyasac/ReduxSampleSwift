//
//  UserSelectFood.swift
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

class UserSelectFood: Object {

    private static let LIMIT_COUNT = 3

    @objc dynamic var foodCode = ""
    @objc dynamic var foodName = ""

    override class func primaryKey() -> String? {
        return "foodCode"
    }
}
