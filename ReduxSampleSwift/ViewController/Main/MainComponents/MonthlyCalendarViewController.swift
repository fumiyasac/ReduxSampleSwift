//
//  MonthlyCalendarViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

/* TODO: 入力画面の作成時にReSwiftへ乗せる */
class MonthlyCalendarViewController: UIViewController {

    @IBOutlet weak private var monthlyCalendarTitleView: MainContentsTitleView!
    @IBOutlet weak private var monthlyCalendarScrollView: UIScrollView!
    @IBOutlet weak private var monthlyCalendarRemarkView: MainContentsRemarkView!

    private let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    private let scrollViewMoveDuration: TimeInterval = 0.16
    private let monthLimit: Int = 12

    private var selectedYear: Int!
    private var selectedMonth: Int!

    private var calendarButtonList: [CalendarButtonView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMonthlyCalendarTitleView()
        setupMonthlyCalendarScrollView()
        setupMonthlyCalendarRemarkView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMonthlyCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func prevCalendarButtonTapped() {
        setPrevMonth()
        setMonthlyCalendar()
        movePrevMonthCalendarPosition()
    }

    @objc private func nextCalendarButtonTapped() {
        setNextMonth()
        setMonthlyCalendar()
        moveNextMonthCalendarPosition()
    }

    @objc private func calendarButtonTapped(button: UIButton) {
        print("選択された日付:", "\(selectedYear!)年\(selectedMonth!)月\(button.tag)日")
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
        let dateComponents = calendar.dateComponents([.year, .month], from: Date())
        selectedYear  = Int(dateComponents.year!)
        selectedMonth = Int(dateComponents.month!)
        monthlyCalendarTitleView.setTitle("月別カレンダーMEMO:")
        monthlyCalendarTitleView.setDescriptionIfNeeded("\(selectedYear!)年\(selectedMonth!)月分")
    }

    private func setupMonthlyCalendarRemarkView() {
        monthlyCalendarRemarkView.setRemark("日付を押すとその日のメモを記載できます。")
    }

    private func setMonthlyCalendar() {

        // ボタンを配置する前に配置されているボタンの全要素を削除する
        removeMonthlyCalendar()

        // 該当月のボタン一覧を取得する
        calendarButtonList = CalendarButtonModule.getTargetCalendarButtonList(targetYear: selectedYear, targetMonth: selectedMonth)

        // スクロールビュー内のサイズを決定する（AutoLayoutで配置を行った場合でもこの部分はコードで設定しないといけない）
        let allScrollViewElementCount = CGFloat(calendarButtonList.count)
        let contentWidth  = CalendarButtonView.CALENDAR_BUTTON_VIEW_WIDTH * allScrollViewElementCount
        let contentHeight = monthlyCalendarScrollView.frame.height
        monthlyCalendarScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        for index in 0..<calendarButtonList.count {
        
            // メニュー用のスクロールビューにボタンを配置
            monthlyCalendarScrollView.addSubview(calendarButtonList[index])

            // サイズと位置の決定
            let buttonRect = CalendarButtonView.CALENDAR_BUTTON_VIEW_WIDTH
            let buttonPosX = buttonRect * CGFloat(index)
            calendarButtonList[index].frame = CGRect(x: buttonPosX, y: 0, width: buttonRect, height: buttonRect)

            // Enum(MonthlyCalendarButtonType)による分類を元にした押下時のターゲットの指定
            let type: MonthlyCalendarButtonType = calendarButtonList[index].monthlyCalendarButtonType
            switch type {
            case .prevButton:
                calendarButtonList[index].calendarButton.addTarget(self, action: #selector(self.prevCalendarButtonTapped), for: .touchUpInside)
            case .nextButton:
                calendarButtonList[index].calendarButton.addTarget(self, action: #selector(self.nextCalendarButtonTapped), for: .touchUpInside)
            default:
                calendarButtonList[index].calendarButton.addTarget(self, action: #selector(self.calendarButtonTapped(button:)), for: .touchUpInside)
            }
        }
    }

    private func removeMonthlyCalendar() {
        for index in 0..<calendarButtonList.count {
            calendarButtonList[index].removeFromSuperview()
        }
        calendarButtonList.removeAll()
    }

    private func setPrevMonth() {
        if selectedMonth == 1 {
            selectedYear = selectedYear - 1
            selectedMonth = monthLimit
        } else {
            selectedMonth = selectedMonth - 1
        }
        monthlyCalendarTitleView.setDescriptionIfNeeded("\(selectedYear!)年\(selectedMonth!)月分")
    }

    private func setNextMonth() {
        if selectedMonth == monthLimit {
            selectedYear = selectedYear + 1
            selectedMonth = 1
        } else {
            selectedMonth = selectedMonth + 1
        }
        monthlyCalendarTitleView.setDescriptionIfNeeded("\(selectedYear!)年\(selectedMonth!)月分")
    }

    private func movePrevMonthCalendarPosition() {
        UIView.animate(withDuration: scrollViewMoveDuration, animations: {
            self.monthlyCalendarScrollView.contentOffset.x = self.monthlyCalendarScrollView.contentSize.width - self.view.frame.width
        })
    }

    private func moveNextMonthCalendarPosition() {
        UIView.animate(withDuration: scrollViewMoveDuration, animations: {
            self.monthlyCalendarScrollView.contentOffset.x = 0
        })
    }
}
