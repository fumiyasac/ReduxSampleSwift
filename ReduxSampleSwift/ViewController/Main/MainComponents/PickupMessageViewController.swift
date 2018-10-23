//
//  PickupMessageViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

// MARK: - Protocol

// MEMO: ContainerViewを介したViewに関する処理はプロトコル経由で接続する
protocol PickupMessageViewDelegate: NSObjectProtocol {

    // ピックアップメッセージのセル選択時にプロトコルを適用したViewController側で行うためのメソッド
    func selectPickupMessage(pickupMessageEntity: PickupMessageEntity, pickupMessageImage: UIImage?)
}

class PickupMessageViewController: UIViewController {

    private var pickupMessageList: [PickupMessageEntity] = [] {
        // 値の変更があった場合に再読み込みを実行する
        didSet {
            self.pickupMessageCollectionView.reloadData()
        }
    }

    // PickupMessageViewDelegateの宣言
    weak var delegate: PickupMessageViewDelegate?

    @IBOutlet weak private var pickupMessageTitleView: MainContentsTitleView!
    @IBOutlet weak private var pickupMessageCollectionView: UICollectionView!
    @IBOutlet weak private var pickupMessageRemarkView: MainContentsRemarkView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickupMessageTitleView()
        setupPickupMessageCollectionView()
        setupPickupMessageRemarkView()

        // ピックアップメッセージをフェッチするアクションを実行する
        PickupMessageActionCreator.fetchPickupMessageList()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // ピックアップメッセージエリアの表示状態を更新するアクションを実行する
        PickupMessageActionCreator.shouldHidePickupMessageArea(result: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func setupPickupMessageTitleView() {
        pickupMessageTitleView.setTitle("今月のPickUp情報:")
        pickupMessageTitleView.setDescriptionIfNeeded()
    }

    private func setupPickupMessageCollectionView() {
        pickupMessageCollectionView.delegate = self
        pickupMessageCollectionView.dataSource = self
        pickupMessageCollectionView.registerCustomCell(PickupMessageCollectionViewCell.self)
    }

    private func setupPickupMessageRemarkView() {
        pickupMessageRemarkView.setRemark("Read Moreを押すと詳細が表示されます。")
    }
}

// MARK: - StoreSubscriber

extension PickupMessageViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // ピックアップメッセージの表示エリア状態を反映する
        pickupMessageCollectionView.isHidden = state.pickupMessageState.isPickupMessageAreaHidden

        // ピックアップメッセージのリストデータをメンバ変数へ格納する
        pickupMessageList = state.pickupMessageState.pickupMessageStateList

        // Debug.
        AppLogger.printStateForDebug(state.pickupMessageState, viewController: self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PickupMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickupMessageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PickupMessageCollectionViewCell.self, indexPath: indexPath)

        let pickupMessage = pickupMessageList[indexPath.row]
        cell.setCell(pickupMessage)

        // セルの内部にある「▶︎ Read Mode」のボタンを押下した際のアクション
        cell.pickupMessageButtonAction = { [weak self] pushedImage in

            // ピックアップメッセージエリアの表示状態を更新するアクションを実行する
            PickupMessageActionCreator.shouldHidePickupMessageArea(result: true)

            // Debug.
            print("押されたセルのインデックス値:", indexPath.row)

            // ピックアップメッセージの情報を取得して、プロトコルを適用しているViewControllerに受け渡す
            self?.delegate?.selectPickupMessage(pickupMessageEntity: pickupMessage, pickupMessageImage: pushedImage)
        }
        return cell
    }

    // MEMO: 他にもこのようなメソッドもあるので随時活用してみてください。
    // https://teratail.com/questions/16067
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PickupMessageViewController: UICollectionViewDelegateFlowLayout {

    // PickupMessageCollectionViewCellのサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return pickupMessageCollectionView.frame.size
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
