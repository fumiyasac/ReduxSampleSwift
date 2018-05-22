//
//  InitialSettingActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct InitialSettingActionCreator {}

extension InitialSettingActionCreator {

    // 現在のユーザーの登録状況を反映する
    static func setCurrentUserStatus() {

        // アプリインストール日時の取得
        var installAppDate: Date
        if let targetInstallAppDate = InitialSetting.getInstallAppDate() {
            installAppDate = targetInstallAppDate
        } else {
            installAppDate = Date()
            InitialSetting.setInstallAppDate(date: installAppDate)
        }

        // チュートリアルの終了判定の取得
        let isFinishedTutorial = InitialSetting.getIsFinishedTutorial()

        // ユーザー登録の終了判定の取得
        let isFinishedUserSetting = UserSetting.isFinishedUserSetting()
        if let userSetting = UserSetting.getUserSetting() {
            appStore.dispatch(UserSettingState.userSettingAction.setCreatedUserSetting(userSetting: userSetting))
        }

        // 現在の初期設定状態を反映するアクションの実行
        appStore.dispatch(TutorialState.tutorialAction.setInstallAppDate(date: installAppDate))
        appStore.dispatch(TutorialState.tutorialAction.setIsFinishedTutorial(result: isFinishedTutorial))
        appStore.dispatch(TutorialState.tutorialAction.setIsFinishedUserSetting(result: isFinishedUserSetting))
    }
}
