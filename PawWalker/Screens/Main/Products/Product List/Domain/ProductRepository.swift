//
//  Repository.swift
//  PawWalker
//
//  Created by shagar on 30/07/26.
//

import Foundation

protocol ProductRepository {
    func updateProductCart(action: String,productId : String,
                           productVariantId : String,forceAddToCart: Bool,
                           guestId: String) async throws -> AddToCartModel
}
