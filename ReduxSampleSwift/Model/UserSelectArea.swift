//
//  UserSelectArea.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * 仕様メモ:
 *
 */

class UserSelectArea: Object {
    
    private static let LIMIT_COUNT = 1

    @objc dynamic var id = UUID().uuidString

    @objc dynamic var regionName = ""
    @objc dynamic var regionCode = ""
    @objc dynamic var prefName   = ""
    @objc dynamic var prefCode   = ""
    @objc dynamic var areaName   = ""
    @objc dynamic var areaCode   = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
