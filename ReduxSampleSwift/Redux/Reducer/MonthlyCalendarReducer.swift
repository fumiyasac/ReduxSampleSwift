//
//  MonthlyCalendarReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct MonthlyCalendarReducer {}

extension MonthlyCalendarReducer {
    
    static func reducer(action: ReSwift.Action, state: MonthlyCalendarState?) -> MonthlyCalendarState {

        // 月別カレンダーのstateを取得する(ない場合は初期状態とする)
        var state = state ?? MonthlyCalendarState()

        // 月別カレンダーのstateを変更させるアクションでない場合はstateの変更は許容しない
        guard let action = action as? MonthlyCalendarState.monthlyCalendarAction else { return state }

        switch action {
            
        case let .setPrevCalendar(value):
            state.isPrev = true
            state.isNext = false
            state.selectedYear  = value.year
            state.selectedMonth = value.month
        case let .setNextCalendar(value):
            state.isPrev = false
            state.isNext = true
            state.selectedYear  = value.year
            state.selectedMonth = value.month
        case let .setCurrentCalendar(value):
            state.isPrev = false
            state.isNext = false
            state.selectedYear  = value.year
            state.selectedMonth = value.month
        }

        // Debug.
        AppLogger.printMessageForDebug("MonthlyCalendarStateが更新されました。")
        
        return state
    }
}
