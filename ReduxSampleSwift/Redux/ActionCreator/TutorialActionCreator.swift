//
//  TutorialActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/21.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct TutorialActionCreator {}

extension TutorialActionCreator {

    // チュートリアルが完了したことを記録する
    static func finishTutorial() {
        InitialSetting.setIsFinishedTutorial(result: true)
        let updateIsFinishTutorialAction = TutorialState.tutorialAction.setIsFinishedTutorial(result: true)
        appStore.dispatch(updateIsFinishTutorialAction)
    }

    // 現在のUIPageViewControllerの画面位置を記録する
    static func setCurrentPage(index: Int) {
        let pageViewControllerAction = TutorialState.tutorialAction.setCurrentPageViewControllerIndex(index: index)
        appStore.dispatch(pageViewControllerAction)
    }
}

