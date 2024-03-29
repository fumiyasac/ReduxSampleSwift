//
//  CustomInteractor.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/08/06.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class PickupMessageInteractor: UIPercentDrivenInteractiveTransition {

    private var navigationController: UINavigationController
    private var shouldCompleteTransition = false

    var transitionInProgress = false

    // MARK: - Initializer

    init?(attachTo viewController: UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            prepareGestureRecognizerInView(viewController.view)
        } else {
            return nil
        }
    }

    // MARK: - Private Function
    
    // UIScreenEdgePanGestureRecognizerが発火した際のアクションを定義する
    @objc private func handleGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {

        // X軸方向の変化量を算出する
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / self.navigationController.view.frame.width

        // UIScreenEdgePanGestureRecognizerの状態によって動き方の場合分けにする
        switch gesture.state {

        // (1)開始時
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break

        // (2)変更時
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            break

        // (3)キャンセル時
        case .cancelled:
            transitionInProgress = false
            cancel()
            break

        // (4)終了時
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break

        default:
            print("This state is unsupported to UIScreenEdgePanGestureRecognizer.")
            return
        }
    }

    // UIScreenEdgePanGestureRecognizerを追加する
    private func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
}
