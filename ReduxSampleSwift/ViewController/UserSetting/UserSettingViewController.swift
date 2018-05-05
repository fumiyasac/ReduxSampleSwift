//
//  UserSettingViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/29.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {

    // 選択肢用のTableViewに関する定数
    private let TABLE_VIEW_VIEW_HEIGHT: CGFloat = 47.0
    private let SELETE_FORM_TABLE_VIEW_CELL = "SelectFormTableViewCell"

    // キーボード表示時に表示されるツールバーの設定
    private var keyboardToolBar: UIToolbar!

    // ユーザー情報のEntity
    // MEMO: Realmで定義しているものについてはEntityファイルを用意しインスタンス化して利用する
    fileprivate var userSetting: UserSettingEntity? = UserSetting.getUserSetting()

    @IBOutlet weak private var postalCodeTextField: UITextField!
    @IBOutlet weak private var residentPeriodTableView: UITableView!
    @IBOutlet weak private var freeWordTextView: UITextView!
    @IBOutlet weak private var nicknameTextField: UITextField!
    @IBOutlet weak private var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var ageTableView: UITableView!
    @IBOutlet weak private var userSettingSubmitButton: UIButton!

    // 入力用のTextFieldを場合分けするためのEnum
    fileprivate enum textFieldType: Int {
        case postalCode
        case nickname
    }

    // 入力用のTableViewを場合分けするためのEnum
    fileprivate enum tableViewType: Int {
        case residentPeriod
        case age
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupPostalCodeTextField()
        setupResidentPeriodTableView()
        setupFreeWordTextView()
        setupNicknameTextField()
        setupGenderSegmentedControl()
        setupUserSettingSubmitButton()
        setupAgeTableView()
        setupKeyboardAccesoryView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    @objc private func userSettingSubmitButtonTapped() {

    }

    @objc private func genderSegmentedControlValueChanged(sender: UISegmentedControl) {
        
    }

    @objc private func toolbarDoneButtonTapped() {

    }

    @objc private func toolbarCancelButtonTapped() {

    }

    private func setupNavigationBar() {
        self.navigationItem.title = "ユーザーアンケートを回答する"
    }

    private func setupKeyboardAccesoryView() {

        // キーボードにツールバーの設定を行う
        keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        keyboardToolBar.barStyle = UIBarStyle.default
        keyboardToolBar.sizeToFit()

        // ツールバー内に追加するスペースを定義する
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

        // ツールバー内に追加する入力完了ボタンを定義する
        let doneButton = UIBarButtonItem(title: "入力完了", style: .plain, target: self, action: #selector(self.toolbarDoneButtonTapped))
        doneButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor : UIColor.init(code: "#ff9900"),
            NSAttributedStringKey.font: UIFont(name: AppConstants.FONT_NAME, size: 17)!
            ], for: .normal)

        // ツールバー内に追加するキャンセルボタンを定義する
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.toolbarCancelButtonTapped))
        cancelButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor : UIColor.init(code: "#ff9900"),
            NSAttributedStringKey.font: UIFont(name: AppConstants.FONT_NAME, size: 17)!
            ], for: .normal)
        
        keyboardToolBar.items = [cancelButton, spacer, doneButton]

        // アクセサリービューにツールバーを追加する
    }

    private func setupPostalCodeTextField() {
        postalCodeTextField.delegate = self
    }

    private func setupResidentPeriodTableView() {
        residentPeriodTableView.delegate = self
        residentPeriodTableView.dataSource = self
        residentPeriodTableView.estimatedRowHeight = TABLE_VIEW_VIEW_HEIGHT
        residentPeriodTableView.delaysContentTouches = false
        residentPeriodTableView.tag = tableViewType.residentPeriod.rawValue
        residentPeriodTableView.registerCustomCell(SelectFormTableViewCell.self)
    }

    private func setupFreeWordTextView() {
        freeWordTextView.delegate = self
    }

    private func setupNicknameTextField() {
        nicknameTextField.delegate = self
    }

    private func setupGenderSegmentedControl() {
        genderSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.addTarget(self, action: #selector(self.genderSegmentedControlValueChanged(sender:)), for: .valueChanged)
    }

    private func setupAgeTableView() {
        ageTableView.delegate = self
        ageTableView.dataSource = self
        ageTableView.estimatedRowHeight = TABLE_VIEW_VIEW_HEIGHT
        ageTableView.delaysContentTouches = false
        ageTableView.tag = tableViewType.age.rawValue
        ageTableView.registerCustomCell(SelectFormTableViewCell.self)
    }

    private func setupUserSettingSubmitButton() {
        userSettingSubmitButton.addTarget(self, action: #selector(self.userSettingSubmitButtonTapped), for: .touchUpInside)
    }
}

// MARK: - UITextFieldDelegate

extension UserSettingViewController: UITextFieldDelegate {
    
}

// MARK: - UITextViewDelegate

extension UserSettingViewController: UITextViewDelegate {
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case tableViewType.residentPeriod.rawValue:
            return SelectedResidentPeriodEnum.getAll().count
        case tableViewType.age.rawValue:
            return SelectedAgeEnum.getAll().count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: SelectFormTableViewCell.self)

        switch tableView.tag {
        case tableViewType.residentPeriod.rawValue:
            let residentPeriod = SelectedResidentPeriodEnum.getAll()[indexPath.row]
            let residentPeriodCellData = (isSelected: false, statusCode: residentPeriod.getStatusCode(), cellText: residentPeriod.rawValue)
            cell.setCell(residentPeriodCellData)
            return cell
        case tableViewType.age.rawValue:
            let age = SelectedAgeEnum.getAll()[indexPath.row]
            let ageCellData = (isSelected: false, statusCode: age.getStatusCode(), cellText: age.rawValue)
            cell.setCell(ageCellData)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
}
