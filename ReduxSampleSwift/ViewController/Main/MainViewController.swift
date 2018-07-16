//
//  MainViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/12.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class MainViewController: UIViewController {

    @IBOutlet weak private var englishNewListHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

// MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        print("---")
        print("State logging #start: Stateの変更をMainViewControllerで受け取りました。")
        print("MainViewController logging #end:")
        print("---\n")
    }
}

// MARK: - GourmetShopViewDelegate

extension MainViewController: GourmetShopViewDelegate {

    func selectGourmetShop(_ urlString: String) {
        // TODO: WebView(WKWebView)でNYTの記事を表示する
        print("表示するべきURL:", urlString)
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

    // 英語ニュースの取得失敗時にこのViewController側で行う処理
    func fetchEnglishNewsListFailure() {

        // TODO: エラー発生時のポップアップを表示する
        print("EnglishNewsの表示時にエラーが発生しました。")
    }

    func selectEnglishNews(_ urlString: String) {

        // TODO: WebView(WKWebView)でNYTの記事を表示する
        print("表示するべきURL:", urlString)
    }
}
