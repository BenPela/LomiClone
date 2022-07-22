//
//  JSONCodableHelper.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-24.
//

import Foundation

protocol CodableHelper {
    static func decode<T: Decodable>(data: Data) -> T?
    static func encode<T: Encodable>(_ object: T) -> Data?
}

public class JSONCodableHelper: CodableHelper {
    static func decode<T: Decodable>(data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            SystemLogger.log.error(messages: "DecodingError.dataCorrupted", context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            SystemLogger.log.error(messages: "DecodingError.keyNotFound", key.debugDescription, context.debugDescription)
        } catch let DecodingError.valueNotFound(_, context) {
            SystemLogger.log.error(messages: "DecodingError.valueNotFound", context.debugDescription)
        } catch let DecodingError.typeMismatch(_, context) {
            SystemLogger.log.error(messages: "DecodingError.typeMismatch", context.debugDescription)
        } catch {
            SystemLogger.log.error(messages: "DecodingError.unknown", error.localizedDescription)
        }
        return nil // all error cases return nil
    }

    static func encode<T: Encodable>(_ object: T) -> Data? {
        do {
            return try JSONEncoder().encode(object)
        } catch let EncodingError.invalidValue(_, context) {
            SystemLogger.log.error(messages: "EncodingError.invalidValue", context.debugDescription)
        } catch {
            SystemLogger.log.error(messages: "EncodingError.unknown", error.localizedDescription)
        }
        return nil // all error cases return nil
    }
}
