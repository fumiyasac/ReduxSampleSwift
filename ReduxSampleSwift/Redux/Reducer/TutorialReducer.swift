//
//  TutorialReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/30.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension TutorialState {

    static func reducer(action: ReSwift.Action, state: TutorialState?) -> TutorialState {

        //チュートリアル完了状態のstateを取得する(ない場合は初期状態とする)
        var state = state ?? TutorialState()

        //チュートリアル完了状態のstateを変更させるアクションでない場合はステートの変更は許容しない
        guard let action = action as? TutorialState.tutorialAction else { return state }

        switch action {

        //TutorialStateのfinishTutorialFlagの値を更新する
        case let .updateFinishTutorialFlag(result):
            state.finishTutorialFlag = result

        //TutorialStateのchangeRegionFlagの値を更新する
        case let .updateChangeRegionFlag(result):
            state.changeRegionFlag = result
        }

        //Debug.
        print(state)

        return state
    }
}
