//
//  MonthlyCalendarActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct MonthlyCalendarActionCreator {}

extension MonthlyCalendarActionCreator {

    static func setPrevYearAndMonth(targetYear: Int, targetMonth: Int) {
        appStore.dispatch(
            MonthlyCalendarState.monthlyCalendarAction.setPrevCalendar(value: (year: targetYear, month: targetMonth))
        )
    }

    static func setNextYearAndMonth(targetYear: Int, targetMonth: Int) {
        appStore.dispatch(
            MonthlyCalendarState.monthlyCalendarAction.setNextCalendar(value: (year: targetYear, month: targetMonth))
        )
    }

    static func setCurrentYearAndMonth(targetYear: Int, targetMonth: Int) {
        appStore.dispatch(
            MonthlyCalendarState.monthlyCalendarAction.setCurrentCalendar(value: (year: targetYear, month: targetMonth))
        )
    }
}
