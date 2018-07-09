//
//  MonthlyCalendarViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class MonthlyCalendarViewController: UIViewController {

    @IBOutlet weak private var monthlyCalendarTitleView: MainContentsTitleView!
    @IBOutlet weak private var monthlyCalendarScrollView: UIScrollView!

    private var calendarButtonList: [CalendarButtonView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMonthlyCalendarTitleView()
        setupMonthlyCalendarScrollView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarButtonList.isEmpty == false {
            removeMonthlyCalendar()
        }
        displayMonthlyCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func calendarButtonTapped(button: UIButton) {
        print("選択された日付:", button.tag)
    }

    private func setupMonthlyCalendarScrollView() {
        monthlyCalendarScrollView.isPagingEnabled = false
        monthlyCalendarScrollView.isScrollEnabled = true
        monthlyCalendarScrollView.isDirectionalLockEnabled = false
        monthlyCalendarScrollView.showsHorizontalScrollIndicator = false
        monthlyCalendarScrollView.showsVerticalScrollIndicator = false
        monthlyCalendarScrollView.bounces = true
        monthlyCalendarScrollView.scrollsToTop = false
    }

    private func setupMonthlyCalendarTitleView() {
        let year  = CalendarButtonModule.currentYear
        let month = CalendarButtonModule.currentMonth

        monthlyCalendarTitleView.setTitle("月別カレンダーMEMO:")
        monthlyCalendarTitleView.setDescriptionIfNeeded("\(year)年\(month)月分")
    }

    private func displayMonthlyCalendar() {

        // 該当月のボタン一覧を取得する
        calendarButtonList = CalendarButtonModule.getCurrentCalendarButtonList()

        // スクロールビュー内のサイズを決定する（AutoLayoutで配置を行った場合でもこの部分はコードで設定しないといけない）
        let contentWidth  = CalendarButtonView.CALENDAR_BUTTON_VIEW_WIDTH * CGFloat(calendarButtonList.count)
        let contentHeight = monthlyCalendarScrollView.frame.height
        monthlyCalendarScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        for index in 0..<calendarButtonList.count {
        
            // メニュー用のスクロールビューにボタンを配置
            monthlyCalendarScrollView.addSubview(calendarButtonList[index])

            // サイズと位置の決定
            let buttonRect = CalendarButtonView.CALENDAR_BUTTON_VIEW_WIDTH
            let buttonPosX = buttonRect * CGFloat(index)
            calendarButtonList[index].frame = CGRect(x: buttonPosX, y: 0, width: buttonRect, height: buttonRect)
            calendarButtonList[index].calendarButton.addTarget(self, action: #selector(self.calendarButtonTapped(button:)), for: .touchUpInside)
        }
    }

    private func removeMonthlyCalendar() {
        for index in 0..<calendarButtonList.count {
            calendarButtonList[index].removeFromSuperview()
        }
        calendarButtonList.removeAll()
    }
}
