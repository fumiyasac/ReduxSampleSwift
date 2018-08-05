//
//  TutorialEntity.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/06.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct TutorialEntity {

    // メンバ変数
    let id: Int
    let title: String
    let description: String
    let imageFile: UIImage?

    // イニシャライザ
    init(id: Int, title: String, description: String, imageFile: UIImage?) {
        self.id          = id
        self.title       = title
        self.description = description
        self.imageFile   = imageFile
    }
}
