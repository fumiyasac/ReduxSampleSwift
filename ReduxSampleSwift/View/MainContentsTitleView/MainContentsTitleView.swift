//
//  MainContentsTitleView.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/09.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class MainContentsTitleView: CustomViewBase {

    static let VIEW_HEIGHT: CGFloat = 42.0

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!

    // MARK: - Function

    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    func setDescriptionIfNeeded(_ text: String = "") {
        descriptionLabel.text     = text
        descriptionLabel.isHidden = text.isEmpty
    }
}
