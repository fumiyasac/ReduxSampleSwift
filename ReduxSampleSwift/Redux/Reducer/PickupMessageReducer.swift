//
//  PickupMessageReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct PickupMessageReducer {}

extension PickupMessageReducer {
    
    static func reducer(action: ReSwift.Action, state: PickupMessageState?) -> PickupMessageState {

        // ピックアップメッセージのstateを取得する(ない場合は初期状態とする)
        var state = state ?? PickupMessageState()
        
        // ピックアップメッセージのstateを変更させるアクションでない場合はstateの変更は許容しない
        guard let action = action as? PickupMessageState.pickupMessageAction else { return state }

        switch action {

        case let .setPickupMessage(pickupMessage):
            state.pickupMessageStateList = pickupMessage
        }

        // Debug.
        AppLogger.printMessageForDebug("PickupMessageStateが更新されました。")

        return state
    }
}
