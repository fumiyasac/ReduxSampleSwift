//
//  TutorialAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/28.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension TutorialState {

    // チュートリアル完了状態のステートを変更させるアクションをEnumで定義する
    enum tutorialAction: ReSwift.Action {

        // 現在のチュートリアルの終了判定の値をセットするアクション
        case setCurrentStatus(initialSetting: (isFinishedTutorial: Bool, installAppDate: Date))

        // チュートリアルの終了判定の値を更新するアクション
        case updateIsFinishTutorial(result: Bool)

        // 現在のUIPageViewControllerのインデックスをセットアクション
        case setCurrentPageViewControllerIndex(index: Int)
    }
}
