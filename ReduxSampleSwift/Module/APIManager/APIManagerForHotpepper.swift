//
//  APIRequestManagerForHotpepper.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/05.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class APIManagerForHotpepper {

    private let baseUrl = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    private let key     = Constants.HOTPEPPER_API_KEY

    // MARK: - Singleton Instance

    static let shared = APIManagerForHotpepper()

    private init() {}

    // MARK: - Functions

    // hotpepperの設定した条件に紐づくお店情報の一覧を取得し、その中でランダムに5店舗を選出する
    func getRecommendShopList() -> Promise<JSON> {

        // 現在の設定している条件は下記の通りにしている(検索したい条件によってパラメータ設定を変更する)
        // 例.
        // -----------
        // (1) order: 4
        // → オススメ順で店舗情報をソート
        // (2) count: 100
        // → 1レスポンスあたりの店舗数は100件
        // (3) type: lite
        // → レスポンス項目を主要項目のみとする
        // (4) special_or: LU0017,LU0009,LU0031
        // → 特集コードをOR検索する
        //   - LU0017: 食事メインで楽しめるお店
        //   - LU0009: おしゃべりする夜カフェ夜ごはん
        //   - LU0031: 夜景を楽しむデート
        // ※ 詳細な条件の指定については下記のURLを参照してください。
        // https://webservice.recruit.co.jp/hotpepper/reference.html
        // -----------
        let parameters: [String : Any] = [
            "key"        : key,
            "format"     : "json",
            "order"      : 4,
            "count"      : 100,
            "type"       : "lite",
            "special_or" : "LU0017,LU0009,LU0031"
        ]

        // Alamofireの非同期通信をPromiseKitの処理でラッピングする
        return Promise { seal in
            Alamofire.request(baseUrl, method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {

                // 成功時の処理(表示に必要な部分だけを抜き出して返す)
                case .success(let response):

                    let res = JSON(response)
                    let json = res["results"]["shop"]
                    seal.fulfill(json)

                // 失敗時の処理(エラーの結果をそのまま返す)
                case .failure(let error):

                    seal.reject(error)
                }
            }
        }
    }

}
