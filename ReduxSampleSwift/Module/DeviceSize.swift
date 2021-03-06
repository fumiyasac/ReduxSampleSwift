//
//  DeviceSize.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/02.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct DeviceSize {

    // MARK: - Static Function

    // CGRectを取得
    static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }

    // 画面の横サイズを取得
    static func screenWidth() -> Int {
        return Int(self.bounds().width)
    }

    // 画面の縦サイズを取得
    static func screenHeight() -> Int {
        return Int(self.bounds().height)
    }

    // iPhoneXのサイズとマッチしているかを返す
    static func isEqualSizeOfIphoneX() -> Bool {
        return (self.screenWidth() == 375 && self.screenHeight() == 812)
    }
}
