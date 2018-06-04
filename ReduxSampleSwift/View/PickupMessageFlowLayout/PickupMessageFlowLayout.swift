//
//  PickupMessageFlowLayout.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/06/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// Inspired by this repo
// https://github.com/wusuowei/WTCarouselFlowLayout/blob/master/WTCarouselFlowLayout
// 参考: UICollectionViewのレイアウトクラスをカスタマイズする方法
// https://dev.classmethod.jp/smartphone/iphone/collection-view-layout-cell-snap/
class PickupMessageFlowLayout: UICollectionViewFlowLayout {

    // 見た目の調整を行うためのプロパティ
    private let notCurrentCellScale: CGFloat = 0.8
    private let notCurrentCellAlpha: CGFloat = 0.56
    private let cellSpace: CGFloat  = 0
    private let cellOffset: CGFloat = 0

    // MARK: - Override Functions

    // レイアウトの事前計算を行う前に実行する
    override func prepare() {
        super.prepare()

        setupTargetCollectionView()
    }

    // スクロールに応じてレイアウトの再計算が必要かを判定する
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // 範囲内に含まれるすべてのセルのレイアウト属性を返す
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        // 親クラスのレイアウト属性が取得できない場合はnilを返す
        guard let superAttributes = super.layoutAttributesForElements(in: rect), let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }

        // MEMO: レイアウト属性に対して現在選択されている以外のセルに対して拡大・縮小を加える
        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    // スクロール後の停止位置を決定する
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        // UICollectionViewが存在しない/ページングが有効でない/設定したレイアウト属性が取得できない場合は親クラスをそのまま返す
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        // 設定されているスクロールの方向を調べる
        let isHorizontal = (self.scrollDirection == .horizontal)

        // スクロール方向の設定を元に停止位置の中心点等の必要な位置を算出する
        var sidePosition: CGFloat
        var proposedContentOffsetCenterOrigin: CGFloat
        var closestAttribute: UICollectionViewLayoutAttributes
        var targetContentOffset: CGPoint

        if isHorizontal {

            // 1. 水平方向のスクロール時の該当UICollectionViewLayoutAttributesの位置調整を行う
            sidePosition = collectionView.bounds.size.width / 2
            proposedContentOffsetCenterOrigin = proposedContentOffset.x + sidePosition

            closestAttribute = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closestAttribute.center.x - sidePosition), y: proposedContentOffset.y)

        } else {

            // 2. 垂直方向のスクロール時の該当UICollectionViewLayoutAttributesの位置調整を行う
            sidePosition = collectionView.bounds.size.height / 2
            proposedContentOffsetCenterOrigin = proposedContentOffset.y + sidePosition

            closestAttribute = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closestAttribute.center.y - sidePosition))
        }
        return targetContentOffset
    }

    // MARK: - Private Functions

    private func setupTargetCollectionView() {

        // UICollectionViewが存在しない場合はそのままreturnする
        guard let collectionView = self.collectionView else { return }

        // スクロール時の減速スピードに関する設定をする
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast

        // 算出に必要なものの準備する（方向とCollectionView自体のサイズ）
        let isHorizontal = (scrollDirection == .horizontal)
        let collectionSize = collectionView.bounds.size

        // セクションの間隔値を設定する
        let yInset = (collectionSize.height - itemSize.height) / 2 * 0
        let xInset = (collectionSize.width - itemSize.width) / 2
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)

        // セルの行が変わる時の行間の余白値を設定する
        var scrollDirectionItemWidth: CGFloat
        if isHorizontal {
            scrollDirectionItemWidth = itemSize.width
        } else {
            scrollDirectionItemWidth = itemSize.height
        }
        let scaledItemOffset = (scrollDirectionItemWidth - scrollDirectionItemWidth * notCurrentCellScale) / 2
        self.minimumLineSpacing = cellSpace - scaledItemOffset
    }

    // 対象のUICollectionViewLayoutAttributesを変形させる
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        // UICollectionViewが存在しない場合は親クラスをそのまま返す
        guard let collectionView = self.collectionView else { return attributes }

        // 設定されているスクロールの方向を調べる
        let isHorizontal = (self.scrollDirection == .horizontal)

        //
        var collectionCenter: CGFloat
        var movableContentOffset: CGFloat
        var normalizedCenter: CGFloat
        var maxDistance: CGFloat
        
        if isHorizontal {
            collectionCenter = collectionView.frame.size.width / 2
            movableContentOffset = collectionView.contentOffset.x
            normalizedCenter = attributes.center.x - movableContentOffset
            maxDistance = self.itemSize.width + self.minimumLineSpacing
        } else {
            collectionCenter = collectionView.frame.size.height / 2
            movableContentOffset = collectionView.contentOffset.y
            normalizedCenter = attributes.center.y - movableContentOffset
            maxDistance = self.itemSize.height + self.minimumLineSpacing
        }

        // 
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance

        let alpha = ratio * (1 - notCurrentCellAlpha) + notCurrentCellAlpha
        let scale = ratio * (1 - notCurrentCellScale) + notCurrentCellScale
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        let shiftPosition = (1 - ratio) * cellOffset
        if isHorizontal {
            attributes.center.y += shiftPosition
        } else {
            attributes.center.x += shiftPosition
        }
        
        return attributes
    }
}
