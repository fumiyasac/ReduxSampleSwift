//
//  PickupMessageCollectionViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class PickupMessageCollectionViewCell: UICollectionViewCell {

    var pickupMessageButtonAction: (() -> ())?

    @IBOutlet weak private var pickupMessageWrappedView: UIView!
    @IBOutlet weak private var pickupMessageImageView: UIImageView!
    @IBOutlet weak private var pickupMessageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupPickupMessageButton()
    }

    // MARK: - Private Functions

    @objc private func onDownPickupMessageButton(sender: UIButton) {
        UIView.animate(withDuration: 0.10, animations: {
            self.pickupMessageWrappedView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: nil)
    }

    @objc private func onUpPickupMessageButton(sender: UIButton) {
        UIView.animate(withDuration: 0.10, animations: {
            self.pickupMessageWrappedView.transform = CGAffineTransform.identity
        }, completion: { finished in

            // ViewController側でクロージャー内に設定した処理を実行する
            self.pickupMessageButtonAction?()
        })
    }

    private func setupPickupMessageButton() {

        // TouchUp・TouchDownの時のイベントを設定する（完了時の具体的な処理はTouchUp側で設定すること）
        pickupMessageButton.addTarget(self, action: #selector(self.onDownPickupMessageButton(sender:)), for: .touchDown)
        pickupMessageButton.addTarget(self, action: #selector(self.onUpPickupMessageButton(sender:)), for: [.touchUpInside, .touchUpOutside])

        // ハイライト（ボタン押下）時にボタンの色を変化させないようにする
        pickupMessageButton.adjustsImageWhenHighlighted = false
    }
}
