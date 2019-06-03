//
//  GourmetShopAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/16.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension GourmetShopState {

    // 飲食店情報取得状態のstateを変更させるアクションをEnumで定義する
    enum gourmetShopAction: ReSwift.Action {

        // 飲食店情報の読み込み状態の値をセットするアクション
        case setIsLoadingGourmetShop

        // 飲食店情報の読み込み成功時にAPIより取得した値をセットするアクション
        case setGourmetShop(shop: [GourmetShopEntity])

        // 飲食店情報の読み込み失敗時に値をセットするアクション
        case setIsErrorGourmetShop
    }
}
