//
//  CartRepositroyImplementation.swift
//  PawWalker
//
//  Created by shagar on 06/08/26.
//

import Foundation
class CartRepositroyImplementation : CartRepoistory {
    @Injected var serviceLayer : ServiceLayerProtocol
    @Injected var internet : NetworkMonitor
    func FetchCartDetails(guestId: String) async throws -> AddToCartModel {
        if internet.isConnectedToInternet {
            return try await serviceLayer.makeRequest(endpoint: .viewCart(guestId: guestId),
                                                      parameters: nil)
        }
        else {
            throw AppError.noInternet
        }
    }
}
