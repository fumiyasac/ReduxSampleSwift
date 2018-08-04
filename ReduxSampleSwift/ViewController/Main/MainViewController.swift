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

    @IBOutlet weak private var mainScrollView: UIScrollView!
    @IBOutlet weak private var englishNewListHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("気になるコンテンツ一覧")
        setupMainScrollView()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // ContainerViewで接続されたViewController側に定義したプロトコルを適用するためにSegueからViewControllerのインスタンスを作成する
        if segue.identifier == "EnglishNewsContainer" {
            let englishNewsViewController = segue.destination as! EnglishNewsViewController
            englishNewsViewController.delegate = self
        }

        if segue.identifier == "GourmetShopContainer" {
            let gourmetShopViewController = segue.destination as! GourmetShopViewController
            gourmetShopViewController.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupMainScrollView() {

        // RefreshControlに関する設定
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font] = UIFont(name: AppConstants.FONT_NAME, size: 8.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor(code: "#888888")

        refreshControl.tintColor = UIColor(code: "#CCCCCC")
        refreshControl.attributedTitle = NSAttributedString(string: "データをリフレッシュします...", attributes: attributes)

        // ScrollViewに関する設定
        mainScrollView.delegate = self
        mainScrollView.alwaysBounceVertical = true
        mainScrollView.delaysContentTouches = false
        mainScrollView.refreshControl = refreshControl
    }
}

// MARK: - StoreSubscriber

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // UIRefreshControl表示時は以降の処理を行わない
        guard !refreshControl.isRefreshing else {
            return
        }

        let refreshContentOffsetLimit: CGFloat = -120
        let delayedTime: TimeInterval = 0.48

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
                    PickupMessageActionCreator.fetchGourmetShopList()

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
