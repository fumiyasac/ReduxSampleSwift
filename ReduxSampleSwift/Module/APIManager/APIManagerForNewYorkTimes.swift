//
//  APIManagerForNewYorkTimes.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class APIManagerForNewYorkTimes {

    private let baseUrl  = "https://api.nytimes.com/svc/search/v2/articlesearch.json"
    private let key = Constants.NEWYORKTIMES_API_KEY

    // MARK: - Singleton Instance

    static let shared = APIManagerForNewYorkTimes()

    private init() {}

    // MARK: - Functions

    // NewYorkTimesの最新ニュース一覧を取得する
    func getNewsList(page: Int = 0) -> Promise<JSON> {

        // APIにリクエストする際に必要なパラメーターを定義する
        let parameters: [String : Any] = [
            "api-key" : key,
            "sort"    : "newest",
            "id"      : "web_url,pub_date,headline,document_type,section_name,byline",
            "page"    : page
        ]

        // Alamofireの非同期通信をPromiseKitの処理でラッピングする
        // 例.
        // -----------
        // getNewsList(page: 0)
        //    .done { json in
        //        // 受け取ったJSONに関する処理をする
        //        print(json)
        //    }
        //    .catch { error in
        //        // エラーを受け取った際の処理をする
        //        print(error.localizedDescription)
        //    }
        // -----------
        // 参考URL:
        // https://medium.com/@guerrix/101-alamofire-promisekit-671436726ff6
        // ※ Swift4.1では書き方が変わっているのでご注意を!
        // https://stackoverflow.com/questions/48932536/swift4-error-cannot-convert-value-of-type-void-to-expected-argument-typ
        return Promise { seal in
            Alamofire.request(baseUrl, method: .get, parameters: parameters).validate().responseJSON { response in

                switch response.result {

                // 成功時の処理(表示に必要な部分だけを抜き出して返す)
                case .success(let response):

                    let res = JSON(response)
                    let json = res["response"]["docs"]
                    seal.fulfill(json)

                // 失敗時の処理(エラーの結果をそのまま返す)
                case .failure(let error):
 
                    seal.reject(error)
                }
            }
        }

    }
}
