//
//  MonthlyCalendarAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension MonthlyCalendarState {
    
    // 月別カレンダーのstateを変更させるアクションをEnumで定義する
    enum monthlyCalendarAction: ReSwift.Action {

        // 前月の値をセットするアクション
        case setPrevCalendar(value: (year: Int, month: Int))

        // 次月の値をセットするアクション
        case setNextCalendar(value: (year: Int, month: Int))

        // 現在月の値をセットするアクション
        case setCurrentCalendar(value: (year: Int, month: Int))
    }
}
