//
//  GourmetShopState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/16.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// 飲食店情報の通信状態に関するstateの定義
struct GourmetShopState: ReSwift.StateType {

    // 飲食店情報が読み込み中かを判定するフラグ（初期値: false）
    var isLoadingGourmetShop: Bool = false

    // 飲食店情報の一覧を格納する配列（初期値: []）
    var gourmetShopList: [GourmetShopEntity] = []

    // 飲食店情報が読み込み失敗かを判定するフラグ（初期値: false）
    var isErrorGourmetShop: Bool = false
}
