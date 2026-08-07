//
//  ProductDetailRepoistory.swift
//  PawWalker
//
//  Created by shagar on 31/07/26.
//

import Foundation

protocol ProductDetailRepoistory {
    func fetchMoreOptions(productId: String,variantId: String,page: Int,
                          latitude: String,longtitude: String) async throws ->  MoreProductListModel
    func fetchProductDetail(productId: String) async throws -> ProductDetailModel
}
