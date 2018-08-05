//
//  Tutorial.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/06.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class Tutorial {

    // MARK: - Static Functions

    static func getTutorialList() -> [TutorialEntity] {
        var tutorialList: [TutorialEntity] = []

        // 4件分のチュートリアル用のデータを作成する
        tutorialList.append(
            TutorialEntity.init(
                id: 1,
                title: "月別カレンダーでのメモ整理",
                description: "簡単に毎日つける習慣を！",
                imageFile: UIImage(named: "tutorial1")
            )
        )
        tutorialList.append(
            TutorialEntity.init(
                id: 2,
                title: "今日のおすすめグルメを紹介",
                description: "ランチやディナーの発見に！",
                imageFile: UIImage(named: "tutorial2")
            )
        )
        tutorialList.append(
            TutorialEntity.init(
                id: 3,
                title: "ピックアップコンテンツを掲載",
                description: "今回は金沢(石川県)を紹介！",
                imageFile: UIImage(named: "tutorial3")
            )
        )
        tutorialList.append(
            TutorialEntity.init(
                id: 4,
                title: "NewYorkTimesとの連携も",
                description: "英語のニュースや情勢を確認！",
                imageFile: UIImage(named: "tutorial4")
            )
        )

        return tutorialList
    }
}
