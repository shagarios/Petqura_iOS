//
//  ProductDetailUseCase.swift
//  PawWalker
//
//  Created by shagar on 06/08/26.
//

import Foundation

struct ProductDetailUseCase {
    var repository : ProductDetailRepoistory
    init(repository:  ProductDetailRepoistory) {
        self.repository = repository
    }
    func execute(productId: String) async throws -> Product {
        let response = try await repository.fetchProductDetail(productId: productId)
        guard let result = response.result else {
            throw AppError.serverError
        }
        return result
    }
}
