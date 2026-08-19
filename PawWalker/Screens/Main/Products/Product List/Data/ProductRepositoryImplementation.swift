//
//  Repository.swift
//  PawWalker
//
//  Created by shagar on 30/07/26.
//

import Foundation

class ProductRepositoryImplementation : ProductRepository {
    @Injected var serviceLayer : ServiceLayerProtocol
    @Injected var internet : NetworkMonitor
    func updateProductCart(action: String,productId : String,
                           productVariantId : String,forceAddToCart: Bool,guestId: String,cartId : String) async throws -> AddToCartModel {
        var param : [String : Any] = [ApiParameters.productId : productId,
                                      ApiParameters.productVariantId: productVariantId,
                                      ApiParameters.action : action,
                                      ApiParameters.forceAddToCart : forceAddToCart,
                                      ApiParameters.cartId : cartId
                
        ]
        if guestId.isNotEmpty {
            param[ApiParameters.guestId] = guestId
        }
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        do {
            return try await serviceLayer.makeRequest(endpoint: .updateCart, parameters: param)
        }
        catch let error as NetworkError {
            if let error = error.backendError {
                throw AppError.unknown(error.message)
            }
            else if let networkError = error.initialError  {
                throw AppError(afError: networkError)
            }
            else {
                throw AppError.unknown(error.localizedDescription)
            }
           
        }
    }
    
}

