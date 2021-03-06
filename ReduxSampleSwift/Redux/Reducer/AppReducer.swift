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

    // それぞれの変更されたReducerを反映する
    state.tutorialState      = TutorialReducer.reducer(action: action, state: state.tutorialState)
    state.userSettingState   = UserSettingReducer.reducer(action: action, state: state.userSettingState)
    state.englishNewsState   = EnglishNewsReducer.reducer(action: action, state: state.englishNewsState)
    state.gourmetShopState   = GourmetShopReducer.reducer(action: action, state: state.gourmetShopState)
    state.pickupMessageState = PickupMessageReducer.reducer(action: action, state: state.pickupMessageState)
    state.monthlyCalendarState = MonthlyCalendarReducer.reducer(action: action, state: state.monthlyCalendarState)

    // Debug.
    AppLogger.printMessageForDebug("appReduceが実行されました。")

    return state
}
