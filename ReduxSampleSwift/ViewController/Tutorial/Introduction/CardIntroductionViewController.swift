//
//  CardIntroductionViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class CardIntroductionViewController: UIViewController {

    @IBOutlet private weak var cardBackgroundView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCardIntroductionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupCardIntroductionView() {
        cardBackgroundView.layer.masksToBounds = true
        cardBackgroundView.layer.cornerRadius  = 10.0
        cardBackgroundView.layer.borderWidth   = 1.0
        cardBackgroundView.layer.borderColor   = UIColor(code: "#ffdd00").cgColor
    }
}
