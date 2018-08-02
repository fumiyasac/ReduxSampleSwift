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

    private static let calendar      = Calendar(identifier: .gregorian)
    private static var dateComponent = DateComponents()

    // MARK: - Static Function

    // 現在年月のカレンダー表示用ボタンのリストを作成する
    static func getTargetCalendarButtonList(targetYear: Int, targetMonth: Int) -> [CalendarButtonView] {

        // 該当の年と月から日数を算出する
        let maxDay = getTargetCalendarDays(year: targetYear, month: targetMonth)
        
        // 現在年月において(前へボタン + 日数のボタン + 次へボタン)のリストを作成する
        var buttonList: [CalendarButtonView] = []

        for i in 0...maxDay + 1 {

            // 0番目に前へボタン、(maxDay + 1)番目に次へボタン、それ以外はカレンダーの日付ボタンとする
            let button = CalendarButtonView()
            if i == 0 {
                button.setPrevMonthButton()
                button.monthlyCalendarButtonType = .prevButton
            } else if i == maxDay + 1 {
                button.setNextMonthButton()
                button.monthlyCalendarButtonType = .nextButton
            } else {
                button.setCalendarButton(year: targetYear, month: targetMonth, day: i)
                button.monthlyCalendarButtonType = .targetDayButton
            }
            buttonList.append(button)
        }
        return buttonList
    }

    // MARK: - Private Static Function

    // 引数で受け取った年と月から日数を算出する
    private static func getTargetCalendarDays(year: Int, month: Int) -> Int {

        dateComponent.year  = year
        dateComponent.month = month
        dateComponent.day   = 1

        let targetDate: Date = calendar.date(from: dateComponent)!
        let range: Range = calendar.range(of: .day, in: .month, for: targetDate)!
        return Int(range.count)
    }
}
