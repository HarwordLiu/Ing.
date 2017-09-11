//
//  ViewController.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/12.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CoreDataManagerViewController, NSFetchedResultsControllerDelegate {
    
    var coreDataManager: CoreDataManager?
    var modelObjectType: ModelObjectType?
    var task: Task?
    var hasObject: Bool = false
    var dateFormatter = DateFormatter()
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFetchedResultsController()
        
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
            let task = object as! TaskType
            print("\(String(describing: task.name)), \(String(describing: task.addDate))")
        }
//        let task = fetchedResultsController?.object(at: IndexPath(item: 0, section: 0)) as! Task
//        print("\(task.taskName)")
    }
    
    
    func saveObject() {
        view.endEditing(true)
        
        guard let managedObjectContext = coreDataManager?.mainThreadManagedObjectContext else {
                fatalError("ViewController - saveObject: guard statement failed for either no managedObjectContext or invalid input")
        }
        guard let newTaskType: TaskType = NSEntityDescription.insertNewObject(forEntityName: "TaskType", into: managedObjectContext) as? TaskType else {
            fatalError("ViewController - saveProject : could not TaskType Truck object")
        }
        newTaskType.addDate = NSDate()
        newTaskType.name = "工作"
        newTaskType.hidden = false
        newTaskType.lastUpdate = NSDate()
        print("\(newTaskType)")
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
    
    // NSFetchedResultsController
    func configureFetchedResultsController() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskType")
        let nameSortDescriptor = NSSortDescriptor(key: "addDate", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSortDescriptor]
//        fetchRequest.predicate = NSPredicate.init(format: "car == %@", TaskType as! CVarArg)
        
        if let managedObjectContext = coreDataManager?.mainThreadManagedObjectContext {
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        }
        catch let error as NSError {
            fatalError("NotesTableViewController - configureFetchedResultsController: fetch failed \(error.localizedDescription)")
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

