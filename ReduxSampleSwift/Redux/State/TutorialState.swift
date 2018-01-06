//
//  TutorialState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/28.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

//チュートリアルの通過状態に関するstateの定義
struct TutorialState: ReSwift.StateType {

    //チュートリアルが終わっているかを判定するフラグ（初期値: false）
    var finishTutorialFlag: Bool = false

    //現在地域の変更設定判定フラグ（初期値: false）
    var changeRegionFlag: Bool = false
}
