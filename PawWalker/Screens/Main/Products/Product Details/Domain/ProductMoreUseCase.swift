//
//  ProductMoreUseCase.swift
//  PawWalker
//
//  Created by shagar on 31/07/26.
//

import Foundation

class ProductMoreUseCase {
    let productDetailRepository: ProductDetailRepoistory
    init(productDetailRepository: ProductDetailRepoistory) {
        self.productDetailRepository = productDetailRepository
    }
    func execute(productId: String,variantId: String,page: Int,
                 latitude: String,longtitude: String) async throws -> MoreProductListModel{
        do {
            let response = try await productDetailRepository.fetchMoreOptions(productId: productId,
                                                                              variantId: variantId,
                                                                              page: page, latitude: latitude,
                                                                              longtitude: longtitude)
            return response
        }
        catch let error {
            throw error
        }
    }
}
