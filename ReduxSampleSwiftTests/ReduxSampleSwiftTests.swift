//
//  ReduxSampleSwiftTests.swift
//  ReduxSampleSwiftTests
//
//  Created by 酒井文也 on 2017/12/12.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import XCTest
import ReSwift
import SwiftyJSON

@testable import ReduxSampleSwift

// MEMO: このテストに関する意図について
// Reduxのデータフローにおける「Store(before state) → Action → Reducer → Store(after state)」の担保をしたい意図がある
// 実際のサンプルコード内ではActionCreatorでViewの表示に関するデータを取得しそのデータをAction経由で送ることでStateへ反映する処理を行う。
// ActionCreator自体はAction発行処理をラッピングしているため、Reduxのデータフロー処理を担保する必要があったのでこの形にした。

// 参考: Getting started with Redux in Swift - Part 1
// https://medium.com/mackmobile/getting-started-with-redux-in-swift-54e00f323e2b

class ReduxSampleSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // setUp時に行う処理
    }
    
    override func tearDown() {
        // tearDown時に行う処理
        super.tearDown()
    }

    // 初回設定に関するStateにおいてActionの発行から値反映までが実行されているかを確認するテスト
    func testInitialSettingState() {

        let appStore = Store(reducer: appReduce, state: AppState(), middleware: [ActionLoggingMiddleware])

        // Action発行前の値に関するテスト
        let beforeInstallAppDate  = appStore.state.tutorialState.installAppDate
        let beforeIsFinishedUserSetting = appStore.state.tutorialState.isFinishedUserSetting
        let beforeIsFinishedTutorial = appStore.state.tutorialState.isFinishedTutorial

        XCTAssertEqual(nil, beforeInstallAppDate, "最初はinstallAppDateがnilである")
        XCTAssertEqual(false, beforeIsFinishedUserSetting, "最初はisFinishedUserSettingがfalseである")
        XCTAssertEqual(false, beforeIsFinishedTutorial, "最初はisFinishedTutorialがfalseである")

        // アクションの実行 ※InitialSettingActionCreator.setCurrentUserStatus()
        let currentDate = Date()
        appStore.dispatch(
            TutorialState.tutorialAction.setInstallAppDate(date: currentDate)
        )
        appStore.dispatch(
            TutorialState.tutorialAction.setIsFinishedTutorial(result: true)
        )
        appStore.dispatch(
            TutorialState.tutorialAction.setIsFinishedUserSetting(result: true)
        )

        // Action発行後の値に関するテスト
        let afterInstallAppDate = appStore.state.tutorialState.installAppDate
        let afterIsFinishedUserSetting = appStore.state.tutorialState.isFinishedUserSetting
        let afterIsFinishedTutorial = appStore.state.tutorialState.isFinishedTutorial

        XCTAssertEqual(currentDate, afterInstallAppDate, "installAppDateにAction経由で現在時刻が反映される")
        XCTAssertEqual(true, afterIsFinishedUserSetting, "isFinishedUserSettingにAction経由でtrueが反映される")
        XCTAssertEqual(true, afterIsFinishedTutorial, "isFinishedTutorialにAction経由でtrueが反映される")
    }

    // チュートリアル画面に関するStateにおいてActionの発行から値反映までが実行されているかを確認するテスト
    func testTutorialState() {

        let appStore = Store(reducer: appReduce, state: AppState(), middleware: [ActionLoggingMiddleware])

        // Action発行前の値に関するテスト
        let firstPageIndex = appStore.state.tutorialState.currentPageViewControllerIndex
        XCTAssertEqual(0, firstPageIndex, "最初のインデックス値は0である")

        // 現在のUIPageViewControllerのインデックス値を反映するアクションの実行 ※TutorialActionCreator.setCurrentPage(index: Int)
        appStore.dispatch(
            TutorialState.tutorialAction.setCurrentPageViewControllerIndex(index: 1)
        )
        let secondPageIndex = appStore.state.tutorialState.currentPageViewControllerIndex
        appStore.dispatch(
            TutorialState.tutorialAction.setCurrentPageViewControllerIndex(index: 2)
        )
        let thirdPageIndex = appStore.state.tutorialState.currentPageViewControllerIndex
        appStore.dispatch(
            TutorialState.tutorialAction.setCurrentPageViewControllerIndex(index: 3)
        )
        let fourthPageIndex = appStore.state.tutorialState.currentPageViewControllerIndex

        // Action発行後の値に関するテスト
        XCTAssertEqual(1, secondPageIndex, "次のインデックス値は1である")
        XCTAssertEqual(2, thirdPageIndex,  "次のインデックス値は2である")
        XCTAssertEqual(3, fourthPageIndex, "次のインデックス値は3である")
    }

    // ユーザーアンケート入力画面に関するStateにおいてActionの発行から値反映までが実行されているかを確認するテスト
    func testUserSettingState() {

        let appStore = Store(reducer: appReduce, state: AppState(), middleware: [ActionLoggingMiddleware])

        // Action発行前の値に関するテスト
        let beforeKeyboardIsShown  = appStore.state.userSettingState.keyboardIsShown
        let beforePostalCode = appStore.state.userSettingState.postalCode
        let beforeResidentPeriod = appStore.state.userSettingState.selectedResidentPeriod
        let beforeFreeWord = appStore.state.userSettingState.freeWord
        let beforeNickName = appStore.state.userSettingState.nickName
        let beforeGender = appStore.state.userSettingState.gender
        let beforeAge = appStore.state.userSettingState.selectedAge

        XCTAssertEqual(false, beforeKeyboardIsShown, "最初はキーボードが表示されていない状態である")
        XCTAssertEqual("", beforePostalCode, "Q1の初期状態は空文字である")
        XCTAssertEqual(0, beforeResidentPeriod, "Q2の初期状態は0である")
        XCTAssertEqual("", beforeFreeWord, "Q3の初期状態は空文字である")
        XCTAssertEqual("", beforeNickName, "Q4の初期状態は空文字である")
        XCTAssertEqual(0, beforeGender, "Q5の初期状態は0である")
        XCTAssertEqual(0, beforeAge, "Q6の初期状態は0である")

        // UserSettingActionCreator内に定義した値を反映するアクションの実行
        let setKeyboardIsShownAction = UserSettingState.userSettingAction.setKeyboardIsShown(result: true)
        appStore.dispatch(setKeyboardIsShownAction)

        let postalCode = "1700005"
        let setPostalCodeAction = UserSettingState.userSettingAction.setPostalCode(postalCode: postalCode)
        appStore.dispatch(setPostalCodeAction)

        let statusCode = SelectedResidentPeriodEnum.first.getStatusCode()
        let selectedResidentPeriodAction = UserSettingState.userSettingAction.setSelectedResidentPeriod(residentPeriod: statusCode)
        appStore.dispatch(selectedResidentPeriodAction)

        let freeWord = "こちらはサンプルテキストになります。入力時のテストコード用の仮の値となります。"
        let setFreeWordAction = UserSettingState.userSettingAction.setFreeWord(freeWord: freeWord)
        appStore.dispatch(setFreeWordAction)

        let nickName = "fumiyasac"
        let setNickNameAction = UserSettingState.userSettingAction.setNickName(nickName: nickName)
        appStore.dispatch(setNickNameAction)

        let gender = 1
        let setGenderAction = UserSettingState.userSettingAction.setGender(gender: gender)
        appStore.dispatch(setGenderAction)

        let age = SelectedAgeEnum.first.getStatusCode()
        let selectedAgeAction = UserSettingState.userSettingAction.setSelectedAge(age: age)
        appStore.dispatch(selectedAgeAction)

        // Action発行後の値に関するテスト
        let afterSetKeyboardIsShownAction = appStore.state.userSettingState.keyboardIsShown
        let afterPostalCode = appStore.state.userSettingState.postalCode
        let afterResidentPeriod = appStore.state.userSettingState.selectedResidentPeriod
        let afterFreeWord = appStore.state.userSettingState.freeWord
        let afterNickName = appStore.state.userSettingState.nickName
        let afterGender = appStore.state.userSettingState.gender
        let afterAge = appStore.state.userSettingState.selectedAge

        XCTAssertEqual(true, afterSetKeyboardIsShownAction, "キーボードが表示されている状態である")
        XCTAssertEqual(postalCode, afterPostalCode, "Q1の値と引数の値が同じ")
        XCTAssertEqual(statusCode, afterResidentPeriod, "Q2の値と引数の値が同じ")
        XCTAssertEqual(freeWord, afterFreeWord, "Q3の値と引数の値が同じ")
        XCTAssertEqual(nickName, afterNickName, "Q4の値と引数の値が同じ")
        XCTAssertEqual(gender, afterGender, "Q5の値と引数の値が同じ")
        XCTAssertEqual(age, afterAge, "Q6の値と引数の値が同じ")
    }

    // ピックアップメッセージ画面に関するStateにおいてActionの発行から値反映までが実行されているかを確認するテスト
    func testPickupMessageState() {

        let appStore = Store(reducer: appReduce, state: AppState(), middleware: [ActionLoggingMiddleware])

        // Action発行前の値に関するテスト
        let beforeIsPickupMessageAreaHidden = appStore.state.pickupMessageState.isPickupMessageAreaHidden
        let beforePickupMessageStateList = appStore.state.pickupMessageState.pickupMessageStateList

        XCTAssertEqual(false, beforeIsPickupMessageAreaHidden, "初期値はfalseである")
        XCTAssertEqual(0, beforePickupMessageStateList.count, "初期値は空配列である")

        // PickupMessageActionCreator内に定義した値を反映するアクションの実行
        appStore.dispatch(
            PickupMessageState.pickupMessageAction.setIsPickupMessageAreaHidden(result: true)
        )

        // MEMO: スタブで用意した形式のJSONファイルを読み込んでAction実行時にJSONの値を反映させる
        // ※ エンドポイントとほぼ同じレスポンスのJSONファイルを準備する
        let filePath = Bundle.main.url(forResource: "PickupMessageStub", withExtension: "json")!
        let messageJSON = JSON(try! Data(contentsOf: filePath))
        let pickupMessageList = PickupMessage.getPickupMessagesBy(json: messageJSON["article"]["contents"])

        appStore.dispatch(
            PickupMessageState.pickupMessageAction.setPickupMessage(pickupMessage: pickupMessageList)
        )

        // Action発行後の値に関するテスト
        let afterIsPickupMessageAreaHidden = appStore.state.pickupMessageState.isPickupMessageAreaHidden
        let afterPickupMessageStateList = appStore.state.pickupMessageState.pickupMessageStateList

        XCTAssertEqual(true, afterIsPickupMessageAreaHidden, "setIsPickupMessageAreaHiddenの引数と同じ値となる")
        XCTAssertEqual(18, afterPickupMessageStateList.count, "スタブ: pickupMessageStub.json内のデータ数と同じ値となる")
    }
}
