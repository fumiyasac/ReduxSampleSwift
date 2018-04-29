//
//  UserSettingViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/29.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {

    @IBOutlet weak private var postalCodeTextField: UITextField!
    @IBOutlet weak private var residentPeriodTableView: UITableView!
    @IBOutlet weak private var freeWordTextView: UITextView!
    @IBOutlet weak private var nicknameTextField: UITextField!
    @IBOutlet weak private var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var ageTableView: UITableView!
    @IBOutlet weak private var userSettingSubmitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
