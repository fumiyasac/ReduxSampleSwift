//
//  UserSetting.swift
//  ReduxSampleSwift
//
//  Created by 酒井文也 on 2018/04/29.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import RealmSwift

class UserSetting {
    
    // MARK: - Static Function
    
    static func isFinishedUserSetting() -> Bool {
        guard let _ = findLatestUserSetting() else {
            return false
        }
        return true
    }

    static func getUserSetting() -> UserSettingEntity? {
        return findLatestUserSetting()
    }

    static func addUserSetting(userSetting: UserSettingEntity) {
        do {
            let realm = try Realm()
            try! realm.write {
                let userSettingValue: [String : Any] = [
                    "postalCode": userSetting.postalCode,
                    "selectedResidentPeriod": userSetting.selectedResidentPeriod,
                    "freeWord": userSetting.freeWord,
                    "nickName": userSetting.nickName,
                    "gender": userSetting.gender,
                    "selectedAge": userSetting.selectedAge,
                    "createdAt": Date()
                ]
                _ = realm.create(UserSettingEntity.self, value: userSettingValue)
            }
        } catch {
            assertionFailure("ユーザー情報(UserSettingEntity)の保存に失敗しました。")
        }
    }

    // MARK: - Private Function

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
