//
//  EnglishNewsReducer.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import ReSwift

struct EnglishNewsReducer {}

extension EnglishNewsReducer {
    
    static func reducer(action: ReSwift.Action, state: EnglishNewsState?) -> EnglishNewsState {
        
        // 英語ニュース記事取得状態のstateを取得する(ない場合は初期状態とする)
        var state = state ?? EnglishNewsState()

        // 英語ニュース記事取得状態のstateを変更させるアクションでない場合はstateの変更は許容しない
        guard let action = action as? EnglishNewsState.englishNewsAction else { return state }

        switch action {

        case .setIsLoadingEnglishNews():
            state.isLoadingEnglishNews = true

        case let .setEnglishNews(news):
            state.isLoadingEnglishNews = false
            state.englishNewsList      = state.englishNewsList + news
            state.itemsPerPage         = state.itemsPerPage + 1
            state.isErrorEnglishNews   = false
            
        case .setIsErrorEnglishNews():
            state.isLoadingEnglishNews = false
            state.isErrorEnglishNews   = true
        }

        // Debug.
        print("---")
        print("EnglishNewsStateが更新されました。")
        print("---\n\n")

        return state
    }
}
