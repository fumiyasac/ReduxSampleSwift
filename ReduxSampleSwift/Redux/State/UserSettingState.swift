//
//  UserSettingState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// ユーザーの回答に関するstateの定義
struct UserSettingState: ReSwift.StateType {

    // 入力された郵便番号（初期値: ""）
    var postalCode: String = ""

    // 選択された住んでいる年数（初期値: 0）
    var selectedResidentPeriod: Int = 0
    
    // 入力された自由入力項目（初期値: ""）
    var freeWord: String = ""
    
    // 入力されたニックネーム（初期値: ""）
    var nickname: String = ""

    // 選択された性別（初期値: 0）
    var gender: Int = 0

    // 選択された年齢（初期値: 0）
    var selectedAge: Int = 0
}
