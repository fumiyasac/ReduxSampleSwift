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

    // チュートリアルの終了状態を格納する変数
    fileprivate var isFinishedTutorial: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Stateが更新された際に通知を検知できるようにappStoreにリスナーを登録する
        appStore.subscribe(self)

        // tutorialAction.setCurrentStatusアクション(ReSwift)を実行する
        executeSetCurrentStatusAction()
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

    private func executeSetCurrentStatusAction() {

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

        let setCurrentStatusAction = TutorialState.tutorialAction.setCurrentStatus(
            initialSetting: (isFinishedTutorial: isFinishedTutorial, installAppDate: installAppDate)
        )

        // 現在の初期設定状態を反映するアクションの実行
        appStore.dispatch(setCurrentStatusAction)
    }

    private func chooseNextScreen() {

        // チュートリアルの状態に応じて画面遷移を切り替える
        if isFinishedTutorial {
            performSegue(withIdentifier: "goMain", sender: self)
        } else {
            performSegue(withIdentifier: "goTutorial", sender: self)
        }
    }
}

// MARK: - StoreSubscriber

extension InitialSettingViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        print("TutorialState change is observed in InitialSettingViewController !!!")

        // チュートリアルの完了状態に応じて表示する画面を決定する
        isFinishedTutorial = state.tutorialState.isFinishedTutorial
    }
}
