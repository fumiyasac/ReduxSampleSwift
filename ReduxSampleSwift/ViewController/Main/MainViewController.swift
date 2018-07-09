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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // 英語ニュース表示エリアのコンテンツ高さの調節を行う ← FIXME: ここはProtocolで処理委譲するべき
        setEnglishNewContainerViewHeight(newsListCount: state.englishNewsState.englishNewsList.count)

        // Debug.
        print("---")
        print("State logging #start: Stateの変更をMainViewControllerで受け取りました。")
        print(state.englishNewsState)
        print("MainViewController logging #end:")
        print("---\n")
    }

    // MARK: - Private Function

    private func setEnglishNewContainerViewHeight(newsListCount: Int) {
        let englishNewListContentHeight = CGFloat(newsListCount) * EnglishNewsTableViewCell.CELL_HEIGHT
        englishNewListHeight.constant = englishNewListContentHeight + MainContentsTitleView.VIEW_HEIGHT + MainContentsFetchButtonView.VIEW_HEIGHT
    }
}
