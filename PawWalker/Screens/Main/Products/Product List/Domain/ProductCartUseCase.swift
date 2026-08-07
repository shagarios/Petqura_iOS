//
//  CartUseCase.swift
//  PawWalker
//
//  Created by shagar on 30/07/26.
//

import Foundation

final class ProductCartUseCase: ProductCartUseCaseProtocol {
    @Injected var coreDataService : CoreDataServiceProtocol
    private let repository: ProductRepository
    private let guestSessionRepository : GuestSessionRepository
    var guestId : String = ""
    init(repository: ProductRepository,guestSessionRepository : GuestSessionRepository) {
        self.repository = repository
        self.guestSessionRepository = guestSessionRepository
    }

    func execute(
        action: CartAction,
        productId: String,
        productVariantId: String,
        forceAddToCart: Bool
    ) async throws -> CartUpdateResult {
        if UserSessionManager.shared.accessToken.isEmpty {
            self.guestId = UserSessionManager.shared.guestId
        }
        else if UserSessionManager.shared.guestId.isEmpty {
            self.guestId = self.guestSessionRepository.fetchGuestId()
        }
        
        let response: AddToCartModel = try await repository.updateProductCart(
            action: action.rawValue,
            productId: productId,
            productVariantId: productVariantId,
            forceAddToCart: forceAddToCart,
            guestId: guestId
        )

        if let guestID = response.result?.guestId, self.guestId.isEmpty {
            self.guestSessionRepository.updateGuestId(guestId: guestID)
        }
        if response.result?.canAddToCart == false {
            return .blocked(message: response.message)
        }
    
        guard let cartList = response.result?.cart else {
            UserSessionManager.shared.productIdententiyArray.removeAll(where: { $0.variantId == productVariantId })
            return .removed(cartCount: 0)
        }

        let cartCount = cartList.count

        if let matchedElement = cartList.first(where: {
            $0.productVariant?.productVariantID == productVariantId
        }),
        let productVariant = matchedElement.productVariant,
        let quantity = productVariant.cartQuantity {

            let isNew: Bool
            if let index = UserSessionManager.shared.productIdententiyArray.firstIndex(where: {
                $0.variantId == productVariant.productVariantID
            }) {
                UserSessionManager.shared.productIdententiyArray[index].cartQuantity = quantity
                isNew = false
            } else {
                UserSessionManager.shared.productIdententiyArray.append(
                    ProductIdentity(
                        productId: productId,
                        variantId: productVariantId,
                        isInCart: productVariant.isInCart ?? false,
                        cartQuantity: quantity
                    )
                )
                isNew = true
            }

            return .updated(variant: productVariant, quantity: quantity, cartCount: cartCount, isNew: isNew)
        }

        UserSessionManager.shared.productIdententiyArray.removeAll(where: { $0.variantId == productVariantId })
        return .removed(cartCount: cartCount)
    }
}

protocol ProductCartUseCaseProtocol {
    func execute(
        action: CartAction,
        productId: String,
        productVariantId: String,
        forceAddToCart: Bool
    ) async throws -> CartUpdateResult
}

enum CartUpdateResult {
    case blocked(message: String?)
    case updated(variant: Variant, quantity: Int, cartCount: Int, isNew: Bool)
    case removed(cartCount: Int)
}
