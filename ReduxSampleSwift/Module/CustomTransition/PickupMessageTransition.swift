//
//  CustomAnimator.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/06.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// 参考: UINavigationControllerと組み合わせたカスタムトランジションの例
// https://medium.com/@samstone/create-custom-uinavigationcontroller-transitions-in-ios-1acd6a0b6d25
class PickupMessageTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration: TimeInterval = 0.18
    private let customAnimatorTag = 99

    var presenting: Bool
    var originFrame: CGRect
    var originImage: UIImage

    // MARK: - Initializer

    init(presenting: Bool, originFrame: CGRect, originImage: UIImage) {
        self.presenting  = presenting
        self.originFrame = originFrame
        self.originImage = originImage
    }

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    /**
     * アニメーションの実装を定義する
     * この場合には画面遷移コンテキスト（UIViewControllerContextTransitioningを採用したオブジェクト）
     * → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // コンテキストを元にViewのインスタンスを取得する（存在しない場合は処理を終了）
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        // アニメーションの実体となるコンテナビューを作成する
        let container = transitionContext.containerView
        
        // 表示させるViewControllerを格納するための変数を定義する
        var detailView: UIView!
        
        // Case1: 進む場合
        if presenting {

            container.addSubview(toView)
            detailView = toView
            
        // Case2: 戻る場合
        } else {

            container.insertSubview(toView, belowSubview: fromView)
            detailView = fromView
        }

        // UIImageのインスタンスを設定したタグ値から割り出して、遷移先で表示するUIImageViewに追加する
        guard let targetImageView = detailView.viewWithTag(customAnimatorTag) as? UIImageView else {
            return
        }
        targetImageView.image = originImage
        targetImageView.alpha = 0

        // カスタムトランジションでViewControllerを表示させるViewの表示に関する値を格納する変数
        var toViewAlpha: CGFloat!
        var beforeTransitionImageViewFrame: CGRect!
        var afterTransitionImageViewFrame: CGRect!
        var afterTransitionViewAlpha: CGFloat!

        // Case1: 進む場合
        if presenting {

            toViewAlpha = 0
            beforeTransitionImageViewFrame = originFrame
            afterTransitionImageViewFrame  = targetImageView.frame
            afterTransitionViewAlpha = 1

        // Case2: 戻る場合
        } else {

            toViewAlpha = 1
            beforeTransitionImageViewFrame = targetImageView.frame
            afterTransitionImageViewFrame  = originFrame
            afterTransitionViewAlpha = 0
        }

        // 遷移時に動かすUIImageViewを追加する
        let transitionImageView = UIImageView(frame: beforeTransitionImageViewFrame)
        transitionImageView.clipsToBounds = true
        transitionImageView.contentMode   = .scaleAspectFill
        transitionImageView.image         = originImage
        container.addSubview(transitionImageView)

        // 遷移先のViewのアルファ値を反映する
        toView.alpha = toViewAlpha
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0.00, options: [.curveEaseInOut], animations: {
            transitionImageView.frame = afterTransitionImageViewFrame
            detailView.alpha = afterTransitionViewAlpha
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            targetImageView.alpha = 1
        })
    }
}
