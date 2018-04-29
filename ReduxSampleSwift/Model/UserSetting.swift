//
//  UserSetting.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/29.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

class UserSetting: Object {
    
    // MARK: - Static Function
    
    static func isFinishedUserSetting() -> Bool {
        if let _ = findLatestUserSetting() {
            return true
        } else {
            return false
        }
    }

    // MARK: - Private Function

    private static func setUserSetting(userSetting: UserSettingEntity) {
        do {
            let realm = try Realm()
            //
        } catch {
            assertionFailure("ユーザー情報(UserSettingEntity)の保存に失敗しました。")
        }
    }

    private static func findLatestUserSetting() -> UserSettingEntity? {
        do {
            let realm = try Realm()
            if let userSetting = realm.objects(UserSettingEntity.self).first {
                return userSetting
            }
        } catch {
            assertionFailure("ユーザー情報(UserSettingEntity)の取得に失敗しました。")
        }
        return nil
    }
}
