//
//  InitialSetting.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/02.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

class InitialSetting {

    //チュートリアルの終了判定フラグ
    private let finishTutorialFlag = "InitialSetting::finishTutorialFlag"

    //現在地域の変更設定判定フラグ
    private let changeRegionFlag   = "InitialSetting::changeRegionFlag"

    //MARK: - Function

    //チュートリアルの終了判定フラグの更新・取得

    func getFinishTutorialFlag() -> Bool {
        return ud.bool(forKey: finishTutorialFlag)
    }

    func setFinishTutorialFlag(result: Bool) {
        ud.set(result, forKey: finishTutorialFlag)
        ud.synchronize()
    }

    //現在地域の変更設定判定フラグの更新・取得

    func getChangeRegionFlag() -> Bool {
        return ud.bool(forKey: changeRegionFlag)
    }

    func setChangeRegionFlag(result: Bool) {
        ud.set(result, forKey: changeRegionFlag)
        ud.synchronize()
    }

    //MARK: - Private Function

    private var ud: UserDefaults {
        return UserDefaults.standard
    }
}
