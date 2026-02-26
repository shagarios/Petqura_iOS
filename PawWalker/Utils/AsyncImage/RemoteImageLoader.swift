////
////
////  RemoteImageLoader.swift
////  messej
////
////  Created by Nikhil Raj on 29/08/22
////  Copyright © 2022 messej. All rights reserved.
////
//
//
//import Foundation
//import UIKit
//import Combine
//import SDWebImageSwiftUI
//
//class RemoteImageModel: ObservableObject {
//    @Published var displayImage: UIImage?
//    var imageUrl: String?
//    var secondaryImageUrl: String?
//    var cachedImage = CachedImage.getCachedImage()
//    var mediaName: String?
//    var defaultImageName: String
//    @Published var isLoading = false
//    
//    init(imageUrl: String?, secondaryimageUrl: String?, mediaName: String? = nil, defaultImage: String) {
//        self.imageUrl = imageUrl
//        self.secondaryImageUrl = secondaryimageUrl
//        self.mediaName = mediaName
//        self.defaultImageName = defaultImage
//        if imageFromCache() {
//            return
//        }
//        imageFromRemoteUrl()
//    }
//    
//    func imageFromCache() -> Bool {
//        guard let url = imageUrl, let cacheImage = cachedImage.get(key: url) else {
//            return false
//        }
//        displayImage = cacheImage
//        return true
//    }
//    
//    func imageFromRemoteUrl() {
//        guard let url = imageUrl, let imageURL = URL(string: url) else {
//            return
//        }
//        SDWebImageDownloader.shared.setValue(imageURL.getCookieStringValue(), forHTTPHeaderField:Strings.cookie)
//        self.isLoading = true
//        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
//            if let data = data {
//                DispatchQueue.main.async {
//                    guard let remoteImage = UIImage(data: data) else {
//                        self.isLoading = false
//                        self.fetchLoaclImageForTheMedia()
//                        return
//                    }
//                    self.cachedImage.set(key: self.imageUrl!, image: remoteImage)
//                    self.displayImage = remoteImage
//                    self.isLoading = false
//                }
//            }
//            else { DispatchQueue.main.async {  self.fetchLoaclImageForTheMedia();self.isLoading = false } }
//        }).resume()
//    }
//    
//    func fetchLoaclImageForTheMedia() {
//        if var media = self.mediaName, self.secondaryImageUrl == nil {
//            if media.components(separatedBy: Strings.dot).last != FileFormat.jpeg {
//                media = media + FileFormat.jpeg
//            }
//            let path = Storage().saveFilesToLocal(fileName: media, folderName: "\(FolderNames.photos)/\(FolderNames.sent)")
//            
//            if let image = UIImage().downsample(imageAt: URL(fileURLWithPath: path), to: CGSize(width: ViewHeight.height200.rawValue, height: ViewHeight.height200.rawValue)) {
//                self.displayImage = image
//                self.cachedImage.set(key: self.imageUrl!, image: image)
//            }
//            else  if self.defaultImageName == ImageNames.ProfileBlank {
//                self.displayImage = UIImage(named: self.defaultImageName)
//                self.cachedImage.set(key: self.imageUrl!, image: self.displayImage!)
//            }
//        }
//    }
//}
