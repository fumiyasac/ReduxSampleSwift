//
//  ActionLoggingMiddleware.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// どのアクションが発火したかを表示するためのMiddleware
let ActionLoggingMiddleware: Middleware<Any> = { dispatch, getState in
    return { next in
        return { action in

            // Debug.
            print("---")
            print("ActionCreator logging #start: ActionCreatorからActionが実行されました。")
            // 実行されたアクションが何かのログを表記する
            print("実行されたアクション名:", action)
            print("ActionCreator logging #end:")
            print("---\n\n")

            // 該当するReducerへの処理を実行する
            return next(action)
        }
    }
}
