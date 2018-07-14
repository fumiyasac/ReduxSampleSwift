//
//  EnglishNewsState.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

// 英語ニュースの通過状態に関するstateの定義
struct EnglishNewsState: ReSwift.StateType {

    // 英語ニュースが読み込み中かを判定するフラグ（初期値: false）
    var isLoadingEnglishNews: Bool = false

    // 英語ニュースの現在のページ番号数（初期値: 0）
    var itemsPerPage: Int = 0

    // 英語ニュースの一覧を格納する配列（初期値: []）
    var englishNewsList: [EnglishNewsEntity] = []

    // 英語ニュースが読み込み失敗かを判定するフラグ（初期値: false）
    var isErrorEnglishNews: Bool = false
}
