//
//  CalendarButtonModule.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import CalculateCalendarLogic

class CalendarButtonModule {

    private static let calendar = Calendar(identifier: .gregorian)

    static var currentYear: String {
        get {
            guard let current = getCurrentCalendarValues() else { return "????" }
            return String(current.currentYear)
        }
    }

    static var currentMonth: String {
        get {
            guard let current = getCurrentCalendarValues() else { return "??" }
            return String(current.currentMonth)
        }
    }

    // MARK: - Static Function

    // 現在年月のカレンダー表示用ボタンのリストを作成する
    static func getCurrentCalendarButtonList() -> [CalendarButtonView] {

        // 現在年月を取得する
        guard let values = getCurrentCalendarValues() else {
            return []
        }
        let year   = values.currentYear
        let month  = values.currentMonth
        let maxDay = values.maxDay
        
        // 現在年月において日数分のボタンを作成する
        var buttonList: [CalendarButtonView] = []
        for i in 1...maxDay {
            let button = CalendarButtonView()
            button.setCalendarButton(year: year, month: month, day: i)
            buttonList.append(button)
        }
        return buttonList
    }

    // MARK: - Private Static Function

    // 現在年月と日数を取得する
    private static func getCurrentCalendarValues() -> (currentYear: Int, currentMonth: Int, maxDay: Int)? {

        // 現在の日付をもとにして必要な値を取得する
        let now = Date()
        let comps = calendar.dateComponents([.year, .month], from: now)
        guard let year = comps.year, let month = comps.month, let range = calendar.range(of: .day, in: .month, for: now) else {
            return nil
        }
        return (currentYear: year, currentMonth: month, maxDay: Int(range.count))
    }
}
