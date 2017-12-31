//
//  AppState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/17.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

//アプリの現在状態をに関するState
struct AppState: ReSwift.StateType {

    //チュートリアルの通過状態に関するstate
    var tutorialState = TutorialState()
}
