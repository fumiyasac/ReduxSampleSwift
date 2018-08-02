//
//  PickupMessageCollectionViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import AlamofireImage

class PickupMessageCollectionViewCell: UICollectionViewCell {

    private let cellShrinkDuration: TimeInterval = 0.16
    private let cellShrinkRatio: CGFloat         = 0.92

    var pickupMessageButtonAction: (() -> ())?

    @IBOutlet weak private var pickupMessageWrappedView: UIView!
    @IBOutlet weak private var pickupMessageCategoryLabel: UILabel!
    @IBOutlet weak private var pickupMessageTitleLabel: UILabel!
    @IBOutlet weak private var pickupMessageImageView: UIImageView!
    @IBOutlet weak private var pickupMessageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupPickupMessageButton()
    }

    // MARK: - Function

    func setCell(_ pickupMessage: PickupMessageEntity) {
        if let imageUrl = URL(string: pickupMessage.imageUrl) {
            pickupMessageImageView.af_setImage(withURL: imageUrl)
        }
        pickupMessageCategoryLabel.text = pickupMessage.category
        setAttributesForTitle(pickupMessage.title)
    }

    // MARK: - Private Functions

    @objc private func onDownPickupMessageButton(sender: UIButton) {
        UIView.animate(withDuration: cellShrinkDuration, animations: {
            self.pickupMessageWrappedView.transform = CGAffineTransform(scaleX: self.cellShrinkRatio, y: self.cellShrinkRatio)
        }, completion: nil)
    }

    @objc private func onUpPickupMessageButton(sender: UIButton) {
        UIView.animate(withDuration: cellShrinkDuration, animations: {
            self.pickupMessageWrappedView.transform = CGAffineTransform.identity
        }, completion: { finished in

            // ViewController側でクロージャー内に設定した処理を実行する
            self.pickupMessageButtonAction?()
        })
    }

    private func setAttributesForTitle(_ text: String) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        attributes[NSAttributedStringKey.font] = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 15.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor(code: "#ffffff")
        
        pickupMessageTitleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    private func setupPickupMessageButton() {

        // TouchUp・TouchDownの時のイベントを設定する（完了時の具体的な処理はTouchUp側で設定すること）
        pickupMessageButton.addTarget(self, action: #selector(self.onDownPickupMessageButton(sender:)), for: .touchDown)
        pickupMessageButton.addTarget(self, action: #selector(self.onUpPickupMessageButton(sender:)), for: [.touchUpInside, .touchUpOutside])

        // ハイライト（ボタン押下）時にボタンの色を変化させないようにする
        pickupMessageButton.adjustsImageWhenHighlighted = false
    }
}
