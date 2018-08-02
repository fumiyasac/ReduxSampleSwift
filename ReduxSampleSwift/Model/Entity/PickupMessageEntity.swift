//
//  PickupMessageEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct PickupMessageEntity {

    // メンバ変数（取得したJSONレスポンスのKeyに対応する値が入る）
    let id: String
    let title: String
    let category: String
    let imageUrl: String

    // イニシャライザ（取得したJSONレスポンスに対して必要なものを抽出する）
    init(json: JSON) {

        // APIから必要なものを取得した上で初期化処理を行う
        // 確認URL: https://immense-journey-38002.herokuapp.com/articles.json
        self.id       = json["id"].string        ?? "0"
        self.title    = json["title"].string     ?? ""
        self.category = json["category"].string  ?? ""
        self.imageUrl = json["image_url"].string ?? ""
    }
}
