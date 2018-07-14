//
//  ArrayExtension.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/07/14.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

// Arrayの拡張
// 参考: 【swift】Tips:配列内をランダムにシャッフルする
// https://dev.classmethod.jp/smartphone/shuffle-array/
extension Array {

    // 新しい配列の値を自分自身の順番を変更せずに返す(※ 破壊的な変更ではない)
    var shuffled: Array {
        var copied = Array<Element>(self)
        copied.shuffle()
        return copied
    }

    // 新しい配列の値を自分自身の順番を変更した状態にして返す(※ 破壊的な変更をする)
    private mutating func shuffle() {
        for i in 0..<self.count {
            let j = Int(arc4random_uniform(UInt32(self.indices.last!)))
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}
