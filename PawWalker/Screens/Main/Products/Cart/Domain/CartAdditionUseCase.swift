//
//  CartAdditionUseCase.swift
//  PawWalker
//
//  Created by shagar on 18/08/26.
//

final class CartAdditionUseCase {
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
        productId: String = "",
        productVariantId: String,
        forceAddToCart: Bool,
        cartId: String = ""
    ) async throws -> AddToCartModel {
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
            guestId: guestId,
            cartId : cartId
        )
        return response
    }
}
