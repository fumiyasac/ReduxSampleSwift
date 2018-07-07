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

    private var englishNewsList: [EnglishNewsEntity] = []

    @IBOutlet weak private var englishNewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEnglishNewsTableView()
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

    private func setupEnglishNewsTableView() {
//        englishNewsTableView.delegate = self
//        englishNewsTableView.dataSource = self
//        englishNewsTableView.estimatedRowHeight = EnglishNewsTableViewCell.CELL_HEIGHT
//        englishNewsTableView.delaysContentTouches = false
//        englishNewsTableView.registerCustomCell(EnglishNewsTableViewCell.self)
    }
}

// MARK: - StoreSubscriber

extension EnglishNewsViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        print("---")
        print("EnglishNewsState logging #start: EnglishNewsStateの変更をEnglishNewsViewControllerで受け取りました。")
        print(state.englishNewsState)
        print("EnglishNewsState logging #end:")
        print("---\n")
    }
}

