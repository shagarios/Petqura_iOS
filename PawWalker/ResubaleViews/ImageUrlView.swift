////
////
////  ImageUrlView.swift
////  messej
////
////  Created by Nikhil Raj on 29/08/22
////  Copyright © 2022 messej. All rights reserved.
////
//
//
//import SwiftUI
//import UIKit
//import SDWebImageSwiftUI
//
//struct ImageUrlView: View {
//    
//    @ObservedObject var imageLoader:RemoteImageModel
//    var defaultImageName: String
//    
//    var mediaName: String = ""
//    var isShowLoader : Bool = false
//    var contentMode: ContentMode = .fill
//    var resizable: Bool = true
//    
//    init(withURL url:String, secondaryUrl: String? = nil, defaultImgName: String, showLoader: Bool = false, imageName: String? = nil, contentmode: ContentMode = .fill,isResizable:Bool = true) {
//        self.defaultImageName = defaultImgName
//        self.imageLoader = RemoteImageModel(imageUrl:url,
//                                            secondaryimageUrl: secondaryUrl,
//                                            mediaName: imageName,
//                                            defaultImage: defaultImgName)
//        self.isShowLoader = showLoader
//        self.mediaName = imageName ?? Strings.empty
//        self.contentMode = contentmode
//        self.resizable = isResizable
//    }
//    
//    init(defaultImgName: String) {
//        self.init(withURL: mediaMeta.thumbnail ?? Strings.empty, defaultImgName: defaultImgName, imageName: mediaMeta.mediaName)
//
//    }
//
//    var body: some View {
//        
//        if let displayImage = imageLoader.displayImage {
//            Image(uiImage: displayImage)
//                    .resizable()
//                    .aspectRatio(contentMode: contentMode)
//                    .redacted( // Need to double check the working of this code in other UIs
//                        reason: imageLoader.isLoading ? .placeholder : []
//                    )
//
//        } else if let imageUrl = imageLoader.secondaryImageUrl {
//            WebImage(url: URL(string: imageUrl)) { image in
//                    image.resizable()
//                    .aspectRatio(contentMode: contentMode)
//                } placeholder: {
//                        defaultImage
//                }
//        }
//        else if mediaName.isNotEmpty {
//            let path = Storage().saveFilesToLocal(fileName: self.mediaName, folderName: "\(FolderNames.photos)/\(FolderNames.sent)")
//            
//            if FileManager.default.fileExists(atPath: path), let image = UIImage().downsample(imageAt: URL(fileURLWithPath: path), to: CGSize(width: ViewHeight.height200.rawValue, height: ViewHeight.height200.rawValue)) {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: contentMode)
//            } else if defaultImageName.isNotEmpty{
//                defaultImage
//            }
//       } else if defaultImageName.isNotEmpty {
//           defaultImage
//       }
//        
//    }
//    
//    
//    private var defaultImage: some View {
//        Image(defaultImageName)
//            .if(resizable, transform: { newView in
//                newView.resizable()
//            })
//            .aspectRatio(contentMode: contentMode)
//            .overlay(ActivityIndicator(isAnimating: self.$imageLoader.isLoading, style: .medium)
//                .isRemove(!self.isShowLoader), alignment: .center)
//    }
//}
//
