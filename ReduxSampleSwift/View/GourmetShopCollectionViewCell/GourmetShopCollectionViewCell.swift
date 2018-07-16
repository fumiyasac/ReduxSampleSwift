//
//  GourmetShopCollectionViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import AlamofireImage

class GourmetShopCollectionViewCell: UICollectionViewCell {

    static let CELL_SIZE: CGSize = CGSize(width: 150.0, height: 180.0)

    @IBOutlet weak private var gourmetShopWrappedView: UIView!
    @IBOutlet weak private var gourmetShopImageView: UIImageView!
    @IBOutlet weak private var gourmetShopFoodLabel: UILabel!
    @IBOutlet weak private var gourmetShopGenreLabel: UILabel!
    @IBOutlet weak private var gourmetShopTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGourmetShopCollectionViewCell()
    }

    // MARK: - Function

    func setCell(_ shop: GourmetShopEntity) {
        if let imageUrl = URL(string: shop.gourmetShopImageUrl) {
            gourmetShopImageView.af_setImage(withURL: imageUrl)
        }
        gourmetShopFoodLabel.text  = shop.gourmetShopFood
        gourmetShopGenreLabel.text = shop.gourmetShopGenre
        setAttributesForTitle(shop.gourmetShopName)
    }

    // MARK: - Private Function

    private func setAttributesForTitle(_ text: String) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        attributes[NSAttributedStringKey.font] = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 12.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor(code: "#ffffff")

        gourmetShopTitleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    private func setupGourmetShopCollectionViewCell() {
        gourmetShopWrappedView.clipsToBounds       = true
        gourmetShopWrappedView.layer.masksToBounds = false
        gourmetShopWrappedView.layer.borderColor   = UIColor.init(code: "#DDDDDD").cgColor
        gourmetShopWrappedView.layer.borderWidth   = 0.75
        gourmetShopWrappedView.layer.shadowRadius  = 3.0
        gourmetShopWrappedView.layer.shadowOpacity = 0.5
        gourmetShopWrappedView.layer.shadowOffset  = CGSize(width: 0.5, height: 0.5)
        gourmetShopWrappedView.layer.shadowColor   = UIColor.init(code: "#999999").cgColor
    }
}
