//
//  TutorialViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/01/03.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import KYNavigationProgress
import ViewAnimator

class TutorialViewController: UIViewController {

    //UIパーツの配置
    @IBOutlet weak fileprivate var titleScrollView: UIScrollView!
    @IBOutlet weak fileprivate var contentsContainerView: UIView!
    @IBOutlet weak fileprivate var introductionFinishButton: UIButton!

    //イントロダクションで表示させるViewController識別子
    fileprivate let targetViewControllerIdentifires = [
        "FirstIntroductionViewController",
        "SecondIntroductionViewController",
        "ThirdIntroductionViewController",
    ]

    //ページングして表示させるViewControllerを保持する配列
    fileprivate var targetViewControllerLists = [UIViewController]()

    //ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupKYNavigationProgress()
        setupPageViewController()
        setupIntroductionFinishButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Private Function

    //この画面のナビゲーションバーの設定
    private func setupNavigationBar() {
        self.navigationItem.title = "「ご近所ごはん検索」へようこそ!"
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
        
        //UIPageViewControllerでUIScrollViewDelegateを適用する
        for view in pageViewController!.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }

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

            //TODO: それぞれのViewControllerに表示する内容をセットする

            //ページングして表示させるViewControllerを保持する配列
            targetViewControllerLists.append(introductionViewController)
        }
    }
}

//MARK: - UIScrollViewDelegate

extension TutorialViewController: UIScrollViewDelegate {}

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
                let index = targetViewController.view.tag
                setKYNavigationProgressRatio(currentIndex: index)
                setIntroductionFinishButtonState(currentIndex: index)
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
        introductionFinishButton.isHidden = shouldHide
    }
}
