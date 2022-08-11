//
//  StoredAuth+CoreDataClass.swift
//  Lomi
//
//  Created by Peter Harding on 2022-07-14.
//
//

import Foundation
import CoreData

@objc(StoredAuth)
public class StoredAuth: NSManagedObject {

    func toAuth() -> Auth? {
        guard let gIdToken = idToken,
              let gAccessToken = accessToken,
              let gRefreshToken = refreshToken
        else {
            SystemLogger.log.warning(
                tag: .coreData,
                messages: "StoredAuth toAuth failed",
                "idToken: \(String(describing: idToken))",
                "accessToken: \(String(describing: accessToken))",
                "refreshToken: \(String(describing: refreshToken))"
            )
            return nil
        }
        return Auth(
            idToken: gIdToken,
            accessToken: gAccessToken,
            refreshToken: gRefreshToken
        )
    }

    func fromAuth(auth: Auth) {
        idToken = auth.idToken
        accessToken = auth.accessToken
        refreshToken = auth.refreshToken
    }

}
