//
//  EnglishNewsEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct EnglishNewsEntity {

    // メンバ変数（取得したJSONレスポンスのKeyに対応する値が入る）
    let newsTitle: String
    let newsWebUrlString: String
    let newsType: String
    let newsSection: String
    let newsByLine: String
    let newsDate: String

    // イニシャライザ（取得したJSONレスポンスに対して必要なものを抽出する）
    init(json: JSON) {

        // New York Timesの公開APIから必要なものを取得した上で初期化処理を行う
        // 確認URL: http://developer.nytimes.com/article_search_v2.json#/Console/GET/articlesearch.json
        self.newsTitle        = json["headline"]["main"].string ?? ""
        self.newsWebUrlString = json["web_url"].string ?? ""
        self.newsType         = json["document_type"].string ?? ""
        self.newsSection      = json["section_name"].string ?? ""
        self.newsByLine       = json["byline"]["organization"].string ?? ""

        // 日付についてはIOS8601形式の文字列を変換して初期化処理を行う
        if let newsDate = json["pub_date"].string {
            self.newsDate = DateFormatterUtil.getDateStringFromAPI(apiDateString: newsDate)
        } else {
            self.newsDate = "--"
        }
    }
}
