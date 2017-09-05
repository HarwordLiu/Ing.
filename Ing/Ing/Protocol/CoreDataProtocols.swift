//
//  CoreDataProtocols.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/16.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

@objc protocol CloudKitRecordIDObject {
    var recordID: Data? { get set }
}

extension CloudKitRecordIDObject {
    func cloudKitRecordID() -> CKRecordID? {
        guard let recordID = recordID else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: recordID) as? CKRecordID
    }
}

@objc protocol CloudKitManagedObject: CloudKitRecordIDObject {
    var lastUpdate: Date? { get set }
    var recordName: String? { get set }
    var recordType: String { get }
    func managedObjectToRecord(_ record: CKRecord?) -> CKRecord
    func updateWithRecord(_ record: CKRecord)
}

extension CloudKitManagedObject {
    func cloudKitRecord(_ record: CKRecord?, parentRecordZoneID: CKRecordZoneID?) -> CKRecord {
        
        if let record = record {
            return record
        }
        
        var recordZoneID: CKRecordZoneID
        if parentRecordZoneID != .none {
            recordZoneID = parentRecordZoneID!
        }
        else {
            guard let cloudKitZone = CloudKitZone(recordType: recordType) else {
                fatalError("Attempted to create a CKRecord with an unknown zone")
            }
            
            recordZoneID = cloudKitZone.recordZoneID()
        }
        
        let uuid = UUID()
        let recordName = recordType + "." + uuid.uuidString
        let recordID = CKRecordID(recordName: recordName, zoneID: recordZoneID)
        
        return CKRecord(recordType: recordType, recordID: recordID)
    }
    
    func addDeletedCloudKitObject() {
        
        if let managedObject = self as? NSManagedObject,
            let managedObjectContext = managedObject.managedObjectContext,
            let recordID = recordID,
            let deletedCloudKitObject = NSEntityDescription.insertNewObject(forEntityName: "DeletedCloudKitObject", into: managedObjectContext) as? DeletedCloudKitObject {
            deletedCloudKitObject.recordID = recordID
            deletedCloudKitObject.recordType = recordType
        }
    }
}

