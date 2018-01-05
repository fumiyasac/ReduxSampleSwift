//
//  APIRequestManager.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/05.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import Alamofire

class APIRequestManager {

    private let baseUri = "https://webservice.recruit.co.jp/hotpepper/"
    private let version = "v1"

    //エンドポイントの定義をするenum
    private enum endPoint: String {
        case shop         = "shop"
        case genre        = "genre"
        case foodCategory = "food_category"
        case largeArea    = "large_area"
        case middleArea   = "middle_area"
    }

    //MARK: - Singleton Instance

    static let shared = APIRequestManager()

    private init() {}

    //MARK: - Functions

    //hotpepperのお店IDに紐づくお店情報を取得する
}
