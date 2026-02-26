////
////  ImageCache.swift
////  AsyncImage
////
////  Created by Vadym Bulavin on 2/19/20.
////  Copyright © 2020 Vadym Bulavin. All rights reserved.
////
//
//import UIKit
//
//protocol ImageCache {
//    subscript(_ url: URL) -> UIImage? { get set }
//}
//
//struct TemporaryImageCache: ImageCache {
//    private let cache: NSCache<NSURL, UIImage> = {
//        let cache = NSCache<NSURL, UIImage>()
//        cache.countLimit =  DataValues.imageCacheLimit.rawValue 
//        cache.totalCostLimit = DataValues.imageResolution.rawValue * DataValues.imageResolution.rawValue * DataValues.imageResolutionSize.rawValue
//        return cache
//    }()
//    
//    subscript(_ key: URL) -> UIImage? {
//        get { cache.object(forKey: key as NSURL) }
//        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
//    }
//}
//
//
//class CachedImage {
//    var cache: NSCache<NSString, UIImage> = {
//        let cache = NSCache<NSString, UIImage>()
//        cache.countLimit = DataValues.imageCacheLimit.rawValue
//        cache.totalCostLimit = DataValues.imageResolution.rawValue * DataValues.imageResolution.rawValue * DataValues.imageResolutionSize.rawValue
//        return cache
//    }()
//    
//    
//    
//    func get(key: String) -> UIImage? {
//        return cache.object(forKey: NSString(string: key))
//    }
//    
//    func set(key: String, image: UIImage) {
//        cache.setObject(image, forKey: NSString(string: key))
//    }
//    func remove(key: String) {
//        cache.removeObject(forKey: NSString(string: key))
//    }
//}
//
//extension CachedImage {
//    private static var cachedImage = CachedImage()
//    static func getCachedImage() -> CachedImage {
//        return cachedImage
//    }
//}
