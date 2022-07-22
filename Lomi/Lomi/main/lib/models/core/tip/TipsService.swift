//
//  TipsService.swift
//  Lomi
//
//  Created by Peter Harding on 2022-05-09.
//

import Foundation

class TipsService {
    private let baseURL = URL(string: AppConfig.domain + "/tips")!
    private let networkService: Networking

    init(networkService: Networking) {
        self.networkService = networkService
    }

    // TODO: tips was previously authenticated, but after the removal of bookmarks, there is no requirement to be authenticated
    func getTips() async -> [Tip]? {
        var reqURL = baseURL
        reqURL.appendingQueryParameter(key: "fields", value: TipFields.summary.rawValue)
        let reqParams = RequestParams(url: reqURL)
        let response: NetworkResponse<GetTipsResponse> = await networkService.request(reqParams)
        if (response.result == nil) {
            SystemLogger.log.debug(messages: "getTips nil response")
        }
        return response.result?.tips
    }

    func getTip(id: String) async -> Tip? {
        var reqURL = baseURL
        reqURL.appendingQueryParameter(key: "id", value: id)
        reqURL.appendingQueryParameter(key: "fields", value: TipFields.all.rawValue)
        let reqParams = RequestParams(url: reqURL)
        let response: NetworkResponse<GetTipsResponse> = await networkService.request(reqParams)
        if (response.result == nil) {
            SystemLogger.log.debug(messages: "getTip nil response")
        }
        return response.result?.tips.first
    }

}

struct GetTipsResponse: Codable {
    var tips: Array<Tip>
    var nextPageToken: String? // currently unused
}

enum TipFields: String, Codable {
    case all
    case summary
}

