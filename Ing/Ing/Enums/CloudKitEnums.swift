//
//  CloudKitEnums.swift
//  Ing
//
//  Created by 刘浩 on 2017/9/5.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import UIKit
import CloudKit

enum CloudKitZone: String {
    case Task = "Task"
    case TaskType = "TaskType"
    
    init?(recordType: String) {
        switch recordType {
        case ModelObjectType.Task.rawValue : self = .Task
        case ModelObjectType.TaskType.rawValue : self = .TaskType
        default : return nil
        }
    }
    
    func serverTokenDefaultsKey() -> String {
        return rawValue + "ServerChangeTokenKey"
    }
    
    func recordZoneID() -> CKRecordZoneID {
        return CKRecordZoneID(zoneName: rawValue, ownerName: CKOwnerDefaultName)
    }
    
    func recordType() -> String {
        switch self {
        case .Task : return ModelObjectType.Task.rawValue
        case .TaskType : return ModelObjectType.TaskType.rawValue
        }
    }
    
    func cloudKitSubscription() -> CKSubscription {
        
        // options must be set to 0 per current documentation
        // https://developer.apple.com/library/ios/documentation/CloudKit/Reference/CKSubscription_class/index.html#//apple_ref/occ/instm/CKSubscription/initWithZoneID:options:
        let subscription = CKSubscription(zoneID: recordZoneID(), options: CKSubscriptionOptions(rawValue: 0))
        subscription.notificationInfo = notificationInfo()
        return subscription
    }
    
    func notificationInfo() -> CKNotificationInfo {
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "Subscription notification for \(rawValue)"
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.shouldBadge = false
        return notificationInfo
    }
    
    static let allCloudKitZoneNames = [
        CloudKitZone.Task.rawValue,
        CloudKitZone.TaskType.rawValue
    ]
}

enum CloudKitUserDefaultKeys: String {
    
    case CloudKitEnabledKey = "CloudKitEnabledKey"
    case SuppressCloudKitErrorKey = "SuppressCloudKitErrorKey"
    case LastCloudKitSyncTimestamp = "LastCloudKitSyncTimestamp"
}

enum CloudKitPromptButtonType: String {
    
    case OK = "OK"
    case DontShowAgain = "Don't Show Again"
    
    func performAction() {
        switch self {
        case .OK:
            break
        case .DontShowAgain:
            UserDefaults.standard.set(true, forKey: CloudKitUserDefaultKeys.SuppressCloudKitErrorKey.rawValue)
        }
    }
    
    func actionStyle() -> UIAlertActionStyle {
        switch self {
        case .DontShowAgain: return .destructive
        default: return .default
        }
    }
}
