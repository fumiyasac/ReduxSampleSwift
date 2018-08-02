//
//  AppLogger.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/31.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct AppLogger {

    // MARK: - Static Functions

    // 変更されたStateをconsoleへ出力する
    static func printStateForDebug(_ targetState: ReSwift.StateType, viewController: UIViewController) {

        let viewControllerName = String(describing: type(of: viewController))
        print("---")
        print("State Logging #start:", viewControllerName)
        print(targetState)
        print("State Logging #end:")
        print("---\n\n")
    }

    // 実行されたActionCreatorをconsoleへ出力する
    static func printExecuteActionForDebug(_ targetAction: ReSwift.Action) {

        print("---")
        print("ActionCreator logging #start:")
        print(targetAction)
        print("ActionCreator logging #end:")
        print("---\n\n")
    }

    // メッセージをconsoleへ出力する
    static func printMessageForDebug(_ message: String) {

        print("---")
        print(message)
        print("---\n\n")
    }
}
