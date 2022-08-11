//
//  CoreDataContainer.swift
//  Lomi
//
//  Created by Peter Harding on 2022-06-28.
//

import Foundation
import CoreData

protocol StateContainer {
    func fetchFirst(entityName: String) -> NSManagedObject
    func save<T: NSManagedObject>(_ managedObject: T) -> Bool
    func delete<T: NSManagedObject>(_ managedObject: T) -> Bool
}

class CoreDataContainer: StateContainer {
    var managedContext: NSManagedObjectContext

    init(dataModel: String) {
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: dataModel)
            container.loadPersistentStores(completionHandler: { description, error in
                if let error = error {
                    fatalError("Unabled to load persistent stores: \(error)")
                }
            })
            return container
        }()
        managedContext = persistentContainer.viewContext
    }

    func fetchFirst(entityName: String) -> NSManagedObject {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(request)
            if results.count > 0 {
                // this will always return an object even if one does not exist
                // for example, if you fetch a user and none exists, you will get
                // a StoredUser object with all properties having nil value
                if let firstItem = results.first as? NSManagedObject { return firstItem }
                return NSManagedObject(entity: request.entity!, insertInto: managedContext)
            }
        } catch let error {
            SystemLogger.log.error(tag: .coreData, messages: "could not fetch entity: \(error)")
        }
        return NSManagedObject(entity: request.entity!, insertInto: managedContext)
    }

    func save<T: NSManagedObject>(_ managedObject: T) -> Bool {
        do {
            try managedContext.save()
        } catch let error as NSError {
            // make a parameter for this option
            managedContext.refresh(managedObject, mergeChanges: false)
            SystemLogger.log.error(tag: .coreData, messages: "could not save data context: \(error), \(error.userInfo)")
            return false
        }
        return true
    }

    func delete<T: NSManagedObject>(_ managedObject: T) -> Bool {
        managedContext.delete(managedObject)
        do {
            try managedContext.save()
        } catch let error as NSError {
            managedContext.undo()
            SystemLogger.log.error(tag: .coreData, messages: "could not delete object: \(error), \(error.userInfo)")
            return false
        }
        return true
    }
}
