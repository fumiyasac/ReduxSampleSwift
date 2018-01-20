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

    //UIパーツの配置
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var contentsContainerView: UIView!
    @IBOutlet weak fileprivate var introductionFinishButton: UIButton!

    //イントロダクションで表示させるViewController識別子
    fileprivate let targetViewControllerIdentifires = [
        "FirstIntroductionViewController",
        "SecondIntroductionViewController",
        "ThirdIntroductionViewController",
    ]

    //イントロダクションで表示させるタイトル
    fileprivate let targetViewControllerTitle = [
        "1番目のタイトル",
        "2番目のタイトル",
        "3番目のタイトル",
    ]

    //ページングして表示させるViewControllerを保持する配列
    fileprivate var targetViewControllerLists = [UIViewController]()

    //ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?

    //ユーザー情報クラスをインスタンス化する
    fileprivate let initialSetting = InitialSetting()

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTitleView()
        setupKYNavigationProgress()
        setupPageViewController()
        setupIntroductionFinishButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Stateが更新された際に通知を検知できるようにappStoreにリスナーを登録する
        appStore.subscribe(self)

        //チュートリアルの完了状態をUserDefaultより取得する
        let finishTutorialFlag = initialSetting.getFinishTutorialFlag()

        //setFinishTutorialFlagアクション(ReSwift)を実行する
        let finishTutorialAction = TutorialState.tutorialAction.setFinishTutorialFlag(result: finishTutorialFlag)
        appStore.dispatch(finishTutorialAction)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //Stateが更新された際に通知を検知できるようにappStoreに登録したリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Private Function

    //紹介コンテンツを終了するボタンをタップした際のアクションの設定
    @objc private func introductionFinishButtonTapped() {

        //setFinishTutorialFlagアクション(ReSwift)を実行する
        let finishTutorialAction = TutorialState.tutorialAction.setFinishTutorialFlag(result: true)
        appStore.dispatch(finishTutorialAction)
    }

    //この画面のナビゲーションバーの設定
    private func setupNavigationBar() {
        self.navigationItem.title = "「今日はコレ食べたい検索」へようこそ!"
    }

    //動くタイトル部分のアニメーションの設定
    private func setupTitleView() {
        titleLabel.superview?.layer.masksToBounds = true
        titleLabel.text = targetViewControllerTitle.first
    }

    //この画面のナビゲーションバー下アニメーションの設定
    private func setupKYNavigationProgress() {
        self.navigationController?.progress = 0
        self.navigationController?.progressTintColor = UIColor.init(code: "#ffaa00", alpha: 1.0)
        self.navigationController?.trackTintColor    = UIColor.init(code: "#eeeeee", alpha: 1.0)
    }

    //紹介コンテンツを終了するボタンの設定
    private func setupIntroductionFinishButton() {
        introductionFinishButton.isHidden = true
        introductionFinishButton.addTarget(self, action: #selector(self.introductionFinishButtonTapped), for: .touchUpInside)
    }

    //UIPageViewControllerの設定
    private func setupPageViewController() {

        //UIPageViewControllerで表示したいViewControllerの一覧を取得する
        setIntroductionViewControllerLists()

        //ContainerViewにEmbedしたUIPageViewControllerを取得する
        for childViewController in childViewControllers {
            if let targetPageViewController = childViewController as? UIPageViewController {
                pageViewController = targetPageViewController
            }
        }

        //UIPageViewControllerのデータソースの宣言
        pageViewController!.delegate = self
        pageViewController!.dataSource = self

        //最初に表示する画面として配列の先頭のViewControllerを設定する
        pageViewController!.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
    }

    //Tutorial.storyboard上に配置した紹介コンテンツ用のViewController配列に追加する
    private func setIntroductionViewControllerLists() {

        for index in 0..<targetViewControllerIdentifires.count {
            let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: Bundle.main)
            let introductionViewController = storyboard.instantiateViewController(withIdentifier: targetViewControllerIdentifires[index])

            //「タグ番号 = インデックスの値」でスワイプ完了時にどのViewControllerかを判別できるようにする ＆ 各ViewControllerの表示内容をセットする
            introductionViewController.view.tag = index

            //ページングして表示させるViewControllerを保持する配列
            targetViewControllerLists.append(introductionViewController)
        }
    }
}

//MARK: - StoreSubscriber

extension TutorialViewController: StoreSubscriber {

    //ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        //Debug.
        print("TutorialViewControllerにてStateの更新を検知しました！")

        let finishTutorialFlag = state.tutorialState.finishTutorialFlag
        if finishTutorialFlag {

            // TODO: 次の画面へ遷移する
            return
        }

        let currentPageViewControllerIndex = state.tutorialState.currentPageViewControllerIndex
        let isPreviousResult = state.tutorialState.isPrevious

        setKYNavigationProgressRatio(currentIndex: currentPageViewControllerIndex)
        setIntroductionFinishButtonState(currentIndex: currentPageViewControllerIndex)
        setTitleWithAnimation(title: targetViewControllerTitle[currentPageViewControllerIndex], isPrevious: isPreviousResult)
    }

    //MARK: - Private Function

    //KYNavigationProgressの値をUIPageViewControllerの進み具合に合わせて変更する
    private func setKYNavigationProgressRatio(currentIndex: Int) {
        let currentProgress: Float = Float(currentIndex)
        let maxProgress: Float = Float(targetViewControllerIdentifires.count - 1)
        let ratio = currentProgress / maxProgress
        self.navigationController?.setProgress(ratio, animated: true)
    }

    //紹介コンテンツを終了するボタンの表示をUIPageViewControllerの進み具合に合わせて変更する
    private func setIntroductionFinishButtonState(currentIndex: Int) {
        let currentProgress: Float = Float(currentIndex)
        let maxProgress: Float = Float(targetViewControllerIdentifires.count - 1)
        let shouldHide = (currentProgress < maxProgress)

        if shouldHide {
            hideIntroductionFinishButton()
        } else {
            displayIntroductionFinishButton()
        }
    }

    //紹介コンテンツを終了するボタンを表示する
    private func displayIntroductionFinishButton() {
        introductionFinishButton.isHidden = false
        introductionFinishButton.alpha = 0

        UIView.animate(withDuration: 0.18, animations: {
            self.introductionFinishButton.alpha = 1
        }, completion: nil)
    }

    //紹介コンテンツを終了するボタンを隠す
    private func hideIntroductionFinishButton() {
        introductionFinishButton.alpha = 1

        UIView.animate(withDuration: 0.18, animations: {
            self.introductionFinishButton.alpha = 0
        }, completion: { _ in
            self.introductionFinishButton.isHidden = true
        })
    }

    //アニメーション付きでラベルに表示する内容の変更を行う
    private func setTitleWithAnimation(title: String, isPrevious: Bool) {

        //アニメーションの設定を行う
        let transition            = CATransition()
        transition.type           = kCATransitionPush
        transition.duration       = 0.18
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.subtype        = kCATransitionFromLeft

        var key: String
        if isPrevious {
            transition.subtype = kCATransitionFromLeft
            key = "previous"
        } else {
            transition.subtype = kCATransitionFromRight
            key = "next"
        }

        //タイトルの設定とアニメーションの設定を同時に適用する
        titleLabel.text = title
        titleLabel.layer.add(transition, forKey: key)
    }
}

//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension TutorialViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    //ページが動いたタイミング（この場合はスワイプアニメーションに該当）に発動する処理を記載するメソッド
    //（実装例）http://c-geru.com/as_blind_side/2014/09/uipageviewcontroller.html
    //（実装例に関する解説）http://chaoruko-tech.hatenablog.com/entry/2014/05/15/103811
    //（公式ドキュメント）https://developer.apple.com/reference/uikit/uipageviewcontrollerdelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        //スワイプアニメーションが完了していない時には処理をさせなくする
        if !completed { return }

        //ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        if let targetViewControllers = pageViewController.viewControllers {
            if let targetViewController = targetViewControllers.last {

                //受け取ったインデックス値を元にコンテンツ表示を更新する
                let index = targetViewController.view.tag

                //setCurrentPageViewControllerIndexアクション(ReSwift)を実行する
                let pageViewControllerAction = TutorialState.tutorialAction.setCurrentPageViewControllerIndex(index: index)
                appStore.dispatch(pageViewControllerAction)
            }
        }
    }

    //逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        //インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        //インデックスの値に応じてコンテンツを動かす
        if index <= 0 {
            return nil
        } else {
            return targetViewControllerLists[index - 1]
        }
    }

    //順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        //インデックスを取得する
        guard let index = targetViewControllerLists.index(of: viewController) else {
            return nil
        }

        //インデックスの値に応じてコンテンツを動かす
        if index >= targetViewControllerLists.count - 1 {
            return nil
        } else {
            return targetViewControllerLists[index + 1]
        }
    }
}
