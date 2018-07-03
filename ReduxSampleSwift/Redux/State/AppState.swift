//
//  AppState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/17.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// アプリの現在状態をに関するState
struct AppState: ReSwift.StateType {

    // チュートリアルに関する画面に関するstate
    var tutorialState = TutorialState()

    // ユーザーの回答に関するstate
    var userSettingState = UserSettingState()
}
