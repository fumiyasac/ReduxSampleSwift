//
//  TutorialReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/30.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct TutorialReducer {}

extension TutorialReducer {

    static func reducer(action: ReSwift.Action, state: TutorialState?) -> TutorialState {

        // チュートリアル完了状態のstateを取得する(ない場合は初期状態とする)
        var state = state ?? TutorialState()

        // チュートリアル完了状態のstateを変更させるアクションでない場合はステートの変更は許容しない
        guard let action = action as? TutorialState.tutorialAction else { return state }

        switch action {

        // TutorialStateのisFinishedTutorialの値をセットする
        case let .setIsFinishedTutorial(result):
            state.isFinishedTutorial = result

        // TutorialStateのinstallAppDateの値をセットする
        case let .setInstallAppDate(date):
            state.installAppDate = date

        // TutorialStateのisFinishedUserSettingの値をセットする
        case let .setIsFinishedUserSetting(result):
            state.isFinishedUserSetting = result

        // TutorialStateのcurrentPageViewControllerIndexの値をセットする
        case let .setCurrentPageViewControllerIndex(index):
            state.currentPageViewControllerIndex = index
        }

        // Debug.
        print("TutorialStateが更新されました。")

        return state
    }
}
