//
//  GourmetShop.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/14.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

class GourmetShop {

    private static let limitGetShopCount = 5

    private static let countList: [Int] = {
        var valueList: [Int] = []
        for value in 0...99 {
            valueList.append(value)
        }
        return valueList
    }()

    // MARK: - Static Functions

    // レスポンスで受け取ったJSONから表示に必要なものを詰め直す
    static func getRandomGourmetShopsBy(json: JSON) -> [GourmetShopEntity] {

        var gourmetShopEntityLists: [GourmetShopEntity] = []
        var gourmetShopEntityCount = 0
        let shouldSetGourmetShopCountList: [Int] = getTargetCountList()

        // (gourmetShopEntityCountの配列に含まれる数 = gourmetShopEntityCount)に合致する際にのみJSON要素数分のGourmetShopEntityを配列へ追加する
        for (key: _, value: newsJSON) in json {
            if shouldSetGourmetShopCountList.contains(gourmetShopEntityCount) {
                gourmetShopEntityLists.append(GourmetShopEntity.init(json: newsJSON))
            }
            gourmetShopEntityCount += 1
        }
        return gourmetShopEntityLists
    }

    // MARK: - Private Static Functions

    private static func getTargetCountList() -> [Int] {
        let randomSortedCountList = countList.shuffled
        return randomSortedCountList.enumerated().filter{ $0.0 < limitGetShopCount }.map{ $0.1 }
    }
}
