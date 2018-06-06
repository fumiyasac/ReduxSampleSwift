//
//  GourmetShopCollectionViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/07.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class GourmetShopCollectionViewCell: UICollectionViewCell {

    static let CELL_SIZE: CGSize = CGSize(width: 150.0, height: 180.0)

    @IBOutlet weak private var gourmetShopWrappedView: UIView!
    @IBOutlet weak private var gourmetShopImageView: UIImageView!
    @IBOutlet weak private var gourmetShopCategoryLabel: UILabel!
    @IBOutlet weak private var gourmetShopTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGourmetShopCollectionViewCell()
    }

    // MARK: - Private Function

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
