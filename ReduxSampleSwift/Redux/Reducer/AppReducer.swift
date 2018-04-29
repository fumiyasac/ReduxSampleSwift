//
//  AppReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/20.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// Stateの更新が行われた際にappReduceを実行してStore内のStateを更新する ※Store内では全てのStateを一元管理している
func appReduce(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.tutorialState = TutorialReducer.reducer(action: action, state: state.tutorialState)

    // Debug.
    print("appReduceが実行されました。")
    print("TutorialState:", state.tutorialState)

    return state
}
