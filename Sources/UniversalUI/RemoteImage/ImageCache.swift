//
//  ImageCache.swift
//  
//
//  Created by Luis Abraham on 2020-12-12.
//

import SwiftUI

public protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

public struct TemporaryImageCache: ImageCache {
    private let cache: NSCache<NSURL, UIImage>
    
    // If limit is 0, there is no limit
    public init(limit: Int = 0) {
        cache = NSCache<NSURL, UIImage>()
        cache.countLimit = limit
    }
    
    public subscript(url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL)
        }
        
        set {
            newValue == nil
                ? cache.removeObject(forKey: url as NSURL)
                : cache.setObject(newValue!, forKey: url as NSURL)
        }
    }
}

public struct ImageCacheKey: EnvironmentKey {
    public static let defaultValue: ImageCache = TemporaryImageCache()
}

public extension EnvironmentValues {
    var imageCache: ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}

