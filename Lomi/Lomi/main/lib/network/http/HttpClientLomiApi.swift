//
//  Api.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-12.
//

import Foundation

enum ApiError: Error {
    case deserialization
}

// An implementation of the LomiApi protocol using HttpClient
class HttpClientLomiApi: LomiApi {
    static private let defaultErrorResponse = LomiApiErrorResponse(userErrorMessage: "There was an unexpected error.  Please try again.")
    static private let defaultHeaders = [
        "x-lomi-client": "iOS",
        "x-lomi-client-version": "1.0.0"
    ];

    private let httpClient: HttpClient
    private let baseUrl: String
    
    init(httpClient: HttpClient, baseUrl: String) {
        self.httpClient = httpClient
        self.baseUrl = baseUrl
    }

    func updateUser(
        authToken: String,
        request: UpdateUserRequest,
        onSuccess: @escaping (UpdateUserResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.patchJson(
            url: getApiUrl(path: "/users"),
            body: request,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders, authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func updateUserEmail(
        authToken: String,
        request: UpdateUserEmailRequest,
        onSuccess: @escaping (UpdateUserEmailResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.patchJson(
            url: getApiUrl(path: "/users/email"),
            body: request,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders, authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func resendEmailVerification(
        request: ResendEmailVerificationRequest,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.postJson(
            url: getApiUrl(path: "/users/emailVerification/send"),
            body: request,
            headers: HttpClientLomiApi.defaultHeaders,
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func authenticate(
        request: AuthenticateRequest,
        onSuccess: @escaping (AuthenticateResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.postJson(
            url: getApiUrl(path: "/auths"),
            body: request,
            headers: HttpClientLomiApi.defaultHeaders,
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func register(
        authToken: String,
        request: RegisterRequest,
        onSuccess: @escaping (RegisterResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.postJson(
            url: getApiUrl(path: "/registrations"),
            body: request,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders, authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func deleteRegistration(
        authToken: String,
        registrationId: String,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        var url = getApiUrl(path: "/registrations")
        url.appendingQueryParameter(key: "id", value: registrationId)
        httpClient.delete(
            url: url,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders, authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func sendPasswordResetEmail(
        email: String,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        httpClient.postJson(
            url: getApiUrl(path: "/passwordResets/emails"),
            body: SendPasswordResetEmailRequest(email: email),
            headers: HttpClientLomiApi.defaultHeaders,
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func getLomiMaterials(
        request: LomiMaterialsRequest,
        onSuccess: @escaping (LomiMaterialsResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        var url = getApiUrl(path: "/lomiMaterials")
        url.appendingQueryParameter(key: "format", value: request.bodyFormat.rawValue)
        
        httpClient.get(
            url: url,
            headers: HttpClientLomiApi.defaultHeaders,
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func getAppInit(
        authToken: String,
        request: GetAppInitRequest,
        onSuccess: @escaping (GetAppInitResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        var url = getApiUrl(path: "/app/init")
        url.appendingQueryParameter(key: "userId", value: request.userId)
        httpClient.get(
            url: url,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders, authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    func updateUserMetadata(
        authToken: String,
        request: UpdateUserMetadataRequest,
        onSuccess: @escaping (UpdateUserMetadataResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        
        let url = getApiUrl(path: "/users/metadata")
        httpClient.patchJson(
            url: url,
            body: request,
            headers: addAuthHeader(headers: HttpClientLomiApi.defaultHeaders,
                                   authToken: authToken),
            onResponse: {
                (response: HTTPURLResponse, data: Data?) -> Void in
                self.handleApiResponse(response: response, data: data, onSuccess: onSuccess, onError: onError)
            },
            onError: {
            (error: Error?) -> Void in
                DispatchQueue.main.async {
                  onError(HttpClientLomiApi.defaultErrorResponse)
                }
            }
        )
    }
    
    private func getApiUrl(path: String) -> URL {
        return URL(string: "\(baseUrl)\(path)")!
    }
    
    private func addAuthHeader(
        headers: Dictionary<String, String>,
        authToken: String
    ) -> Dictionary<String, String> {
        var result = ["Authorization": "Bearer \(authToken)"]
        result.merge(headers) { (current, _) in current }
        return result
    }
    
    private func handleApiResponse<SuccessType: Codable>(
        response: HTTPURLResponse,
        data: Data?,
        onSuccess: @escaping (SuccessType?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    ) {
        DispatchQueue.main.async {
            if response.statusCode >= 300 { // HTTP status: error
                var errorResponse = HttpClientLomiApi.defaultErrorResponse
                if let data = data {
                    if let decodedErrorResponse = try? JSONDecoder().decode(LomiApiErrorResponse.self, from: data) {
                        errorResponse = decodedErrorResponse
                        errorResponse.statusCode = response.statusCode
                    }
                }
                onError(errorResponse)
                return
            }

            if SuccessType.self != EmptyApiResponse.self {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(SuccessType.self, from: data) {
                        onSuccess(decodedResponse)
                        return
                    } else {
                        onError(LomiApiErrorResponse(userErrorMessage: "ApiError.Deserialization".localized()))
                        return
                    }
                }
            }
            
            onSuccess(nil)
        }
    }
}
