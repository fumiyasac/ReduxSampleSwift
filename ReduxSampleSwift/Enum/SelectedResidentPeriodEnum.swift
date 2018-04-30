//
//  SelectedResidentPeriodEnum.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

enum SelectedResidentPeriodEnum: String {
    case first  = "1年未満"
    case second = "1年~5年未満"
    case third  = "5年~10年未満"
    case fourth = "10年~15年未満"
    case fifth  = "15年~20年未満"
    case sixth  = "20年以上"

    // MARK: - Static Function

    static func getAll() -> [SelectedResidentPeriodEnum] {
        return [.first, .second, .third, .fourth, .fifth, .sixth]
    }

    // MARK: - Function

    func getStatusCode() -> Int {
        switch self {
        case .first:
            return 1
        case .second:
            return 2
        case .third:
            return 3
        case .fourth:
            return 4
        case .fifth:
            return 5
        case .sixth:
            return 6
        }
    }
}
