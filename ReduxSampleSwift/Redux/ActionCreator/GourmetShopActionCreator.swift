//
//  GourmetShopActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/16.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift
import SwiftyJSON
import PromiseKit

struct GourmetShopActionCreator {}

extension GourmetShopActionCreator {

    // 飲食店情報を取得する
    static func fetchGourmetShopList() {

        // データ読み込み中の状態を反映するアクションの実行
        appStore.dispatch(GourmetShopState.gourmetShopAction.setIsLoadingGourmetShop())

        // HotpepperのAPIからランダムで5件の飲食店情報を取得する
        APIManagerForHotpepper.shared.getRecommendShopList()
            .done { shopJSON in

                // 成功時: 飲食店情報を反映するアクションの実行
                let gourmetShopList = GourmetShop.getRandomGourmetShopsBy(json: shopJSON)
                appStore.dispatch(GourmetShopState.gourmetShopAction.setGourmetShop(shop: gourmetShopList))

            }.catch { error in

                // 失敗時: データ読み込み失敗時の状態を反映するアクションの実行
                appStore.dispatch(GourmetShopState.gourmetShopAction.setIsErrorGourmetShop())
        }
    }
}
