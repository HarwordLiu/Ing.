//
//  HLCoreDataManager.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/12.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

typealias networkOperationResult = (_ success: Bool, _ errorMessage: String?) -> Void

class HLCoreDataManager: NSObject {
    var mainThreadManagedObjectContext: NSManagedObjectContext
    fileprivate var privateObjectContext: NSManagedObjectContext
    fileprivate var coordinator: NSPersistentStoreCoordinator
    
    init(closure:@escaping ()->()) {
        guard let modelURL = Bundle.main.url(forResource: "CoreDataModel", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL)
            else {
                fatalError("CoreDataManager - COULD NOT INIT MANAGED OBJECT MODEL")
        }
        coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel)
        
        mainThreadManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        privateObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        
        privateObjectContext.persistentStoreCoordinator = coordinator
        mainThreadManagedObjectContext.persistentStoreCoordinator = coordinator
        
        super.init()
        
        // 异步
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            [unowned self] in
            
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true,
                NSSQLitePragmasOption: ["journal_mode": "DELETE"]
            ] as [String : Any]
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            let storeURL = URL.init(string: "coredatamodel.sqlite", relativeTo: documentsURL)
            
            do {
                try self.coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                
                DispatchQueue.main.async {
                    closure()
                }
            }
            catch let error as NSError {
                fatalError("CoreDataManager - COULD NOT INIT SQLITE STORE: \(error.localizedDescription)")
            }

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(mergeContext(_:)), name:NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
        
        
    }
    
    func mergeContext(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender != mainThreadManagedObjectContext {
            mainThreadManagedObjectContext.performAndWait {
                [unowned self] in
                print("mainThreadManagedObjectContext.mergeChangesFromContextDidSaveNotification")
                self.mainThreadManagedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
    
    func createBackgroundManagedContext() -> NSManagedObjectContext {
        
        let backgroundManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        backgroundManagedObjectContext.persistentStoreCoordinator = coordinator
        backgroundManagedObjectContext.undoManager = nil
        return backgroundManagedObjectContext
    }
    
    func saveBackgroundManagedObjectContext(_ backgroundManagedObjectContext: NSManagedObjectContext) {
        
        if backgroundManagedObjectContext.hasChanges {
            do {
                try backgroundManagedObjectContext.save()
            }
            catch let error as NSError {
                fatalError("CoreDataManager - save backgroundManagedObjectContext ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    internal func savePrivateObjectContext() {
        
        privateObjectContext.performAndWait {
            [unowned self] in
            
            print("savePrivateObjectContext")
            do {
                try self.privateObjectContext.save()
            }
            catch let error as NSError {
                fatalError("CoreDataManager - SAVE PRIVATEOBJECTCONTEXT FAILED: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
