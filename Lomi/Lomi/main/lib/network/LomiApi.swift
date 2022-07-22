//
//  ApiProtocol.swift
//  Lomi
//
//  Created by Chris Worman on 2021-10-12.
//

import Foundation

// The protocol for the Lomi API (client).
protocol LomiApi {
   
    func updateUser(
        authToken: String,
        request: UpdateUserRequest,
        onSuccess: @escaping (UpdateUserResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func updateUserEmail(
        authToken: String,
        request: UpdateUserEmailRequest,
        onSuccess: @escaping (UpdateUserEmailResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func resendEmailVerification(
        request: ResendEmailVerificationRequest,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func authenticate(
        request: AuthenticateRequest,
        onSuccess: @escaping (AuthenticateResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func register(
        authToken: String,
        request: RegisterRequest,
        onSuccess: @escaping (RegisterResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func deleteRegistration(
        authToken: String,
        registrationId: String,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func sendPasswordResetEmail(
        email: String,
        onSuccess: @escaping (EmptyApiResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func getLomiMaterials(
        request: LomiMaterialsRequest,
        onSuccess: @escaping (LomiMaterialsResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )
    
    func getAppInit(
        authToken: String,
        request: GetAppInitRequest,
        onSuccess: @escaping (GetAppInitResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )

    func updateUserMetadata(
        authToken: String,
        request: UpdateUserMetadataRequest,
        onSuccess: @escaping (UpdateUserMetadataResponse?) -> Void,
        onError: @escaping (LomiApiErrorResponse) -> Void
    )

}
