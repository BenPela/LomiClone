//
//  RegisterService.swift
//  Lomi
//
//  Created by Peter Harding on 2022-04-24.
//

import Foundation

class RegisterLomiService {
    private let baseURL = URL(string: AppConfig.domain + "/registrations")!
    private let networkService: Networking

    init(networkService: Networking) {
        self.networkService = networkService
    }

    func register() async -> Registration? {
        let reqParams = RequestParams(
            url: baseURL,
            httpMethod: .POST
        )
        let response: NetworkResponse<Registration> = await networkService.request(reqParams)
        return response.result
    }

    func updateRegistration(registration: Registration) async -> Registration? {
        guard let registrationData = JSONCodableHelper.encode(registration) else {
            return nil // could not encode, error will be logged by JSONCodableHelper
        }
        let reqParams = RequestParams(url: baseURL, httpMethod: .PUT, body: registrationData)
        // FIXME: let's update the API to get rid of this unnecessary wrapping
        let response: NetworkResponse<UpdateRegistrationResponse> = await networkService.request(reqParams)
        if (response.result == nil) {
            SystemLogger.log.debug(messages: "updateRegistration nil response")
        }
        return response.result?.registration
    }
}

struct UpdateRegistrationResponse: Codable {
    var registration: Registration
}
