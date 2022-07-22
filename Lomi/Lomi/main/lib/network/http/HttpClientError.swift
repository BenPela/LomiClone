//
//  HttpClientError.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-16.
//

import Foundation

enum HttpClientError: Error {
    case serialization      // Error serializing object
    case unexpected         // Unexpected error without any details
}
