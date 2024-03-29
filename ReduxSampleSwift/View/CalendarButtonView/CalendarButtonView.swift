//
//  CalendarButtonView.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import CalculateCalendarLogic

class CalendarButtonView: CustomViewBase {

    static let CALENDAR_BUTTON_VIEW_WIDTH: CGFloat = 58

    private let calendar = Calendar(identifier: .gregorian)
    private let buttonCornerRadius: CGFloat = 23

    var monthlyCalendarButtonType: MonthlyCalendarButtonType!

    // MEMO: ボタンの配置時にボタンに関する設定を行う形にするのでprivateではない形にしている
    @IBOutlet weak var calendarButton: UIButton!

    // MEMO: CalculateCalendarLogicでの判定結果に応じてViewの配色や表示を変化させるための部品
    @IBOutlet weak private var calendarButtonBackgroundView: UIView!
    @IBOutlet weak private var calendarButtonWeekdayLabel: UILabel!
    @IBOutlet weak private var calendarButtonDayLabel: UILabel!

    // MARK: - Initializer
    
    required init(frame: CGRect) {
        super.init(frame: frame)

        setupCalendarButtonView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCalendarButtonView()
    }

    // MARK: - Function

    // 前の月へボタンを設定する
    func setPrevMonthButton() {
        calendarButtonWeekdayLabel.text = "prev"
        calendarButtonDayLabel.text     = "◀︎"
        calendarButtonBackgroundView.backgroundColor = UIColor.init(code: "#fd9d01")
    }

    // 次の月へボタンを設定する
    func setNextMonthButton() {
        calendarButtonWeekdayLabel.text = "next"
        calendarButtonDayLabel.text     = "▶︎"
        calendarButtonBackgroundView.backgroundColor = UIColor.init(code: "#fd9d01")
    }

    // 現在年月から日数分のカレンダーボタンを設定する
    func setCalendarButton(year: Int, month: Int, day: Int) {

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
        return setCalendarDisplayElements(year: year, month: month, day: day, weekdayIndex: weekdayIndex)
    }

    // MARK: - Private Function

    private func setupCalendarButtonView() {
        calendarButtonWeekdayLabel.font = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 10)!
        calendarButtonDayLabel.font     = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 13)!
        calendarButtonBackgroundView.layer.cornerRadius = buttonCornerRadius
    }

    // カレンダー表示用ボタンを年月日と曜日から生成する
    private func setCalendarDisplayElements(year: Int, month: Int, day: Int, weekdayIndex: Int) {

        // 曜日のシンボル一覧を取得する
        let shortWeekdaySymbols = calendar.shortWeekdaySymbols
        let shortWeekday = shortWeekdaySymbols[weekdayIndex]

        // 必要な値をセットする（※MEMO: 「button.tag = day」となるように定義しておく）
        calendarButton.tag              = day
        calendarButtonWeekdayLabel.text = shortWeekday
        calendarButtonDayLabel.text     = String(day)
        calendarButtonBackgroundView.backgroundColor = getColorOfCalendarDay(year: year, month: month, day: day, weekdayIndex: weekdayIndex)
    }

    // 曜日に合わせた色データを取得する
    private func getColorOfCalendarDay(year: Int, month: Int, day: Int, weekdayIndex: Int) -> UIColor {
        if isSunday(weekdayIndex: weekdayIndex) || isHoliday(year: year, month: month, day: day) {
            return UIColor.init(code: "#d45939")
        } else if isSaturday(weekdayIndex: weekdayIndex) {
            return UIColor.init(code: "#6678fa")
        } else {
            return UIColor.init(code: "#cccccc")
        }
    }

    // 年月日からその日が祝日か否かを判定する
    private func isHoliday(year: Int, month: Int, day: Int) -> Bool {
        let holidayLogic = CalculateCalendarLogic()
        return holidayLogic.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    // 曜日のインデックス値からその日が日曜日か否かを判定する
    private func isSunday(weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == 0)
    }

    // 曜日のインデックス値からその日が土曜日か否かを判定する
    private func isSaturday(weekdayIndex: Int) -> Bool {
        return (weekdayIndex % 7 == 6)
    }
}
