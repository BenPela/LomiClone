//
//  StoredUser+CoreDataProperties.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//
//

import Foundation
import CoreData


extension StoredUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredUser> {
        return NSFetchRequest<StoredUser>(entityName: "StoredUser")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var lastUpdate: Double
    @NSManaged public var userAuth: StoredAuth?

}

extension StoredUser : Identifiable {

}
