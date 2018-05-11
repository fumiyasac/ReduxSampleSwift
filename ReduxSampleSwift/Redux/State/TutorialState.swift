//
//  TutorialState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/28.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// チュートリアルの通過状態に関するstateの定義
struct TutorialState: ReSwift.StateType {

    // UIPageViewControllerのインデックス位置（初期値: 0）
    var currentPageViewControllerIndex: Int = 0

    // チュートリアルが終わっているかを判定するフラグ（初期値: false）
    var isFinishedTutorial: Bool = false

    // ユーザー登録が終わっているかを判定するフラグ（初期値: false）
    var isFinishedUserSetting: Bool = false

    // アプリインストール日時（初期値: nil）
    var installAppDate: Date? = nil

    // 詳細コンテンツの表示状態（初期値: false）
    var isOpenedDetail: Bool = false
}
