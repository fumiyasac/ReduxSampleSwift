//
//  GourmetShopViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class GourmetShopViewController: UIViewController {

    @IBOutlet weak var gourmetShopCollectionView: UICollectionView!
    @IBOutlet weak var shuffleShopButton: UIButton!

    fileprivate let gourmetShopCount = 6

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGourmetShopCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // UICollectionViewに関する設定を行う
    private func setupGourmetShopCollectionView() {
        gourmetShopCollectionView.delegate = self
        gourmetShopCollectionView.dataSource = self
        gourmetShopCollectionView.registerCustomCell(GourmetShopCollectionViewCell.self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GourmetShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gourmetShopCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: GourmetShopCollectionViewCell.self, indexPath: indexPath)

        return cell
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

