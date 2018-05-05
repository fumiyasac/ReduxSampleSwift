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
        
        case let .setKeyboardIsShown(result):
            state.keyboardIsShown = result

        case let .setPostalCode(postalCode):
            state.postalCode = adjustPostalCode(postalCode: postalCode)
            
        case let .setSelectedResidentPeriod(residentPeriod):
            state.selectedResidentPeriod = residentPeriod

        case let .setFreeWord(freeWord):
            state.freeWord = adjustFreeWord(freeWord: freeWord)

        case let .setNickname(nickName):
            state.nickName = adjustNickName(nickName: nickName)

        case let .setGender(gender):
            state.gender = gender

        case let .setSelectedAge(age):
            state.selectedAge = age

        case let .setCreatedUserSetting(userSetting):
            state.postalCode             = adjustPostalCode(postalCode: userSetting.postalCode)
            state.selectedResidentPeriod = userSetting.selectedResidentPeriod
            state.freeWord               = adjustFreeWord(freeWord: userSetting.freeWord)
            state.nickName               = adjustNickName(nickName: userSetting.nickName)
            state.gender                 = userSetting.gender
            state.selectedAge            = userSetting.selectedAge
        }

        // Debug.
        print("UserSettingStateが更新されました。")

        return state
    }

    // 郵便番号を7桁で制限する
    private static func adjustPostalCode(postalCode: String) -> String {
        let limit = AppConstants.POSTAL_CODE_LIMIT
        var targetPostalCode = postalCode
        if targetPostalCode.count > limit {
            targetPostalCode = String(targetPostalCode.prefix(limit))
        }
        return targetPostalCode
    }

    // 自由入力を200文字で制限する
    private static func adjustFreeWord(freeWord: String) -> String {
        let limit = AppConstants.FREE_WORD_LIMIT
        var targetFreeWord = freeWord
        if targetFreeWord.count > limit {
            targetFreeWord = String(targetFreeWord.prefix(limit))
        }
        return targetFreeWord
    }

    // ニックネームを20文字で制限する
    private static func adjustNickName(nickName: String) -> String {
        let limit = AppConstants.NICK_NAME_LIMIT
        var targetNickName = nickName
        if targetNickName.count > limit {
            targetNickName = String(targetNickName.prefix(limit))
        }
        return targetNickName
    }
}

