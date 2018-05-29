//
//  CalendarButtons.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import CalculateCalendarLogic

class CalendarButtons {

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
    static func getCurrentCalendarButtonList() -> [UIButton] {

        // 現在年月を取得する
        guard let values = getCurrentCalendarValues() else {
            return []
        }
        let year   = values.currentYear
        let month  = values.currentMonth
        let maxDay = values.maxDay

        // 現在年月において日数分のボタンを作成する
        var buttonList: [UIButton] = []
        for i in 1...maxDay {
            let button = getCalendarDayButton(year: year, month: month, day: i)
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

    // 現在年月から日数分のカレンダーボタンを取得する
    private static func getCalendarDayButton(year: Int, month: Int, day: Int) -> UIButton {

        // 引数の値から年月日データを取得する
        var comps = DateComponents()
        comps.year  = year
        comps.month = month
        comps.day   = day
        guard let targetDate = calendar.date(from: comps) else {
            abort()
        }

        // 曜日の数値インデックス値を取得する（0:日曜日 ... 6:土曜日）
        let returnComps = calendar.dateComponents([.weekday], from: targetDate)
        guard let weekday = returnComps.weekday else {
            abort()
        }
        let weekdayIndex = weekday - 1

        // カレンダー表示用ボタンを生成する
        return getButtonElement(year: year, month: month, day: day, weekdayIndex: weekdayIndex)
    }

    // カレンダー表示用ボタンを年月日と曜日から生成する
    private static func getButtonElement(year: Int, month: Int, day: Int, weekdayIndex: Int) -> UIButton {

        // 曜日のシンボル一覧を取得する
        let shortWeekdaySymbols = calendar.shortWeekdaySymbols
        let shortWeekday = shortWeekdaySymbols[weekdayIndex]

        // UIButtonインスタンスを生成し必要な値をセットする
        let button = UIButton()
        button.setTitle(shortWeekday + "\n" + String(day), for: UIControlState())
        button.titleLabel!.font = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 12)!
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        button.tag = day
        button.tintColor = UIColor.white
        button.backgroundColor = getColorOfCalendarDay(year: year, month: month, day: day, weekdayIndex: weekdayIndex)
        return button
    }

    // 曜日に合わせた色データを取得する
    private static func getColorOfCalendarDay(year: Int, month: Int, day: Int, weekdayIndex: Int) -> UIColor {
        if isSunday(weekdayIndex: weekdayIndex) || isHoliday(year: year, month: month, day: day) {
            return UIColor.init(code: "#d45939")
        } else if isSaturday(weekdayIndex: weekdayIndex) {
            return UIColor.init(code: "#6678fa")
        } else {
            return UIColor.init(code: "#cccccc")
        }
    }

    // 年月日からその日が祝日か否かを判定する
    private static func isHoliday(year: Int, month: Int, day: Int) -> Bool {
        let holidayLogic = CalculateCalendarLogic()
        return holidayLogic.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    // 曜日のインデックス値からその日が日曜日か否かを判定する
    private static func isSunday(weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == 0)
    }

    // 曜日のインデックス値からその日が土曜日か否かを判定する
    private static func isSaturday(weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == 6)
    }
}
