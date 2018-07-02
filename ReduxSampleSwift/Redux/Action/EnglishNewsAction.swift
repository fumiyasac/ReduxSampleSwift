//
//  EnglishNewsAction.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

extension EnglishNewsState {

    // 英語ニュース記事取得状態のstateを変更させるアクションをEnumで定義する
    enum englishNewsAction: ReSwift.Action {

        // 英語ニュース記事の読み込み状態の値をセットするアクション
        case setIsLoadingEnglishNews()

        // 英語ニュース記事の読み込み成功時にAPIより取得した値をセットするアクション
        case setEnglishNews(news: [EnglishNewsEntity])

        // 英語ニュース記事の読み込み失敗時に値をセットするアクション
        case setIsErrorEnglishNews()
    }
}
