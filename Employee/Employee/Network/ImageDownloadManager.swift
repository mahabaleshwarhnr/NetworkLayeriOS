//
//  ImageDownloadManager.swift
//  MVVMExample
//
//  Created by mahabaleshwar hegde on 29/11/19.
//  Copyright © 2019 mahabaleshwar hegde. All rights reserved.
//

import UIKit



class ImageDownloadManager: ImageDownloadable, NetworkSessionConfigurable {
    
    let defaultImageCache = ImageCache.defaultImageCache
    
    var session: URLSession
    required init(session: URLSession) {
        self.session = session
    }
}

class ImageCache: NSObject {
    
    enum CachePolicy {
        case noCahce
        case autoPurge
        case reloadDataUpdateCache
    }
    
    static let defaultImageCache = ImageCache()
    
    private override init() {
        super.init()
    }
    
    func cacheImage(for url: URLConvertible, imageData: ImageDataConvertible, compression: CGFloat = 1.0) {
        do {
           let imageURL = try url.asURL()
            let data = imageData.toData(imageFormat: .jpeg(compression: compression))
            let response = URLResponse(url: imageURL, mimeType: "application/octet-stream", expectedContentLength: data.count, textEncodingName: nil)
            setCachedResponse(for: URLRequest(url: imageURL), response: response, data: data)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func cacheImage(for urlRequest: URLRequest, response: URLResponse, imageData: Data, compression: CGFloat = 1.0) {
        setCachedResponse(for: urlRequest, response: response, data: imageData)
    }
    
    func getCachedImage(for url: URLConvertible) -> UIImage? {
        
        do {
            let imageURL = try url.asURL()
            guard let cachedImageResponse = getCachedResponse(for: URLRequest(url: imageURL)) else {
                return nil
            }
            return UIImage(data: cachedImageResponse.data)
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func removeCache(for url: URLConvertible) {
        do {
            let imageURL = try url.asURL()
            let urlRequest = URLRequest(url: imageURL)
            URLCache.shared.removeCachedResponse(for: urlRequest)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func removeAllCache() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    private func getCachedResponse(for urlRequest: URLRequest) -> CachedURLResponse? {
        return URLCache.shared.cachedResponse(for: urlRequest)
    }
    
    private func setCachedResponse(for urlRequest: URLRequest, response: URLResponse, data: Data)  {
        let cachedResponse = CachedURLResponse(response: response, data: data, storagePolicy: .allowed)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}


protocol URLConvertible {
    
    func asURL() throws -> URL
}

extension URL: URLConvertible {
    
    func asURL() throws -> URL {
        return self
    }
}

extension String: URLConvertible {
    
    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw URLError(.unsupportedURL) }
        return url
    }
}

enum ImageFormat {
    case png
    case jpeg(compression: CGFloat)
}

protocol ImageDataConvertible {
    func toData(imageFormat: ImageFormat) -> Data
}

extension Data: ImageDataConvertible {
    
    func toData(imageFormat: ImageFormat = .png) -> Data {
        return self
    }
}

extension UIImage: ImageDataConvertible {
    
    func toData(imageFormat: ImageFormat = .png) -> Data {
        switch imageFormat {
        case .jpeg(let compression):
            return self.jpegData(compressionQuality: compression)!
        case .png:
            return self.pngData()!
        }
    }
}


