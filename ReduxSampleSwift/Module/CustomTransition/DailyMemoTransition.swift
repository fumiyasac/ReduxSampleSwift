//
//  DailyMemoTransition.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/05.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class DailyMemoTransition: NSObject {

    // トランジションの秒数
    private let duration: TimeInterval = 0.36

    // 縮小値（※画面遷移時のCoreAnimation用）
    private let scale: CGFloat = 0.93

    // トランジションの方向(present: true, dismiss: false)
    var presenting: Bool = true

    // アニメーション対象なるViewControllerの位置やサイズ情報を格納するメンバ変数
    var originalFrame: CGRect = CGRect.zero
}

// MARK: - UIViewControllerAnimatedTransitioning

extension DailyMemoTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return  duration
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
        let containerView = transitionContext.containerView

        // 表示させるViewControllerを格納するための変数を定義する
        var targetView: UIView!

        // Case1: 進む場合
        if presenting {

            targetView = toView
            targetView.alpha = 0.00

        // Case2: 戻る場合
        } else {

            targetView = fromView
            targetView.alpha = 1.00
        }

        // 表示させるViewControllerに関する設定を行う
        targetView.frame = originalFrame
        targetView.clipsToBounds = true

        // アニメーションの実体となるContainerViewに必要なものを追加する
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(targetView)

        UIView.animate(withDuration: duration, delay: 0.00, options: [], animations: {

            var targetAlpha: CGFloat

            // Case1: 進む場合
            if self.presenting {

                // 遷移元のViewControllerが縮小して奥に引っ込める表現をする
                fromView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                fromView.alpha = 0.00

                targetAlpha = 1.00

            // Case2: 戻る場合
            } else {

                // 遷移先のViewControllerが拡大して奥から出てくる表現をする
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.00

                targetAlpha = 0.00
            }

            // アニメーションで変化させる値を決定する（大きさとアルファに関する値）
            targetView.frame = self.originalFrame
            targetView.alpha = targetAlpha

        }, completion:{ finished in

            // 遷移元のViewControllerを表示しているViewは消去しておく
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
