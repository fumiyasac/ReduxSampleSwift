//
//  InitialSetting.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/02.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

/**
 * 仕様メモ:
 * チュートリアルが終了やインストール日時の記録用
 */

class InitialSetting {

    // チュートリアルの終了判定
    static private let isFinishedTutorial = "InitialSetting::isFinishedTutorial"

    // アプリインストール日時
    static private let installAppDate     = "InitialSetting::installAppDate"

    // MARK: - Static Function

    // チュートリアルの終了判定の更新・取得
    static func getIsFinishedTutorial() -> Bool {
        return ud.bool(forKey: isFinishedTutorial)
    }

    static func setIsFinishedTutorial(result: Bool) {
        ud.set(result, forKey: isFinishedTutorial)
        ud.synchronize()
    }

    // アプリインストール日時の更新・取得
    static func getInstallAppDate() -> Date? {
        return ud.object(forKey: installAppDate) as? Date
    }

    static func setInstallAppDate(date: Date) {
        ud.set(date, forKey: installAppDate)
        ud.synchronize()
    }

    // MARK: - Private Function

    static private var ud: UserDefaults {
        return UserDefaults.standard
    }
}
