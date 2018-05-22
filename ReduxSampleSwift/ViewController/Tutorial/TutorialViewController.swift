//
//  TutorialViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift
import KYNavigationProgress

class TutorialViewController: UIViewController {

    // UIパーツの配置
    @IBOutlet weak fileprivate var contentsContainerView: UIView!
    @IBOutlet weak fileprivate var introductionFinishButton: UIButton!

    // イントロダクションで表示させるタイトル
    fileprivate let targetViewControllerTitle = [
        "1番目のタイトル",
        "2番目のタイトル",
        "3番目のタイトル",
        "4番目のタイトル",
    ]

    // ページングして表示させるViewControllerを保持する配列
    fileprivate var targetViewControllerLists = [UIViewController]()

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupKYNavigationProgress()
        setupPageViewController()
        setupIntroductionFinishButton()
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

    // 紹介コンテンツを終了するボタンをタップした際のアクションの設定
    @objc private func tutorialFinishButtonTapped() {

        // チュートリアル完了時のActionCreatorを実行する
        TutorialActionCreator.finishTutorial()
    }

    // この画面のナビゲーションバーの設定
    private func setupNavigationBar() {
        self.navigationItem.title = "「ご近所情報検索」へようこそ!"
    }

    // この画面のナビゲーションバー下アニメーションの設定
    private func setupKYNavigationProgress() {
        self.navigationController?.progress = 0
        self.navigationController?.progressTintColor = UIColor.init(code: "#ffaa00", alpha: 1.0)
        self.navigationController?.trackTintColor    = UIColor.init(code: "#eeeeee", alpha: 1.0)
    }

    // 紹介コンテンツを終了するボタンの設定
    private func setupIntroductionFinishButton() {
        introductionFinishButton.isHidden = true
        introductionFinishButton.addTarget(self, action: #selector(self.tutorialFinishButtonTapped), for: .touchUpInside)
    }

    // UIPageViewControllerの設定
    private func setupPageViewController() {

        // UIPageViewControllerで表示したいViewControllerの一覧を取得する
        setIntroductionViewControllerLists()

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        for childViewController in childViewControllers {
            if let targetPageViewController = childViewController as? UIPageViewController {
                pageViewController = targetPageViewController
            }
        }

        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        // UIPageViewControllerでUIScrollViewDelegateが欲しい場合はこのように適用する
        //for view in pageViewController!.view.subviews {
        //    if let scrollView = view as? UIScrollView {
        //        scrollView.delegate = self
        //    }
        //}
        
        // 最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }

    // Tutorial.storyboard上に配置した紹介コンテンツ用のViewController配列に追加する
    private func setIntroductionViewControllerLists() {

        for index in 0..<targetViewControllerTitle.count {
            let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: Bundle.main)
            let cardIntroductionViewController = storyboard.instantiateViewController(withIdentifier: "CardIntroductionViewController")

            // 「タグ番号 = インデックスの値」でスワイプ完了時にどのViewControllerかを判別できるようにする ＆ 各ViewControllerの表示内容をセットする
            cardIntroductionViewController.view.tag = index

            // ページングして表示させるViewControllerを保持する配列
            targetViewControllerLists.append(cardIntroductionViewController)
        }
    }
}

// MARK: - StoreSubscriber

extension TutorialViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        print("TutorialStateの変更をTutorialViewControllerで受け取りました。")
        print("==============")
        print(state.tutorialState)
        print("--------------")

        // チュートリアルが完了したら初期設定画面へ遷移する
        let isFinishedTutorial = state.tutorialState.isFinishedTutorial
        if isFinishedTutorial {
            performSegue(withIdentifier: "goUserSetting", sender: self)
            return
        }

        // 現在のUIPageViewControllerの表示位置を更新する
        let currentPageViewControllerIndex = state.tutorialState.currentPageViewControllerIndex
        setKYNavigationProgressRatio(currentIndex: currentPageViewControllerIndex)
        setIntroductionFinishButtonState(currentIndex: currentPageViewControllerIndex)
    }

    // MARK: - Private Function
    
    // KYNavigationProgressの値をUIPageViewControllerの進み具合に合わせて変更する
    private func setKYNavigationProgressRatio(currentIndex: Int) {
        let currentProgress: Float = Float(currentIndex)
        let maxProgress: Float = Float(targetViewControllerTitle.count - 1)
        let ratio = currentProgress / maxProgress
        self.navigationController?.setProgress(ratio, animated: true)
    }

    // 紹介コンテンツを終了するボタンの表示をUIPageViewControllerの進み具合に合わせて変更する
    private func setIntroductionFinishButtonState(currentIndex: Int) {
        let currentProgress: Float = Float(currentIndex)
        let maxProgress: Float = Float(targetViewControllerTitle.count - 1)
        let shouldHide = (currentProgress < maxProgress)

        if shouldHide {
            hideIntroductionFinishButton()
        } else {
            displayIntroductionFinishButton()
        }
    }

    // 紹介コンテンツを終了するボタンを表示する
    private func displayIntroductionFinishButton() {
        introductionFinishButton.isHidden = false
        introductionFinishButton.alpha = 0

        UIView.animate(withDuration: 0.18, animations: {
            self.introductionFinishButton.alpha = 1
        }, completion: nil)
    }

    // 紹介コンテンツを終了するボタンを隠す
    private func hideIntroductionFinishButton() {
        introductionFinishButton.alpha = 1

        UIView.animate(withDuration: 0.18, animations: {
            self.introductionFinishButton.alpha = 0
        }, completion: { _ in
            self.introductionFinishButton.isHidden = true
        })
    }
}

// MARK: - UIScrollViewDelegate

//extension TutorialViewController: UIScrollViewDelegate {}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension TutorialViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    // （実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    // （実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    // （公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                // 受け取ったインデックス値を元にコンテンツ表示を更新する
                let index = targetViewController.view.tag

                // 現在ページインデックスを更新するActionCreatorを実行する
                TutorialActionCreator.setCurrentPage(index: index)
            }
        }
    }

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return nil
        } else {
            return targetViewControllerLists[index - 1]
        }
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        // インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return nil
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}
