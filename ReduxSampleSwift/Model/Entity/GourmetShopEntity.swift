//
//  GourmetShopEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/14.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct GourmetShopEntity {

    // メンバ変数（取得したJSONレスポンスのKeyに対応する値が入る）
    let gourmetShopId: String
    let gourmetShopName: String
    let gourmetShopGenre: String
    let gourmetShopFood: String
    let gourmetShopImageUrl: String
    let gourmetShopUrl: String

    // イニシャライザ（取得したJSONレスポンスに対して必要なものを抽出する）
    init(json: JSON) {

        // Hotpepperの公開APIから必要なものを取得した上で初期化処理を行う
        // 確認URL: https://webservice.recruit.co.jp/hotpepper/gourmet/v1/
        self.gourmetShopId       = json["id"].string               ?? ""
        self.gourmetShopName     = json["name"].string             ?? ""
        self.gourmetShopGenre    = json["genre"]["name"].string    ?? ""
        self.gourmetShopFood     = json["food"]["name"].string     ?? ""
        self.gourmetShopImageUrl = json["photo"]["pc"]["l"].string ?? ""
        self.gourmetShopUrl      = json["urls"]["pc"].string       ?? ""
    }
}
