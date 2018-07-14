//
//  EnglishNewsTableViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/09.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class EnglishNewsTableViewCell: UITableViewCell {

    static let CELL_HEIGHT: CGFloat = 128.0

    @IBOutlet weak private var englishNewsTitleLabel: UILabel!
    @IBOutlet weak private var englishNewsDateLabel: UILabel!
    @IBOutlet weak private var englishNewsTypeLabel: UILabel!
    @IBOutlet weak private var englishNewsSectionLabel: UILabel!
    @IBOutlet weak private var englishNewsByLineLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupEnglishNewsTableViewCell()
    }

    // MARK: - Function

    func setCell(_ englishNews: EnglishNewsEntity) {
        englishNewsTitleLabel.text   = englishNews.newsTitle
        englishNewsDateLabel.text    = englishNews.newsDate
        englishNewsTypeLabel.text    = englishNews.newsType
        englishNewsSectionLabel.text = englishNews.newsSection
        englishNewsByLineLabel.text  = englishNews.newsByLine
    }

    // MARK: - Private Function

    private func setupEnglishNewsTableViewCell() {
        self.accessoryType  = .none
        self.selectionStyle = .none
    }
}
