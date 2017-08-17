//
//  ViewController.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/12.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CoreDataManagerViewDelegate, NSFetchedResultsControllerDelegate {
    
    var coreDataManager: HLCoreDataManager?
    var task: Task?
    var hasObject: Bool = false
    var dateFormatter = DateFormatter()
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.medium
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.managedObjectContextChanged(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: coreDataManager?.mainThreadManagedObjectContext)
        
    }
    @IBAction func clickAddBtn(_ sender: UIButton) {
        saveObject()
    }
    @IBAction func clickFetchBtn(_ sender: UIButton) {
        configureFetchedResultsController()
    }
    @IBAction func clickLogBtn(_ sender: UIButton) {
        for object in (fetchedResultsController?.fetchedObjects)! {
            let task = object as! Task
            print("\(String(describing: task.taskName)), \(String(describing: task.taskType))")
        }
//        let task = fetchedResultsController?.object(at: IndexPath(item: 0, section: 0)) as! Task
//        print("\(task.taskName)")
    }
    
    func configureFetchedResultsController() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let nameSortDescriptor = NSSortDescriptor(key: "taskName", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        if let managedObjectContext = coreDataManager?.mainThreadManagedObjectContext {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        }
        catch let error as NSError {
            fatalError("ObjectTableViewController - configureFetchedResultsController: fetch failed \(error.localizedDescription)")
        }
    }
    
    func saveObject() {
        view.endEditing(true)
        guard let managerObjectCotext = coreDataManager?.mainThreadManagedObjectContext else {
            fatalError("ViewController - saveObject: guard statement failed for either no managedObjectContext or invalid input")
        }
        
        guard let managerTaskObject = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managerObjectCotext) as? Task else {
            fatalError("ViewController - saveProject : could not create Task object")
        }
        
        guard let managerTaskTypeObject = NSEntityDescription.insertNewObject(forEntityName: "TaskType", into: managerObjectCotext) as? TaskType else {
            fatalError("ViewController - saveProject : could not create TaskType object")
        }
        
        managerTaskTypeObject.id = 1;
        managerTaskTypeObject.name = "啦啦啦";
        
        managerTaskObject.taskName = "干活"
        managerTaskObject.duration = 20
        managerTaskObject.taskType = managerTaskTypeObject;
        
        coreDataManager?.save()
    }
    
    func managedObjectContextChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            // we don't care about inserted objects in this view
            if let updatedObjects = userInfo[NSUpdatedObjectsKey] {
//                checkForUpdate(updatedObjects as! Set<NSManagedObject>)
            }
            if let refreshed = userInfo[NSRefreshedObjectsKey] {
//                checkForUpdate(refreshed as! Set<NSManagedObject>)
            }
            if let deletedObjects = userInfo[NSDeletedObjectsKey] {
//                checkIfDeleted(deletedObjects as! Set<NSManagedObject>)
            }
        }
    }
//    
//    func checkForUpdate(_ updatedObjects: Set<NSManagedObject>) {
//        if let rootObject = modelObject(),
//            let managedObject = rootObject as? NSManagedObject,
//            let updatedObjectIndex = updatedObjects.index(of: managedObject) {
//            let updatedObject = updatedObjects[updatedObjectIndex]
//            setLabels(updatedObject as! CTBRootManagedObject)
//        }
//    }
//    
//    func checkIfDeleted(_ deletedObjects: Set<NSManagedObject>) {
//        if let rootObject = modelObject(),
//            let managedObject = rootObject as? NSManagedObject {
//            if deletedObjects.contains(managedObject) {
//                navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

