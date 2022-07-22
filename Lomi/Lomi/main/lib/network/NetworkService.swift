//
//  NetworkService.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-21.
//

import Foundation
import Alamofire

class NetworkService: Networking {
    private var appEnv: AppEnvironment

    // FIXME: don't need whole AppEnvironment, just auth
    // FIXME: also depend on abstraction (protocol), not concretion (AppEnvironment)
    init(appEnv: AppEnvironment) {
        self.appEnv = appEnv
    }

    public func request<T: Decodable>(_ requestParams: RequestParams) async -> NetworkResponse<T> {
        return await withCheckedContinuation({ continuation in
            request(requestParams, completion: { (response: T?, error: NetworkError?) in
                continuation.resume(returning: NetworkResponse(result: response, error: error))
            })
        })
    }

    private func request<T>(_ requestParams: RequestParams, completion: @escaping (T?, NetworkError?) -> Void) where T: Decodable {
        var reqHeaders = requestParams.headers
        // TODO: logic to detect endpoints requiring auth or not
        do {
            if let authToken = try appEnv.getLomiApiAuth()?.authToken {
                reqHeaders["Authorization"] = "Bearer \(authToken)"
            } else {
                SystemLogger.log.debug(messages: "NetworkService found empty authToken")
            }
        } catch {
            SystemLogger.log.error(messages: "NetworkService could not getLomiApiAuth", error.localizedDescription)
        }

        var AFreq = URLRequest(url: requestParams.url)
        AFreq.httpMethod = requestParams.httpMethod.rawValue
        AFreq.headers = HTTPHeaders(reqHeaders)
        if let bodyData = requestParams.body {
            AFreq.httpBody = bodyData
        }

        AF.request(AFreq)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    var decodedResponse: T?
                    if let data = response.data {
                        decodedResponse = JSONCodableHelper.decode(data: data)
                    }
                    completion(decodedResponse, nil)
                case .failure(let error):
                    SystemLogger.log.error(messages: "NetworkService AF.request failure", error.localizedDescription)
                    completion(nil, NetworkError(message: error.localizedDescription, statusCode: response.response?.statusCode ?? 0))
                }
            }
    }
}
