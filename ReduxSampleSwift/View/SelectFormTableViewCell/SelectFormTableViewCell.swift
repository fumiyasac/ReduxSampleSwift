//
//  SelectFormTableViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class SelectFormTableViewCell: UITableViewCell {

    private let DISABLED_REMARK_LABEL_TEXT = "未選択"
    private let ENABLED_REMARK_LABEL_TEXT = "選択中"

    private let DISABLED_REMARK_LABEL_BACKGROUND_COLOR = UIColor.init(code: "dddddd")
    private let ENABLED_REMARK_LABEL_BACKGROUND_COLOR = UIColor.init(code: "ff9900")
    private let DISABLED_TEXT_LABEL_COLOR = UIColor.init(code: "777777")
    private let ENABLED_TEXT_LABEL_COLOR = UIColor.init(code: "555555")
    
    @IBOutlet weak private var targetRemarkLabel: UILabel!
    @IBOutlet weak private var targetTextLabel: UILabel!

    private var targetStatusCode: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSelectFormTableViewCell()
    }

    // MARK: - Function

    func setCell(_ cellData: (isSelected: Bool, statusCode: Int, cellText: String)) {
        targetTextLabel.text = cellData.cellText
        targetStatusCode = cellData.statusCode
        if cellData.isSelected {
            targetRemarkLabel.text = ENABLED_REMARK_LABEL_TEXT
            targetRemarkLabel.backgroundColor = ENABLED_REMARK_LABEL_BACKGROUND_COLOR
            targetTextLabel.textColor = ENABLED_TEXT_LABEL_COLOR
        } else {
            targetRemarkLabel.text = DISABLED_REMARK_LABEL_TEXT
            targetRemarkLabel.backgroundColor = DISABLED_REMARK_LABEL_BACKGROUND_COLOR
            targetTextLabel.textColor = DISABLED_TEXT_LABEL_COLOR
        }
    }

    // MARK: - Private Function

    private func setupSelectFormTableViewCell() {
        self.accessoryType = .none
        self.selectionStyle = .none

        targetRemarkLabel.layer.cornerRadius = 6.0
        targetRemarkLabel.layer.masksToBounds = true
        targetRemarkLabel.backgroundColor = DISABLED_REMARK_LABEL_BACKGROUND_COLOR
    }
}
