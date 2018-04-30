//
//  SelectedAgeEnum.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

enum SelectedAgeEnum: String {
    case first  = "10代"
    case second = "20代"
    case third  = "30代"
    case fourth = "40代"
    case fifth  = "50代"
    case sixth  = "60代以上"

    // MARK: - Static Function

    static func getAll() -> [SelectedAgeEnum] {
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
