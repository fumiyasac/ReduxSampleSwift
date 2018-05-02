//
//  UserSettingReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct UserSettingReducer {}

extension UserSettingReducer {

    static func reducer(action: ReSwift.Action, state: UserSettingState?) -> UserSettingState {

        // ユーザーの回答状態のstateを取得する(ない場合は初期状態とする)
        var state = state ?? UserSettingState()

        // ユーザーの回答状態のstateを変更させるアクションでない場合はステートの変更は許容しない
        guard let action = action as? UserSettingState.userSettingAction else { return state }

        switch action {

        case let .setPostalCode(postalCode):
            state.postalCode = postalCode
            
        case let .setSelectedResidentPeriod(residentPeriod):
            state.selectedResidentPeriod = residentPeriod

        case let .setFreeWord(freeWord):
            state.freeWord = freeWord

        case let .setNickname(nickname):
            state.nickname = nickname

        case let .setGender(gender):
            state.gender = gender

        case let .setSelectedAge(age):
            state.selectedAge = age

        case let .setCreatedUserSetting(userSetting):
            state.postalCode             = userSetting.postalCode
            state.selectedResidentPeriod = userSetting.selectedResidentPeriod
            state.freeWord               = userSetting.freeWord
            state.nickname               = userSetting.nickname
            state.gender                 = userSetting.gender
            state.selectedAge            = userSetting.selectedAge
        }

        // Debug.
        print("UserSettingStateが更新されました。")

        return state
    }
}

