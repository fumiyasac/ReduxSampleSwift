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
    static func fetchEnglishNewsList(page: Int = 0, refresh: Bool = false) {

        // 第2引数のリフレッシュの有無に応じてどの位置からデータを取得するかを変える
        let currentPage = (refresh) ? 0 : page

        // データ読み込み中の状態を反映するアクションの実行
        appStore.dispatch(EnglishNewsState.englishNewsAction.setIsLoadingEnglishNews)

        // NYTのAPIから該当ページ番号のニュース一覧を取得する
        APIManagerForNewYorkTimes.shared.getNewsList(page: currentPage)
            .done { newsJSON in

                // 成功時: ニュースの一覧を反映するアクションの実行
                let englishNewsList = EnglishNews.getEnglishNewsListsBy(json: newsJSON)
                appStore.dispatch(EnglishNewsState.englishNewsAction.setEnglishNews(news: englishNewsList, refresh: refresh))

            }.catch { error in

                // 失敗時: データ読み込み失敗時の状態を反映するアクションの実行
                appStore.dispatch(EnglishNewsState.englishNewsAction.setIsErrorEnglishNews)
            }
    }
}
