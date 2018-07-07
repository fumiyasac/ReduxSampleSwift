//
//  EnglishNewsFetchButtonView.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class EnglishNewsFetchButtonView: CustomViewBase {

    var fetchButtonAction: (() -> ())?

    @IBOutlet weak private var isLoadingWrappedView: UIView!
    @IBOutlet weak private var fetchButtonWrappedView: UIView!
    @IBOutlet weak private var fetchButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupEnglishNewsFetchButtonView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupEnglishNewsFetchButtonView()
    }

    // MARK: - Function

    // MARK: - Private Function

    @objc private func onUpPickupMessageButton(sender: UIButton) {
        fetchButtonAction?()
    }

    private func setupEnglishNewsFetchButtonView() {

        // TouchDownの時のイベントを設定する
        fetchButton.addTarget(self, action: #selector(self.onUpPickupMessageButton(sender:)), for: .touchUpInside)
    }
}
