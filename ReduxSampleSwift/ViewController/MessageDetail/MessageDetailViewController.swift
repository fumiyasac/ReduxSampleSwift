//
//  MessageDetailViewController.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/05/27.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import AlamofireImage

// あとでするTODO: この部分をReduxに当てはめて管理する処理はいずれ作成する

class MessageDetailViewController: UIViewController {

    private var targetPickupMessage: PickupMessageEntity!

    @IBOutlet weak private var targetImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickupImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Function

    func setPickupMessageEntity(_ pickupMessage: PickupMessageEntity) {
        targetPickupMessage = pickupMessage
    }

    // MARK: - Private Function

    private func setupPickupImage() {
        if let imageUrl = URL(string: targetPickupMessage.imageUrl) {
            targetImageView.af_setImage(withURL: imageUrl)
        }
    }
}
