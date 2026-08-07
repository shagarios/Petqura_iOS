//
//  CartDetailsUsecase.swift
//  PawWalker
//
//  Created by shagar on 06/08/26.
//

import Foundation

class CartDetailsUsecase {
    var repository : CartRepoistory
    var guestRepository : GuestSessionRepository
    var guestId : String = ""
    init(repository : CartRepoistory, guestReposiotry : GuestSessionRepository) {
        self.repository = repository
        self.guestRepository = guestReposiotry
    }
    func execute() async throws -> CartResult {
        let response = try await repository.FetchCartDetails(guestId: UserSessionManager.shared.guestId)
            guard let result = response.result else {
                throw AppError.decodingFailed
            }
            let cartList = result.cart ?? []
            UserSessionManager.shared.productIdententiyArray.removeAll()
            for cartItem in cartList {
                UserSessionManager.shared.productIdententiyArray.append(
                    ProductIdentity(productId: "",
                                    variantId: cartItem.productVariant?.productVariantID ?? "",
                                    isInCart: true, cartQuantity: cartItem.quantity ?? 0))
            }
            return result
    }
}
