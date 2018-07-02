//
//  EnglishNews.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import SwiftyJSON

class EnglishNews {

    // MARK: - Static Functions

    //
    static func getEnglishNewsListsBy(json: JSON) -> [EnglishNewsEntity] {
        var englishNewsEntityLists: [EnglishNewsEntity] = []
        for (key: _, value: newsJSON) in json {
            englishNewsEntityLists.append(EnglishNewsEntity.init(json: newsJSON))
        }
        return englishNewsEntityLists
    }
}
