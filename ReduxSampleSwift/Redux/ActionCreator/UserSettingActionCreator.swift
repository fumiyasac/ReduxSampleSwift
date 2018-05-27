//
//  UserSettingActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/22.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

struct UserSettingActionCreator {}

extension UserSettingActionCreator {

    // キーボード表示時のステータス変更を反映する
    static func showKeyboardStatus() {
        let setKeyboardIsShownAction = UserSettingState.userSettingAction.setKeyboardIsShown(result: true)
        appStore.dispatch(setKeyboardIsShownAction)
    }

    // キーボード非表示時のステータス変更を反映する
    static func hideKeyboardStatus() {
        let setKeyboardIsShownAction = UserSettingState.userSettingAction.setKeyboardIsShown(result: false)
        appStore.dispatch(setKeyboardIsShownAction)
    }

    // 郵便番号の入力変更を反映する
    static func changePostalCodeInput(postalCode: String) {
        let setPostalCodeAction = UserSettingState.userSettingAction.setPostalCode(postalCode: postalCode)
        appStore.dispatch(setPostalCodeAction)
    }

    // お住まいの年数の選択変更を反映する
    static func changeResidentPeriodSelect(residentPeriod: SelectedResidentPeriodEnum) {
        let selectedResidentPeriodAction = UserSettingState.userSettingAction.setSelectedResidentPeriod(residentPeriod: residentPeriod.getStatusCode())
        appStore.dispatch(selectedResidentPeriodAction)
    }

    // 自由入力項目の入力変更を反映する
    static func changeFreeWordInput(freeWord: String) {
        let setFreeWordAction = UserSettingState.userSettingAction.setFreeWord(freeWord: freeWord)
        appStore.dispatch(setFreeWordAction)
    }

    // ニックネームの入力変更を反映する
    static func changeNickNameInput(nickName: String) {
        let setNickNameAction = UserSettingState.userSettingAction.setNickName(nickName: nickName)
        appStore.dispatch(setNickNameAction)
    }

    // 性別の選択変更を反映する
    static func changeGenderSelect(gender: Int) {
        let setGenderAction = UserSettingState.userSettingAction.setGender(gender: gender)
        appStore.dispatch(setGenderAction)
    }

    // 年齢の選択変更を反映する
    static func changeAgeSelect(age: SelectedAgeEnum) {
        let selectedAgeAction = UserSettingState.userSettingAction.setSelectedAge(age: age.getStatusCode())
        appStore.dispatch(selectedAgeAction)
    }

    // ユーザーアンケート情報をRealmへ登録する
    static func submitUserSetting(userSetting: UserSettingEntity) {
        UserSetting.addUserSetting(userSetting: userSetting)
        let updateIsFinishedUserSettingAction = TutorialState.tutorialAction.setIsFinishedUserSetting(result: true)
        appStore.dispatch(updateIsFinishedUserSettingAction)
    }
}
