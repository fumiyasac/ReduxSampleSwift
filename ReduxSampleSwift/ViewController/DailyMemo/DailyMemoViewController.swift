//
//  DailyMemoViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

// あとでするTODO: この部分をReduxに当てはめて管理する処理はいずれ作成する

class DailyMemoViewController: UIViewController {

    private var targetDate: (selectedYear: Int, selectedMonth: Int, selectedDay: Int)!
    private var titleDateText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle(titleDateText)
        setupCloseButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 謝罪アラートを表示する
        let alert = UIAlertController(
            title: "こちらの画面は仮画面です。",
            message: "この画面は特にロジックの実装は行っておりませんが、UserSettingViewControllerに記載している形と似たような感じで実装することができます。\n内容の関係で今回は割愛しましたm(_ _)m\n後ほど必ず作成する見込みでいます。。。",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Function

    func setSelectedDate(_ dateValueSet: (selectedYear: Int, selectedMonth: Int, selectedDay: Int)) {
        targetDate    = dateValueSet
        titleDateText = String(dateValueSet.selectedYear)  + "年"
                      + String(dateValueSet.selectedMonth) + "月"
                      + String(dateValueSet.selectedDay)   + "日のメモ"
    }

    // MARK: - Private Function

    @objc private func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(title: "× 閉じる", style: .plain, target: self, action: #selector(self.closeButtonTapped(_:)))
        closeButton.tintColor = UIColor.init(code: "#999999")
        self.navigationItem.leftBarButtonItem = closeButton
    }

}
