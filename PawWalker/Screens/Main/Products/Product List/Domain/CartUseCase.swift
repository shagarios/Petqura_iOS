//
//  CartUseCase.swift
//  PawWalker
//
//  Created by shagar on 30/07/26.
//

import Foundation

class ProductCartUseCase : ProductCartUseCaseProtocol {
     @Injected var repository : ProductRepository
    init() {
    }
    func execute(action: CartAction,productId: String,productVariantId : String,forceAddToCart: Bool) async throws -> AddToCartModel {
        do {
            let response : AddToCartModel = try await repository.updateProductCart(action: action.rawValue, productId: productId, productVariantId: productVariantId, forceAddToCart: forceAddToCart)
            return response
        }
        catch let error {
            throw error
        }
    }
}

protocol ProductCartUseCaseProtocol  {
   func execute(action: CartAction,productId: String,productVariantId : String,forceAddToCart: Bool) async throws -> AddToCartModel
}
