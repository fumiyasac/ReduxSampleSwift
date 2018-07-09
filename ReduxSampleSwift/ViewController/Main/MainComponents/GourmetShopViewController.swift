//
//  GourmetShopViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class GourmetShopViewController: UIViewController {

    private let gourmetShopCount = 6

    @IBOutlet weak private var gourmetShopTitleView: MainContentsTitleView!
    @IBOutlet weak private var gourmetShopCollectionView: UICollectionView!
    @IBOutlet weak private var gourmetShopFetchButtonView: MainContentsFetchButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGourmetShopTitleView()
        setupGourmetShopCollectionView()
        setupGourmetShopFetchButtonView()
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
    }

    private func setupGourmetShopFetchButtonView() {
        gourmetShopFetchButtonView.setButtonTitle("表示を変更する")
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
        cell.setCell()

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

