//
//  MainViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2017/12/12.
//  Copyright © 2017年 酒井文也. All rights reserved.
//

import UIKit
import ReSwift

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = CalendarButtons.getCurrentCalendarButtonList()
        print(b)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

