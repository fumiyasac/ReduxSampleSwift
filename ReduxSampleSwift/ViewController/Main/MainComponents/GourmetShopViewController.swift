//
//  GourmetShopViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

// MARK: - Protocol

// MEMO: ContainerViewを介したViewに関する処理はプロトコル経由で接続する
protocol GourmetShopViewDelegate: NSObjectProtocol {

    // 飲食店情報のセル選択時にプロトコルを適用したViewController側で行うためのメソッド
    func selectGourmetShop(_ urlString: String)
}

class GourmetShopViewController: UIViewController {

    private var gourmetShopList: [GourmetShopEntity] = [] {
        // 値の変更があった場合に再読み込みを実行する
        didSet {
            self.gourmetShopCollectionView.reloadData()
        }
    }

    // GourmetShopViewDelegateの宣言
    weak var delegate: GourmetShopViewDelegate?

    @IBOutlet weak private var gourmetShopTitleView: MainContentsTitleView!
    @IBOutlet weak private var gourmetShopCollectionView: UICollectionView!
    @IBOutlet weak private var gourmetShopFetchButtonView: MainContentsFetchButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGourmetShopTitleView()
        setupGourmetShopCollectionView()
        setupGourmetShopFetchButtonView()

        // 飲食店情報をフェッチするアクションを実行する
        GourmetShopActionCreator.fetchGourmetShopList()
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

    private func setupGourmetShopTitleView() {
        gourmetShopTitleView.setTitle("飲食店チョイス:")
        gourmetShopTitleView.setDescriptionIfNeeded()
    }

    private func setupGourmetShopCollectionView() {
        gourmetShopCollectionView.delegate = self
        gourmetShopCollectionView.dataSource = self
        gourmetShopCollectionView.registerCustomCell(GourmetShopCollectionViewCell.self)
        shouldHideGourmetShopCollectionView(result: true)
    }

    private func setupGourmetShopFetchButtonView() {
        gourmetShopFetchButtonView.setButtonTitle("表示を変更する")
        gourmetShopFetchButtonView.fetchButtonAction = {

            // 飲食店情報をフェッチするアクションを実行する
            GourmetShopActionCreator.fetchGourmetShopList()
        }
    }

    private func shouldHideGourmetShopCollectionView(result: Bool) {
        gourmetShopCollectionView.isHidden = result
    }
}

// MARK: - StoreSubscriber

extension GourmetShopViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // 飲食店情報のリストデータをメンバ変数へ格納する
        gourmetShopList = state.gourmetShopState.gourmetShopList

        // 飲食店情報の読み込み状態をボタンへ反映させる
        gourmetShopFetchButtonView.setLoadingState(state.gourmetShopState.isLoadingGourmetShop)

        // 飲食店情報の取得に失敗した場合はその状態表示をこのView内で実行する
        let isErrorGourmetShop = state.gourmetShopState.isErrorGourmetShop
        shouldHideGourmetShopCollectionView(result: isErrorGourmetShop)

        // Debug.
        print("---")
        print("GourmetShopState logging #start: GourmetShopStateの変更をGourmetShopViewControllerで受け取りました。")
        print(state.gourmetShopState)
        print("GourmetShopState logging #end:")
        print("---\n")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GourmetShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gourmetShopList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: GourmetShopCollectionViewCell.self, indexPath: indexPath)
        let gourmetShop = gourmetShopList[indexPath.row]
        cell.setCell(gourmetShop)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gourmetShop = gourmetShopList[indexPath.row]

        // 飲食店情報のURLを取得して、ContainerViewを配置しているViewControllerからWebViewで表示する
        self.delegate?.selectGourmetShop(gourmetShop.gourmetShopUrl)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GourmetShopViewController: UICollectionViewDelegateFlowLayout {
    
    // GourmetShopCollectionViewCellのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return GourmetShopCollectionViewCell.CELL_SIZE
    }
    
    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}

