//
//  MockStateContainer.swift
//  LomiTests
//
//  Created by Peter Harding on 2022-07-12.
//

import Foundation
import CoreData
@testable import Lomi

class MockStateContainer: StateContainer {
    var managedContext: NSManagedObjectContext
    private var saved: NSManagedObject?

    init(dataModel: String) {
        var persistentContainer: NSPersistentContainer = {
            let description = NSPersistentStoreDescription()
            // This prevents the MockStateContainer from writing to a real location
            // https://medium.com/tiendeo-tech/ios-how-to-unit-test-core-data-eb4a754f2603
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: dataModel)
            container.persistentStoreDescriptions = [description]
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
        switch entityName {
        case "StoredUser":
            return saved ?? StoredUser(context: managedContext)
        default:
            return NSManagedObject()
        }
    }

    // assumes only one object will be saved at at time for testing purposes
    func save<T: NSManagedObject>(_ managedObject: T) -> Bool {
        saved = managedObject
        return true
    }

    func delete<T: NSManagedObject>(_ managedObject: T) -> Bool {
        saved = nil
        return true
    }


}
