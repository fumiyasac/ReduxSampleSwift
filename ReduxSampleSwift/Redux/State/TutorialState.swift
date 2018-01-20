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

    //UIPageViewControllerのインデックス位置（初期値: 0）
    var currentPageViewControllerIndex: Int = 0

    //UIPageViewControllerが進むor戻る遷移かの判定値（初期値: false）
    var isPrevious: Bool = false

    //チュートリアルが終わっているかを判定するフラグ（初期値: false）
    var finishTutorialFlag: Bool = false
}
