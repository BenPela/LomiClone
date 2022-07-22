//
//  RemoteImageCache.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-30.
//

import Foundation

// A cache of the N most recently accessed remote images.
class RemoteImageCache {
    
    private struct ImageCacheItem {
        var data: Data
        var lastAccessedAt: Int
    }
    
    private static let maxCachedImages = 25
    private var internalCache = Dictionary<URL, ImageCacheItem>()
    private let httpClient = URLSessionHttpClient()

    func get(
        url: URL,
        onImageData: @escaping (Data) -> Void,
        onError: @escaping (Error?) -> Void
    ) -> Data? {
        if var cachedItem = internalCache[url] {
            cachedItem.lastAccessedAt = Int(NSDate().timeIntervalSince1970)
            onImageData(cachedItem.data)
            return cachedItem.data
        }

        httpClient.get(
            url: url,
            headers: Dictionary<String, String>(),
            onResponse: {
                (_: HTTPURLResponse, data: Data?) -> Void in
                DispatchQueue.main.async {
                    if let data = data {
                        self.internalCache[url] = ImageCacheItem(data: data, lastAccessedAt: Int(NSDate().timeIntervalSince1970))
                        if self.internalCache.count > RemoteImageCache.maxCachedImages {
                            var minLastAccessedAt = Int.max
                            var minLastAccessedUrl: URL? = nil
                            self.internalCache.forEach { url, imageCacheItem in
                                if imageCacheItem.lastAccessedAt < minLastAccessedAt {
                                    minLastAccessedUrl = url
                                    minLastAccessedAt = imageCacheItem.lastAccessedAt
                                }
                            }
                            if let urlToRemove = minLastAccessedUrl {
                                self.internalCache.removeValue(forKey: urlToRemove)
                            }
                        }
                        onImageData(data)
                    } else {
                        onError(RemoteImageCacheError.nodata)
                    }
                }
            },
            onError: {
                (error: Error?) -> Void in
                DispatchQueue.main.async {
                    if let error = error {
                        SystemLogger.log.error(messages: "\(error)")
                    }
                    onError(error)
                }
            }
        )
        
        return nil
    }
    
}
