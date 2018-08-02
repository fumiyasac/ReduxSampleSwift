//
//  GourmetShopReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/16.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct GourmetShopReducer {}

extension GourmetShopReducer {

    static func reducer(action: ReSwift.Action, state: GourmetShopState?) -> GourmetShopState {

        // 飲食店情報取得状態のstateを取得する(ない場合は初期状態とする)
        var state = state ?? GourmetShopState()

        // 飲食店情報取得状態のstateを変更させるアクションでない場合はstateの変更は許容しない
        guard let action = action as? GourmetShopState.gourmetShopAction else { return state }

        switch action {

        case .setIsLoadingGourmetShop():
            state.isLoadingGourmetShop = true

        case let .setGourmetShop(shop):
            state.isLoadingGourmetShop = false
            state.gourmetShopList      = shop
            state.isErrorGourmetShop   = false

        case .setIsErrorGourmetShop():
            state.isLoadingGourmetShop = false
            state.isErrorGourmetShop   = true
        }

        // Debug.
        AppLogger.printMessageForDebug("GourmetShopStateが更新されました。")

        return state
    }
}
