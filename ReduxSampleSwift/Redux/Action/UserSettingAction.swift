//
//  UserSettingAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension UserSettingState {
    
    // ユーザーの回答に関するstateを変更させるアクションをEnumで定義する
    enum userSettingAction: ReSwift.Action {

        // キーボードの表示状態が更新された際に実行されるアクション
        case setKeyboardIsShown(result: Bool)

        // 郵便番号が入力された際に実行されるアクション
        case setPostalCode(postalCode: String)

        // 住んでいる年数が選択された際に実行されるアクション
        case setSelectedResidentPeriod(residentPeriod: Int)
        
        // 自由入力項目が入力された際に実行されるアクション
        case setFreeWord(freeWord: String)

        // ニックネームが入力された際に実行されるアクション
        case setNickName(nickName: String)

        // 性別が選択された際に実行されるアクション
        case setGender(gender: Int)

        // 住んでいる年数が選択された際に実行されるアクション
        case setSelectedAge(age: Int)

        // 登録されているユーザーデータをセットする際のアクション
        case setCreatedUserSetting(userSetting: UserSettingEntity)
    }
}
