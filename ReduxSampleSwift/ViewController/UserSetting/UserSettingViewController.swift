//
//  UserSettingViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/29.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class UserSettingViewController: UIViewController {

    // キーボード表示時に表示されるツールバーの設定
    private let keyboardToolBarHeight: CGFloat = 40.0
    private var keyboardToolBar: UIToolbar!

    // ユーザー情報のEntity
    // MEMO: Realmで定義しているものについてはEntityファイルを用意しインスタンス化して利用する
    private var userSettingEntity: UserSettingEntity = UserSetting.getUserSetting() ?? UserSettingEntity()

    // 選択項目用のUITableViewを選択した値を格納するメンバ変数
    private var selectedResidentPeriod: Int = 0
    private var selectedAge: Int            = 0

    // フォーム全体のUIScrollView
    @IBOutlet weak private var formScrollView: UIScrollView!

    // フォーム項目登録用のボタン
    @IBOutlet weak private var userSettingSubmitButton: UIButton!

    // フォーム項目
    @IBOutlet weak private var postalCodeTextField: UITextField!
    @IBOutlet weak private var residentPeriodTableView: UITableView!
    @IBOutlet weak private var freeWordTextView: UITextView!
    @IBOutlet weak private var nickNameTextField: UITextField!
    @IBOutlet weak private var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var ageTableView: UITableView!

    // 入力用のTextFieldを場合分けするためのEnum
    private enum textFieldType: Int {
        case postalCode
        case nickName
    }

    // 入力用のTableViewを場合分けするためのEnum
    private enum tableViewType: Int {
        case residentPeriod
        case age
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("ユーザーアンケートを回答する")
        setupFormScrollView()
        setupKeyboardAccesoryView()
        setupPostalCodeTextField()
        setupResidentPeriodTableView()
        setupFreeWordTextView()
        setupNickNameTextField()
        setupGenderSegmentedControl()
        setupAgeTableView()
        setupUserSettingSubmitButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeShown(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        // Stateが更新された際に通知を検知できるようにするリスナーを登録する
        appStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)

        // Stateが更新された際に通知を検知できるようにするリスナーを解除する
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // ユーザーアンケート情報を登録する際に実行されるアクション
    @objc private func userSettingSubmitButtonTapped() {

        // ユーザーアンケート情報を登録するActionCreatorを実行する
        UserSettingActionCreator.submitUserSetting(userSetting: userSettingEntity)
    }

    // 郵便番号の値が更新された際に実行されるアクション
    @objc private func postalCodeValueChanged(sender: UITextField) {

        // 郵便番号の変更を反映するActionCreatorを実行する
        if let postalCode = sender.text {
            UserSettingActionCreator.changePostalCodeInput(postalCode: postalCode)
        }
    }

    // ニックネームの値が更新された際に実行されるアクション
    @objc private func nickNameValueChanged(sender: UITextField) {

        // ニックネームの変更を反映するActionCreatorを実行する
        if let nickName = sender.text {
            UserSettingActionCreator.changeNickNameInput(nickName: nickName)
        }
    }

    // 性別の値を更新した際に実行されるアクション
    @objc private func genderSegmentedControlValueChanged(sender: UISegmentedControl) {

        // 性別の選択変更を反映するActionCreatorを実行する
        let gender = sender.selectedSegmentIndex
        UserSettingActionCreator.changeGenderSelect(gender: gender)
    }

    @objc private func toolbarCloseButtonTapped() {
        undoFormScrollViewState()
    }

    @objc private func hideKeyboardIfNeeded(sender: UITapGestureRecognizer) {

        // MEMO: UIScrollViewにキーボードを引っ込めたいのでUITapGestureRecognizerを付与したが、UITableViewCellのタップが呼ばれない
        // → タップ位置からどのUITableViewがタップされたかを割り出してタップされたセルを選択中となるようにする

        let touchForResidentPeriodTableView = sender.location(in: residentPeriodTableView)
        if let indexPath = residentPeriodTableView.indexPathForRow(at: touchForResidentPeriodTableView) {

            // お住まいの年数の選択変更を反映するActionCreatorを実行する
            let residentPeriod = SelectedResidentPeriodEnum.getAll()[indexPath.row]
            UserSettingActionCreator.changeResidentPeriodSelect(residentPeriod: residentPeriod)
            return
        }

        let touchForAgeTableView = sender.location(in: ageTableView)
        if let indexPath = ageTableView.indexPathForRow(at: touchForAgeTableView) {

            // 年齢の選択変更を反映するActionCreatorを実行する
            let age = SelectedAgeEnum.getAll()[indexPath.row]
            UserSettingActionCreator.changeAgeSelect(age: age)
            return
        }

        undoFormScrollViewState()
    }

    @objc func keyboardWillBeShown(_ notification: Notification) {

        // キーボードを開く際のObserver処理
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        UIView.animate(withDuration: duration, animations: {
            self.formScrollView.contentInset = contentInsets
            self.formScrollView.scrollIndicatorInsets = contentInsets
            self.view.layoutIfNeeded()
        })
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {

        // キーボードを閉じる際のObserver処理
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.formScrollView.contentInset = .zero
            self.formScrollView.scrollIndicatorInsets = .zero
            self.view.layoutIfNeeded()
        })
    }

    private func setupFormScrollView() {
        formScrollView.delaysContentTouches = false

        // MEMO: UIScrollViewとFiestResponderの処理を共存させる場合の処理
        let tapGestureForScrollView = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardIfNeeded(sender:)))
        formScrollView.addGestureRecognizer(tapGestureForScrollView)
    }

    // キーボードに付与するツールバーの設定を行う
    private func setupKeyboardAccesoryView() {

        // ツールバーのサイズ設定を行う
        keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardToolBarHeight))
        keyboardToolBar.barStyle = UIBarStyle.default
        keyboardToolBar.sizeToFit()

        // ツールバー内に追加するスペースと閉じるボタンを定義する
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(self.toolbarCloseButtonTapped))

        let attributeOfFont = [ NSAttributedString.Key.font : UIFont(name: AppConstants.FONT_NAME, size: 16)! ]

        closeButton.setTitleTextAttributes(attributeOfFont, for: .normal)
        closeButton.tintColor = UIColor.init(code: "#ff9900")
        
        keyboardToolBar.items = [spacer, closeButton]

        // アクセサリービューにツールバーを追加する
        postalCodeTextField.inputAccessoryView = keyboardToolBar
        freeWordTextView.inputAccessoryView    = keyboardToolBar
        nickNameTextField.inputAccessoryView   = keyboardToolBar
    }

    private func setupPostalCodeTextField() {
        postalCodeTextField.delegate = self
        postalCodeTextField.tag = textFieldType.postalCode.rawValue
        postalCodeTextField.placeholder = "（例）1700005"
        postalCodeTextField.addTarget(self, action: #selector(self.postalCodeValueChanged(sender:)), for: .editingChanged)
    }

    private func setupResidentPeriodTableView() {
        residentPeriodTableView.delegate = self
        residentPeriodTableView.dataSource = self
        residentPeriodTableView.estimatedRowHeight = SelectFormTableViewCell.CELL_HEIGHT
        residentPeriodTableView.delaysContentTouches = false
        residentPeriodTableView.tag = tableViewType.residentPeriod.rawValue
        residentPeriodTableView.registerCustomCell(SelectFormTableViewCell.self)
    }

    private func setupFreeWordTextView() {
        freeWordTextView.delegate = self
        freeWordTextView.layer.borderColor = UIColor.init(code: "#cecece").cgColor
        freeWordTextView.layer.cornerRadius = 5.0
        freeWordTextView.layer.borderWidth = 0.5
    }

    private func setupNickNameTextField() {
        nickNameTextField.delegate = self
        nickNameTextField.tag = textFieldType.nickName.rawValue
        nickNameTextField.placeholder = "（例）●●●●さん"
        nickNameTextField.addTarget(self, action: #selector(self.nickNameValueChanged(sender:)), for: .editingChanged)
    }

    private func setupGenderSegmentedControl() {
        genderSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.addTarget(self, action: #selector(self.genderSegmentedControlValueChanged(sender:)), for: .valueChanged)
    }

    private func setupAgeTableView() {
        ageTableView.delegate = self
        ageTableView.dataSource = self
        ageTableView.estimatedRowHeight = SelectFormTableViewCell.CELL_HEIGHT
        ageTableView.delaysContentTouches = false
        ageTableView.tag = tableViewType.age.rawValue
        ageTableView.registerCustomCell(SelectFormTableViewCell.self)
    }

    private func setupUserSettingSubmitButton() {
        userSettingSubmitButton.addTarget(self, action: #selector(self.userSettingSubmitButtonTapped), for: .touchUpInside)
    }

    private func undoFormScrollViewState() {

        // キーボード表示のステータス変更を反映するActionCreatorを実行する
        UserSettingActionCreator.hideKeyboardStatus()

        view.endEditing(false)
    }

    private func changeFormScrollViewState(offsetY: CGFloat) {

        // キーボード表示のステータス変更を反映するActionCreatorを実行する
        UserSettingActionCreator.showKeyboardStatus()

        UIView.animate(withDuration: 0.16, animations: {
            self.formScrollView.contentOffset.y = offsetY
        })
    }
}

// MARK: - StoreSubscriber

extension UserSettingViewController: StoreSubscriber {

    // ステートの更新が検知された際に実行される処理
    func newState(state: AppState) {

        // Debug.
        AppLogger.printStateForDebug(state.tutorialState, viewController: self)
        AppLogger.printStateForDebug(state.userSettingState, viewController: self)

        // アンケート回答登録が完了したらメイン画面へ遷移する
        let isFinishedUserSetting = state.tutorialState.isFinishedUserSetting
        if isFinishedUserSetting {
            performSegue(withIdentifier: "goMain", sender: self)
            return
        }

        // userSettingStateの値を反映する
        setUserSettingStateValues(userSettingState: state.userSettingState)

        // アンケート回答登録ボタンの状態を反映する
        updateUserSettingSubmitButtonStatus(userSettingState: state.userSettingState)
    }

    // MARK: - Private Function

    private func setUserSettingStateValues(userSettingState: UserSettingState) {

        // userSettingEntityインスタンスのプロパティへstate.userSettingStateの値を反映する
        userSettingEntity.postalCode             = userSettingState.postalCode
        userSettingEntity.selectedResidentPeriod = userSettingState.selectedResidentPeriod
        userSettingEntity.freeWord               = userSettingState.freeWord
        userSettingEntity.nickName               = userSettingState.nickName
        userSettingEntity.gender                 = userSettingState.gender
        userSettingEntity.selectedAge            = userSettingState.selectedAge

        // UIパーツに対してstate.userSettingStateの値を反映する
        postalCodeTextField.text                    = userSettingState.postalCode
        selectedResidentPeriod                      = userSettingState.selectedResidentPeriod
        freeWordTextView.text                       = userSettingState.freeWord
        nickNameTextField.text                      = userSettingState.nickName
        genderSegmentedControl.selectedSegmentIndex = userSettingState.gender
        selectedAge                                 = userSettingState.selectedAge

        // tableViewのリロードを行う
        residentPeriodTableView.reloadData()
        ageTableView.reloadData()
    }

    private func updateUserSettingSubmitButtonStatus(userSettingState: UserSettingState) {

        // 必須項目に入力されている値が妥当であるかを判定する
        let isPostalCodeValid: Bool = (userSettingState.postalCode.count > 0 && userSettingState.postalCode.count <= AppConstants.POSTAL_CODE_LIMIT)
        let isResidentPeriodValid: Bool = (userSettingState.selectedResidentPeriod > 0)
        let isFreeWordValid: Bool = (userSettingState.freeWord.count > 0 && userSettingState.freeWord.count <= AppConstants.FREE_WORD_LIMIT)
        let isNickName: Bool = (userSettingState.nickName.count > 0 && userSettingState.nickName.count <= AppConstants.NICK_NAME_LIMIT)
        let isAgeValid: Bool = (userSettingState.selectedAge > 0)

        // 必須項目の妥当性に応じて回答を登録するボタンの状態を判定する
        if isPostalCodeValid && isResidentPeriodValid && isFreeWordValid && isNickName && isAgeValid {
            userSettingSubmitButton.alpha = 1
            userSettingSubmitButton.isEnabled = true
            userSettingSubmitButton.setTitle("アンケートへの回答を完了する", for: .normal)
        } else {
            userSettingSubmitButton.alpha = 0.6
            userSettingSubmitButton.isEnabled = false
            userSettingSubmitButton.setTitle("必須項目が入力されていません", for: .normal)
        }
    }
}

// MARK: - UITextFieldDelegate

extension UserSettingViewController: UITextFieldDelegate {

    // UITextFieldの入力が開始された際に実行される処理
    func textFieldDidBeginEditing(_ textField: UITextField) {

        var targetOffsetY: CGFloat = 0
        if textField.tag == textFieldType.postalCode.rawValue {
            textField.keyboardType = .numberPad
            targetOffsetY = 135.0
        } else if textField.tag == textFieldType.nickName.rawValue {
            textField.keyboardType = .URL
            targetOffsetY = 859.0
        }

        guard targetOffsetY == 0 else {
            changeFormScrollViewState(offsetY: targetOffsetY)
            return
        }
    }
}

// MARK: - UITextViewDelegate

extension UserSettingViewController: UITextViewDelegate {

    // UITextViewの入力が開始された際に実行される処理
    func textViewDidBeginEditing(_ textView: UITextView) {
        let targetOffsetY: CGFloat = 649.0
        changeFormScrollViewState(offsetY: targetOffsetY)
    }

    // 自由入力項目の値が更新された際に実行されるアクション
    func textViewDidChange(_ textView: UITextView) {

        // 自由入力項目の変更を反映するActionCreatorを実行する
        if let freeWord = textView.text {
            UserSettingActionCreator.changeFreeWordInput(freeWord: freeWord)
        }
    }
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
            let residentPeriodCellData = (isSelected: (selectedResidentPeriod == residentPeriod.getStatusCode()), statusCode: residentPeriod.getStatusCode(), cellText: residentPeriod.rawValue)
            cell.setCell(residentPeriodCellData)
            return cell

        case tableViewType.age.rawValue:
            let age = SelectedAgeEnum.getAll()[indexPath.row]
            let ageCellData = (isSelected: (selectedAge == age.getStatusCode()), statusCode: age.getStatusCode(), cellText: age.rawValue)
            cell.setCell(ageCellData)
            return cell

        default:
            return UITableViewCell.init()
        }
    }
}
