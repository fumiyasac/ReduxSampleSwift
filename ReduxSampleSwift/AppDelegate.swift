//
//  AppDelegate.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/12.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

// 全てのStateを一元管理で管理するStoreを定義
let appStore = Store(reducer: appReduce, state: AppState(), middleware: [ActionLoggingMiddleware])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

