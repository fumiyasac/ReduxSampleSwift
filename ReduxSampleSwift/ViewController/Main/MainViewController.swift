//
//  MainViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/12.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift
import SafariServices
import PromiseKit

class MainViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    private let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)

    private let dailyMemoTransition     = DailyMemoTransition()
    private let pickupMessageTransition = PickupMessageTransition()

    private var selectedFrame: CGRect?
    private var pickupMessageInteractor: PickupMessageInteractor?
    private var selectedImage: UIImage?

    @IBOutlet weak private var mainScrollView: UIScrollView!
    @IBOutlet weak private var englishNewListHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("気になるコンテンツ一覧")
        removeBackButtonText()
        setupNavigationController()
        setupMainScrollView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Stateが更新された際に通知を検知できるようにするリスナーを登録する
        appStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stateが更新された際に通知を検知できるようにするリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {

        // ContainerViewで接続されたViewController側に定義したプロトコルを適用する
        case "connectMonthlyCalendarContainer":
            let monthlyCalendarViewController = segue.destination as! MonthlyCalendarViewController
            monthlyCalendarViewController.delegate = self

        case "connectPickupMessageContainer":
            let pickupMessageViewController = segue.destination as! PickupMessageViewController
            pickupMessageViewController.delegate = self
            
        case "connectGourmetShopContainer":
            let gourmetShopViewController = segue.destination as! GourmetShopViewController
            gourmetShopViewController.delegate = self

        case "connectEnglishNewsContainer":
            let englishNewsViewController = segue.destination as! EnglishNewsViewController
            englishNewsViewController.delegate = self

        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupNavigationController() {
        self.navigationController?.delegate = self

        // MEMO: NavigationBarの下に灰色のUIViewを敷いておく
        let statusBarHeight      = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight  = self.navigationController?.navigationBar.frame.height ?? 0
        let headerBackgroundView = UIView(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(statusBarHeight + navigationBarHeight))
        )
        headerBackgroundView.backgroundColor = UIColor.init(code: "#F9F9F9")
        headerBackgroundView.layer.borderWidth = 0.5
        headerBackgroundView.layer.borderColor = UIColor.init(code: "#CCCCCC").cgColor
        self.view.addSubview(headerBackgroundView)
    }

    private func setupMainScrollView() {

        // RefreshControlに関する設定
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont(name: AppConstants.FONT_NAME, size: 8.0)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor(code: "#888888")

        refreshControl.tintColor = UIColor(code: "#CCCCCC")
        refreshControl.attributedTitle = NSAttributedString(string: "データをリフレッシュします...", attributes: attributes)

        // ScrollViewに関する設定
        mainScrollView.delegate = self
        mainScrollView.alwaysBounceVertical = true
        mainScrollView.delaysContentTouches = false
        mainScrollView.refreshControl = refreshControl
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {

    // スクロールが実行されオフセットが変わった際に呼ばれる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // UIRefreshControl表示時は以降の処理を行わない
        guard !refreshControl.isRefreshing else {
            return
        }

        let refreshContentOffsetLimit: CGFloat = -120
        let delayedTime: TimeInterval = 0.48

        // UIScrollViewのオフセット値が設定値を超えたら表示内容をリフレッシュする
        if scrollView.contentOffset.y < refreshContentOffsetLimit {

            // コンテンツ全体の表示をリフレッシュする
            let _ = promiseForRefreshAllMainContents(delayedTime)

                // 最初の処理実行(0.00秒いわゆるいの一番に実行される処理)
                .done {

                    // RefreshControlを開始する
                    self.refreshControl.beginRefreshing()

                    // 英語ニュース情報をフェッチするアクションを実行する
                    EnglishNewsActionCreator.fetchEnglishNewsList(refresh: true)

                    // 飲食店情報をフェッチするアクションを実行する
                    GourmetShopActionCreator.fetchGourmetShopList()

                    // ピックアップメッセージをフェッチするアクションを実行する
                    PickupMessageActionCreator.fetchPickupMessageList()

                    // 現在の日時から年と月を算出し、年と月をセットするアクションを実行する
                    let dateComponents = self.calendar.dateComponents([.year, .month], from: Date())
                    let currentYear  = Int(dateComponents.year!)
                    let currentMonth = Int(dateComponents.month!)
                    MonthlyCalendarActionCreator.setCurrentYearAndMonth(targetYear: currentYear, targetMonth: currentMonth)
                }

                // 次の処理実行(0.48秒後に実行される処理)
                .done {

                    // RefreshControlを終了する
                    self.refreshControl.endRefreshing()

                    // UIScrollViewのy軸方向の位置を元に戻す
                    let durationTime: TimeInterval = 0.24
                    UIView.animate(withDuration: durationTime, animations: {
                        scrollView.contentOffset.y = 0
                    })
                }
        }
    }

    // MARK: - Private Function

    private func promiseForRefreshAllMainContents(_ delayedTime: TimeInterval) -> Promise<Void> {

        // 参考: SwiftでPromiseパターンを実現するPromiseKitを使ってみる (Swift4 & PromiseKit6対応)
        // http://www.cl9.info/entry/2015/10/03/144845
        return Promise { seal in

            seal.fulfill(())

            // 最初の処理実行から指定秒後に次の処理を実行する
            DispatchQueue.main.asyncAfter(deadline: .now() + delayedTime) {
                seal.fulfill(())
            }
        }
    }
}

// MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        AppLogger.printStateForDebug(state, viewController: self)

        // 画面全体の更新を行う
        self.view.setNeedsDisplay()
    }
}

// MARK: - MonthlyCalendarViewDelegate

extension MainViewController: MonthlyCalendarViewDelegate {

    // 選択されたカレンダーの内容を反映させつつ、画面遷移を行う
    func selectMonthlyCalendar(selectedDate: (selectedYear: Int, selectedMonth: Int, selectedDay: Int)) {

        // 記事表示用の画面へ遷移する
        let storyboard = UIStoryboard(name: "DailyMemo", bundle: nil)
        let dailyMemoViewController = storyboard.instantiateViewController(withIdentifier: "DailyMemoViewController") as! DailyMemoViewController
        dailyMemoViewController.setSelectedDate(selectedDate)

        // カスタムトランジションのプロトコルを適用させて遷移する
        let navigationController = UINavigationController(rootViewController: dailyMemoViewController)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - PickupMessageViewDelegate

extension MainViewController: PickupMessageViewDelegate {

    func selectPickupMessage(pickupMessageEntity: PickupMessageEntity, pickupMessageImage: UIImage?) {

        // カスタムトランジションに引き渡すUIImageをメンバ変数へ格納する
        selectedImage = pickupMessageImage

        // カスタムトランジションに引き渡す遷移元画像の位置をメンバ変数へ格納する
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        selectedFrame = CGRect(
            x: 0.0,
            y: 175.0 + navigationBarHeight + statusBarHeight - mainScrollView.contentOffset.y,
            width: self.view.frame.width,
            height: 190.0
        )

        // カスタムトランジションのプロトコルを適用させて遷移する
        let storyboard = UIStoryboard(name: "MessageDetail", bundle: nil)
        let messageDetailViewController = storyboard.instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        
        messageDetailViewController.setPickupMessageEntity(pickupMessageEntity)
        self.navigationController?.pushViewController(messageDetailViewController, animated: true)
    }
}


// MARK: - GourmetShopViewDelegate

extension MainViewController: GourmetShopViewDelegate {
    
    // 見たい飲食店の選択時にこのViewController側で行う処理
    func selectGourmetShop(_ urlString: String) {
        if let gourmetShopUrl = URL(string: urlString) {
            let vc = SFSafariViewController(url: gourmetShopUrl)
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - EnglishNewsViewDelegate

extension MainViewController: EnglishNewsViewDelegate {

    // 英語ニュースの取得成功時にこのViewController側で行う処理
    func fetchEnglishNewsListSuccess(_ newsCount: Int) {

        // 英語ニュースを表示しているContainerViewの高さを調節する
        let englishNewListContentHeight = CGFloat(newsCount) * EnglishNewsTableViewCell.CELL_HEIGHT
        englishNewListHeight.constant = englishNewListContentHeight + MainContentsTitleView.VIEW_HEIGHT + MainContentsFetchButtonView.VIEW_HEIGHT
    }

    // 英語ニュースの選択時にこのViewController側で行う処理
    func selectEnglishNews(_ urlString: String) {
        if let englishNewsUrl = URL(string: urlString) {
            let vc = SFSafariViewController(url: englishNewsUrl)
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainViewController: UIViewControllerTransitioningDelegate {

    /**
     * カスタムトランジションは下記のサンプルをSwift3に置き換えて再実装
     * (実装の詳細はCustomTransition.swiftを参考)
     *
     * 参考：iOS Animation Tutorial: Custom View Controller Presentation Transitions
     * https://www.raywenderlich.com/113845/ios-animation-tutorial-custom-view-controller-presentation-transitions
     */

    // 進む場合のアニメーションの設定を行う
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 現在の画面サイズを引き渡して画面が縮むトランジションにする
        dailyMemoTransition.originalFrame = self.view.frame
        dailyMemoTransition.presenting = true
        return dailyMemoTransition
    }

    // 戻る場合のアニメーションの設定を行う
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // 縮んだ状態から画面が戻るトランジションにする
        dailyMemoTransition.presenting = false
        return dailyMemoTransition
    }
}

// MARK: - UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let targetInteractor = pickupMessageInteractor else { return nil }
        return targetInteractor.transitionInProgress ? pickupMessageInteractor : nil
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        // カスタムトランジションのクラスに定義したプロパティへFrame情報とUIImage情報を渡す
        guard let frame = selectedFrame else { return nil }
        guard let image = selectedImage else { return nil }

        pickupMessageTransition.originFrame = frame
        pickupMessageTransition.originImage = image

        switch operation {
        case .push:
            self.pickupMessageInteractor = PickupMessageInteractor(attachTo: toVC)
            pickupMessageTransition.presenting  = true
            return pickupMessageTransition
        default:
            pickupMessageTransition.presenting  = false
            return pickupMessageTransition
        }
    }
}

