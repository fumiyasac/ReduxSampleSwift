//
//  InitialSettingViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class InitialSettingViewController: UIViewController {

    // ユーザーの登録状態を格納する変数
    fileprivate var isFinishedUserSetting: Bool = false
    fileprivate var isFinishedTutorial: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Stateが更新された際に通知を検知できるようにappStoreにリスナーを登録する
        appStore.subscribe(self)

        // 現在のユーザーステータスのアクション(ReSwift)を実行する
        executeCurrentStatusActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // チュートリアルの終了状態に応じて画面遷移を切り替える
        chooseNextScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stateが更新された際に通知を検知できるようにappStoreに登録したリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Function

    private func executeCurrentStatusActions() {

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

        // 現在の初期設定状態を反映するアクションの実行
        appStore.dispatch(
            TutorialState.tutorialAction.setInstallAppDate(date: installAppDate)
        )
        appStore.dispatch(
            TutorialState.tutorialAction.setIsFinishedTutorial(result: isFinishedTutorial)
        )
        appStore.dispatch(
            TutorialState.tutorialAction.setIsFinishedUserSetting(result: isFinishedUserSetting)
        )
    }

    private func chooseNextScreen() {

        // チュートリアルの状態に応じて画面遷移を切り替える
        var identifierName: String
        if isFinishedUserSetting {
            identifierName = "goMain"
        } else if isFinishedTutorial {
            identifierName = "goUserSetting"
        } else {
            identifierName = "goTutorial"
        }
        performSegue(withIdentifier: identifierName, sender: self)
    }
}

// MARK: - StoreSubscriber

extension InitialSettingViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        print("TutorialStateの変更をInitialSettingViewControllerで受け取りました。")

        // 現在のチュートリアルの完了状態＆ユーザー登録の完了状態を取得する
        isFinishedUserSetting = state.tutorialState.isFinishedUserSetting
        isFinishedTutorial = state.tutorialState.isFinishedTutorial
    }
}
