//
//  PickupMessageAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension PickupMessageState {

    // ピックアップメッセージのstateを変更させるアクションをEnumで定義する
    enum pickupMessageAction: ReSwift.Action {

        // ピックアップメッセージの読み込み成功時にAPIより取得した値をセットするアクション
        case setPickupMessage(pickupMessage: [PickupMessageEntity])

        // ピックアップメッセージエリアの表示状態の値をセットするアクション
        case setIsPickupMessageAreaHidden(result: Bool)
    }
}
