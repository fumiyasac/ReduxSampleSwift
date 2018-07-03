//
//  EnglishNewsActionCreator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift
import SwiftyJSON
import PromiseKit

struct EnglishNewsActionCreator {}

extension EnglishNewsActionCreator {

    // 英語ニュースをページごとに取得する
    static func fetchEnglishNewsList(page: Int = 0) {

        //
        appStore.dispatch(EnglishNewsState.englishNewsAction.setIsLoadingEnglishNews())

        // 現在の初期設定状態を反映するアクションの実行
        APIManagerForNewYorkTimes.shared.getNewsList(page: page)
            .done { newsJSON in
                print(newsJSON)
                let englishNewsList = EnglishNews.getEnglishNewsListsBy(json: newsJSON)
                appStore.dispatch(EnglishNewsState.englishNewsAction.setEnglishNews(news: englishNewsList))
            }.catch { error in
                print(error)
                appStore.dispatch(EnglishNewsState.englishNewsAction.setIsErrorEnglishNews())
            }
    }
}
