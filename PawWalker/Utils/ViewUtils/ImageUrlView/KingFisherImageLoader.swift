//
//  KingFisherImageLoader.swift
//  PawWalker
//
//  Created by shagar on 08/02/25.
//
//import Kingfisher
//import SwiftUI
//
//class KingFisherImageLoader : ImageLoaderProtocol {
//  @MainActor func loadImage(url: String, placeHolder: Image, completion: @escaping (Image) -> ()) {
//        guard let imageUrl = URL(string: url) else {
//            completion(placeHolder)
//            return
//        }
//        let resource = KFImage.url(imageUrl)
//      resource
//          .resizable()
//          .placeholder {placeHolder }
//    }
//    
//    
//}
