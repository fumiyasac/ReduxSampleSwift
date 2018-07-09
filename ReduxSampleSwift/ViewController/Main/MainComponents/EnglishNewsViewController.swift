//
//  EnglishNewsViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class EnglishNewsViewController: UIViewController {

    private var englishNewsList: [EnglishNewsEntity] = [] {
        // 値の変更があった場合に再読み込みを実行する
        didSet {
            self.englishNewsTableView.reloadData()
        }
    }

    @IBOutlet weak private var englishNewsTitleView: MainContentsTitleView!
    @IBOutlet weak private var englishNewsTableView: UITableView!
    @IBOutlet weak private var englishNewsFetchButtonView: MainContentsFetchButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEnglishNewsTitleView()
        setupEnglishNewsTableView()
        setupEnglishNewsFetchButtonView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Stateが更新された際に通知を検知できるようにappStoreにリスナーを登録する
        appStore.subscribe(self)

        // 英語ニュース情報をフェッチするアクションを実行する
        EnglishNewsActionCreator.fetchEnglishNewsList()
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

    private func setupEnglishNewsTitleView() {
        englishNewsTitleView.setTitle("最新英語ニュース(NYT):")
        englishNewsTitleView.setDescriptionIfNeeded()
    }

    private func setupEnglishNewsTableView() {
        englishNewsTableView.delegate = self
        englishNewsTableView.dataSource = self
        englishNewsTableView.estimatedRowHeight = EnglishNewsTableViewCell.CELL_HEIGHT
        englishNewsTableView.delaysContentTouches = false
        englishNewsTableView.registerCustomCell(EnglishNewsTableViewCell.self)
    }

    private func setupEnglishNewsFetchButtonView() {
        englishNewsFetchButtonView.setButtonTitle("次の10件を表示する")
    }
}

// MARK: - StoreSubscriber

extension EnglishNewsViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // 取得した英語ニュースのリストデータをメンバ変数へ格納する
        englishNewsList = state.englishNewsState.englishNewsList

        // 取得した英語ニュースの読み込み状態をボタンへ反映させる
        englishNewsFetchButtonView.setLoadingState(state.englishNewsState.isLoadingEnglishNews)

        // Debug.
        print("---")
        print("EnglishNewsState logging #start: EnglishNewsStateの変更をEnglishNewsViewControllerで受け取りました。")
        print(state.englishNewsState)
        print("EnglishNewsState logging #end:")
        print("---\n")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension EnglishNewsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return englishNewsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: EnglishNewsTableViewCell.self)
        let englishNews = englishNewsList[indexPath.row]
        cell.setCell(englishNews)
        return cell
    }
}
