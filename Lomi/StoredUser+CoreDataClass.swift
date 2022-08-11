//
//  StoredUser+CoreDataClass.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//
//

import Foundation
import CoreData

@objc(StoredUser)
public class StoredUser: NSManagedObject {

    func toUser() -> User? {
        guard let gId = id,
              let gEmail = email,
              let gFirstname = firstName,
              let gLastname = lastName
        else {
            SystemLogger.log.warning(
                tag: .coreData,
                messages: "StoredUser toUser failed",
                "id: \(String(describing: id))",
                "email: \(String(describing: email))",
                "firstName: \(String(describing: firstName))",
                "lastName: \(String(describing: lastName))"
            )
            return nil
        }
        return User(
            id: gId,
            firstName: gFirstname,
            lastName: gLastname,
            email: gEmail,
            metadata: []
        )
    }

    func fromUser(user: User) {
        id = user.id
        email = user.email
        firstName = user.firstName
        lastName = user.lastName
        lastUpdate = NSDate().timeIntervalSince1970
    }

}
