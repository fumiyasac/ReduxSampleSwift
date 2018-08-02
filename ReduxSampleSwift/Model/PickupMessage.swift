//
//  PickupMessage.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

class PickupMessage {

    // MARK: - Static Functions

    // レスポンスで受け取ったJSONから表示に必要なものを詰め直す
    static func getPickupMessagesBy(json: JSON) -> [PickupMessageEntity] {

        var pickupMessageEntityLists: [PickupMessageEntity] = []

        // JSON要素数分のPickupMessageEntityを配列へ追加する
        for (key: _, value: messageJSON) in json {
            pickupMessageEntityLists.append(PickupMessageEntity.init(json: messageJSON))
        }
        return pickupMessageEntityLists
    }
}
