//
//  DateFormatterUtil.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/02.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

class DateFormatterUtil {

    // MARK: - Static Functions

    // APIで取得された日付フォーマットを任意の表記に変換する
    static func getDateStringFromAPI(apiDateString: String , printFormatter: String = "MMM dd, yyyy") -> String {

        // APIで取得してきたISO8601形式の日付文字列をDateへ変換する
        let formatterForApiDateString = ISO8601DateFormatter.init()
        let targetDate = formatterForApiDateString.date(from: apiDateString)

        // 変換を行いたいフォーマットの文字列へ再度変換を行う
        let formatterForDisplay = DateFormatter()
        formatterForDisplay.dateFormat = printFormatter
        formatterForDisplay.locale = Locale(identifier: "en_US_POSIX")
        formatterForDisplay.timeZone = TimeZone.current

        return formatterForDisplay.string(from: targetDate!)
    }
}
