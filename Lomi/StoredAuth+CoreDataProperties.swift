//
//  StoredAuth+CoreDataProperties.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//
//

import Foundation
import CoreData


extension StoredAuth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredAuth> {
        return NSFetchRequest<StoredAuth>(entityName: "StoredAuth")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var idToken: String?
    @NSManaged public var refreshToken: String?
    @NSManaged public var authUser: StoredUser?

}

extension StoredAuth : Identifiable {

}
