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

class APIRequestManagerForHotpepper {

    private static let domain  = "https://webservice.recruit.co.jp/hotpepper/"
    private static let version = "v1"

    private let key     = Constants.HOTPEPPER_API_KEY
    private let format  = "json"

    //エンドポイントの定義をするenum
    private enum endPoint: String {
        case shop         = "shop"
        case largeArea    = "large_area"
        case middleArea   = "middle_area"

        func getBaseUrl() -> String {
            let baseUrl = "\(domain)/\(self.rawValue)/\(version)"
            return baseUrl
        }
    }

    //MARK: - Singleton Instance

    static let shared = APIRequestManagerForHotpepper()

    private init() {}

    //MARK: - Functions

    //hotpepperのお店IDに紐づくお店情報を取得する
    func getShopDetailBy(targetId: String) -> Promise<JSON> {
        let parameters = [
            "key"    : key,
            "format" : format,
            "id"     : targetId,
        ]

        //Alamofireの非同期通信をPromiseKitの処理でラッピングする
        return Promise { fulfill, reject in
            Alamofire.request(endPoint.shop.getBaseUrl(), method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let data):
                    fulfill(JSON(data))
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }

    //Hotpepper掲載店舗一覧検索用の都道府県の一覧を取得する
    func getLargeAreaList() -> Promise<JSON> {
        let parameters = [
            "key"    : key,
            "format" : format,
        ]

        //Alamofireの非同期通信をPromiseKitの処理でラッピングする
        return Promise { fulfill, reject in
            Alamofire.request(endPoint.largeArea.getBaseUrl(), method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let data):
                    fulfill(JSON(data))
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }

    //Hotpepper掲載店舗一覧検索用の市区町村の一覧を取得する
    func getMiddleAreaList() -> Promise<JSON> {
        let parameters = [
            "key"    : key,
            "format" : format,
        ]

        //Alamofireの非同期通信をPromiseKitの処理でラッピングする
        return Promise { fulfill, reject in
            Alamofire.request(endPoint.middleArea.getBaseUrl(), method: .get, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let data):
                    fulfill(JSON(data))
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}
