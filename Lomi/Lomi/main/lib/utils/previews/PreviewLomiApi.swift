//
//  DelegatedLomiApi.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-12.
//

import Foundation

// An implementation of the LomiApi protocol that returns errors for each method.
// Consumers can inherit and override methods as required for a view preview.
class PreviewLomiApi: LomiApi {
    static let defaultError = LomiApiErrorResponse(userErrorMessage: "Not implemented")
    
    func createUser(request: CreateUserRequest, onSuccess: @escaping (CreateUserResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func updateUser(authToken: String, request: UpdateUserRequest, onSuccess: @escaping (UpdateUserResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func updateUserEmail(authToken: String, request: UpdateUserEmailRequest, onSuccess: @escaping (UpdateUserEmailResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func resendEmailVerification(request: ResendEmailVerificationRequest, onSuccess: @escaping (EmptyApiResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func authenticate(request: AuthenticateRequest, onSuccess: @escaping (AuthenticateResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func register(authToken: String, request: RegisterRequest, onSuccess: @escaping (RegisterResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func updateRegistration(authToken: String, request: Registration, onSuccess: @escaping (UpdateRegistrationResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func deleteRegistration(authToken: String, registrationId: String, onSuccess: @escaping (EmptyApiResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func sendPasswordResetEmail(email: String, onSuccess: @escaping (EmptyApiResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func getLomiMaterials(request: LomiMaterialsRequest, onSuccess: @escaping (LomiMaterialsResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func getAppInit(authToken: String, request: GetAppInitRequest, onSuccess: @escaping (GetAppInitResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func getTips(authToken: String?, request: GetTipsRequest, onSuccess: @escaping (GetTipsResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
    
    func updateUserMetadata(authToken: String, request: UpdateUserMetadataRequest, onSuccess: @escaping (UpdateUserMetadataResponse?) -> Void, onError: @escaping (LomiApiErrorResponse) -> Void) {
        onError(PreviewLomiApi.defaultError)
    }
}
