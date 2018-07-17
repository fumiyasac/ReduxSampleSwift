//
//  MainContentsRemarkView.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/17.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class MainContentsRemarkView: CustomViewBase {

    static let VIEW_HEIGHT: CGFloat = 33.0

    @IBOutlet weak private var remarkLabel: UILabel!

    // MARK: - Function

    func setRemark(_ text: String) {
        remarkLabel.text = text
    }
}
