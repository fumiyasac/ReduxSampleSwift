//
//  PickupMessageViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class PickupMessageViewController: UIViewController {
    
    @IBOutlet weak var pickupMessageCollectionView: UICollectionView!

    fileprivate let pickupMessageCount = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickupMessageCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // UICollectionViewに関する設定を行う
    private func setupPickupMessageCollectionView() {
        pickupMessageCollectionView.delegate = self
        pickupMessageCollectionView.dataSource = self
        pickupMessageCollectionView.registerCustomCell(PickupMessageCollectionViewCell.self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PickupMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickupMessageCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: PickupMessageCollectionViewCell.self, indexPath: indexPath)

        // セルの内部にある「▶︎ Read Mode」のボタンを押下した際のアクション
        cell.showPickupMessageAction = {
            print("押されたセルのインデックス値:", indexPath.row)
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
