//
//  ImageLoaderProtocol.swift
//  PawWalker
//
//  Created by shagar on 08/02/25.
//


import Foundation
import SwiftUI

protocol ImageLoaderProtocol  {
    func loadImage(url : String,placeHolder : Image, completion : @escaping (Image) -> ())
}
