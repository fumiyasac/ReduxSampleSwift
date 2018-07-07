//
//  SelectFormTableViewCell.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/30.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class SelectFormTableViewCell: UITableViewCell {

    static let CELL_HEIGHT: CGFloat = 47.0

    private let enabledRemarkLabelText  = "選択中"
    private let disabledRemarkLabelText = "未選択"

    private let enabledRemarkLabelBackgroundColor  = UIColor.init(code: "#ff9900")
    private let disabledRemarkLabelBackgroundColor = UIColor.init(code: "#dddddd")

    private let enabledTargetTextLabelColor  = UIColor.init(code: "#555555")
    private let disabledTargetTextLabelColor = UIColor.init(code: "#777777")
    
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
            targetRemarkLabel.text            = enabledRemarkLabelText
            targetRemarkLabel.backgroundColor = enabledRemarkLabelBackgroundColor
            targetTextLabel.font      = UIFont(name: AppConstants.BOLD_FONT_NAME, size: 13)!
            targetTextLabel.textColor = enabledTargetTextLabelColor
        } else {
            targetRemarkLabel.text            = disabledRemarkLabelText
            targetRemarkLabel.backgroundColor = disabledRemarkLabelBackgroundColor
            targetTextLabel.font      = UIFont(name: AppConstants.FONT_NAME, size: 13)!
            targetTextLabel.textColor = disabledTargetTextLabelColor
        }
    }

    // MARK: - Private Function

    private func setupSelectFormTableViewCell() {
        self.accessoryType = .none
        self.selectionStyle = .none

        targetRemarkLabel.layer.cornerRadius = 6.0
        targetRemarkLabel.layer.masksToBounds = true
        targetRemarkLabel.backgroundColor = disabledRemarkLabelBackgroundColor
    }
}
