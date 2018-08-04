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

    private var selectedYear: Int!
    private var selectedMonth: Int!

    private var calendarButtonList: [CalendarButtonView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMonthlyCalendarTitleView()
        setupMonthlyCalendarScrollView()
        setupMonthlyCalendarRemarkView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Stateが更新された際に通知を検知できるようにappStoreにリスナーを登録する
        appStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stateが更新された際に通知を検知できるようにappStoreに登録したリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func prevCalendarButtonTapped() {
        setPrevMonth()
    }

    @objc private func nextCalendarButtonTapped() {
        setNextMonth()
    }

    @objc private func calendarButtonTapped(button: UIButton) {
        //performSegue(withIdentifier: "goDailyMemo", sender: self)
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
        monthlyCalendarTitleView.setTitle("月別カレンダーMEMO:")
        monthlyCalendarTitleView.setDescriptionIfNeeded("")

        // 現在の日時から年と月を算出する
        let dateComponents = calendar.dateComponents([.year, .month], from: Date())
        let targetYear: Int  = Int(dateComponents.year!)
        let targetMonth: Int = Int(dateComponents.month!)

        // 現在の日時から年と月をセットするアクションを実行する
        MonthlyCalendarActionCreator.setCurrentYearAndMonth(targetYear: targetYear, targetMonth: targetMonth)
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

        // 現在選択中の年と月を書き換える
        var targetYear: Int
        var targetMonth: Int
        if selectedMonth == 1 {
            targetYear  = selectedYear - 1
            targetMonth = 12
        } else {
            targetYear  = selectedYear
            targetMonth = selectedMonth - 1
        }

        // 前の年と月をセットするアクションを実行する
        MonthlyCalendarActionCreator.setPrevYearAndMonth(targetYear: targetYear, targetMonth: targetMonth)
    }

    private func setNextMonth() {

        // 現在選択中の年と月を書き換える
        var targetYear: Int
        var targetMonth: Int
        if selectedMonth == 12 {
            targetYear  = selectedYear + 1
            targetMonth = 1
        } else {
            targetYear  = selectedYear
            targetMonth = selectedMonth + 1
        }

        // 次の年と月をセットするアクションを実行する
        MonthlyCalendarActionCreator.setNextYearAndMonth(targetYear: targetYear, targetMonth: targetMonth)
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

extension MonthlyCalendarViewController: StoreSubscriber {
    
    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // メンバ変数の更新を行う
        selectedYear  = state.monthlyCalendarState.selectedYear
        selectedMonth = state.monthlyCalendarState.selectedMonth
        
        // 現在選択中の年と月に対応したカレンダーを配置する
        setMonthlyCalendar()

        // UIScrollViewの位置補正を行う
        if state.monthlyCalendarState.isPrev {
            movePrevMonthCalendarPosition()
        } else {
            moveNextMonthCalendarPosition()
        }

        // 現在選択中の年と月の表示をセットする
        monthlyCalendarTitleView.setDescriptionIfNeeded("\(selectedYear!)年\(selectedMonth!)月分")
        
        // Debug.
        AppLogger.printStateForDebug(state.monthlyCalendarState, viewController: self)
    }
}

