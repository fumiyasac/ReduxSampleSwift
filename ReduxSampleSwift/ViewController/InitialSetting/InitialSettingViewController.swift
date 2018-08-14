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
    // → stateにまとめて格納しているものを個別に使用するためにこのような形にしている
    private var isFinishedUserSetting: Bool = false
    private var isFinishedTutorial: Bool    = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Stateが更新された際に通知を検知できるようにするリスナーを登録する
        appStore.subscribe(self)

        // 現在のユーザーステータスを反映するActionCreatorを実行する
        InitialSettingActionCreator.setCurrentUserStatus()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // チュートリアルの終了状態に応じて画面遷移を切り替える
        chooseNextScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stateが更新された際に通知を検知できるようにするリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Function

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
        AppLogger.printStateForDebug(state.tutorialState, viewController: self)
        AppLogger.printStateForDebug(state.userSettingState, viewController: self)

        // 現在のチュートリアルの完了状態＆ユーザー登録の完了状態を取得する
        isFinishedUserSetting = state.tutorialState.isFinishedUserSetting
        isFinishedTutorial    = state.tutorialState.isFinishedTutorial
    }
}
