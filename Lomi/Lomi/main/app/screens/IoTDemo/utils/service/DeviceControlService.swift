//
//  DeviceControlService.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-05-20.
//

import Foundation

// FIXME: A temporary service. Fix this with the Network service layer.
struct DeviceControlService {
    // FIXME: remove these Hard coding data
    private let mockUrlSelectMode = "https://api-develop.lomi-app.net/lomi/selectprogram"
    private let mockAuthToken = "your auth token"
    private let mockUserId = "your user id"
    private let mockLomiId = "your lomi id"
    
    func modeSelect(_ mode: DeviceMode) async -> Bool {
        SystemLogger.log.debug(messages: "\(#function): Start")
        var request = URLRequest(url: URL(string: mockUrlSelectMode)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(mockAuthToken)", forHTTPHeaderField: "Authorization")

        // This logic should belong somewhere, eg inside the enum
        let selectedProgram: Int
        switch mode {
        case .grow:
            selectedProgram = 1
        case .ecoExpress:
            selectedProgram = 2
        case .lomiApproved:
            selectedProgram = 3
        }
        
        let parameters: [String: Any] = [
            "userId": mockUserId,
            "lomiId": mockLomiId,
            "selectedProgram": selectedProgram
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        // Just check the http status. Better to check mode from the response, however, a lot of things are not solidified yet so a simple way is used for now.
        return await withCheckedContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                defer {
                    SystemLogger.log.debug(messages: "\(#function): Finish")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case  200 ... 299 :
                        SystemLogger.log.debug(messages: "\(#function): Success")
                        continuation.resume(returning: true)
                        return
                    default:
                        SystemLogger.log.error(messages: "\(#function): Failure")
                    }
                }
                
                if let error = error {
                    SystemLogger.log.error(messages: "\(#function): error, \(error)")
                }
                
                continuation.resume(returning: false)
            }
            task.resume()
        }
        
    }
}
