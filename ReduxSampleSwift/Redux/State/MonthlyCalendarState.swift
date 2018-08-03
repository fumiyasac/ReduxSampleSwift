//
//  MonthlyCalendarState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// 月別カレンダーの選択状態に関するstateの定義
struct MonthlyCalendarState: ReSwift.StateType {

    // 前月ボタンの押下かを判定するフラグ（初期値: false）
    var isPrev: Bool = false

    // 次月ボタンの押下かを判定するフラグ（初期値: false）
    var isNext: Bool = false

    // 選択された年（初期値: 0）
    var selectedYear: Int = 0

    // 選択された月（初期値: 0）
    var selectedMonth: Int = 0
}
