//
//  PickupMessageState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// ピックアップメッセージの状態に関するstateの定義
struct PickupMessageState: ReSwift.StateType {

    // ピックアップメッセージの一覧を格納する配列（初期値: []）
    var pickupMessageStateList: [PickupMessageEntity] = []
}
