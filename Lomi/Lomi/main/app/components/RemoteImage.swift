//
//  CachedRemoteImage.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-30.
//

import SwiftUI

// A view presenting a remote image (i.e. an image from a URL) that uses a cache to mitigate
// reloading recently accessed images from the server.
struct RemoteImage: View {

    private enum LoadingState {
        case loading, success, error
    }
    
    private class RemoteImageLoader: ObservableObject {
        var data = Data()
        var state = LoadingState.loading
        
        init(url: URL, remoteImageCache: RemoteImageCache) {
            if let cachedData = remoteImageCache.get(
                url: url,
                onImageData: {
                    (imageData: Data) -> Void in
                    self.data = imageData
                    self.state = .success
                    self.objectWillChange.send()
                },
                onError: {
                    (error: Error?) -> Void in
                    self.state = .error
                }
            ) {
                self.data = cachedData
                self.state = .success
            }
        }
    }
    
    @StateObject private var loader: RemoteImageLoader
    var contentMode: ContentMode
    var loadingImage: Image
    var errorImage: Image
    var aspectRatio: CGFloat?
    private static let remoteImageCache = RemoteImageCache()

    var body: some View {
        selectImage()
            .resizable()
            .aspectRatio(aspectRatio, contentMode: contentMode)
    }

    init(
        url: String,
        contentMode: ContentMode = .fit,
        loadingImage: Image = Image(systemName: "photo"),
        errorImage: Image = Image(systemName: "multiply.circle"),
        aspectRatio: CGFloat? = nil
    ) {
        self.contentMode = contentMode
        _loader = StateObject(wrappedValue: RemoteImageLoader(url: URL(string: url)!, remoteImageCache: RemoteImage.remoteImageCache))
        self.loadingImage = loadingImage
        self.errorImage = errorImage
        self.aspectRatio = aspectRatio
    }
    

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
                return loadingImage
        case .error:
            return errorImage
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return errorImage
            }
        }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "http://www.openminddevelopments.com/wp-content/uploads/2015/05/OMD_Logo_transparent.png")
    }
}
