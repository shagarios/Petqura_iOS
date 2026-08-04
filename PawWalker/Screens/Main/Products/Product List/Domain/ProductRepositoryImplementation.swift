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
    func updateProductCart(action: String,productId : String,productVariantId : String,forceAddToCart: Bool) async throws -> AddToCartModel {
        let param : [String : Any] = [ApiParameters.productId : productId,
                                      ApiParameters.productVariantId: productVariantId,
                                      ApiParameters.action : action,
                                      ApiParameters.forceAddToCart : forceAddToCart
        ]
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        do {
            return try await serviceLayer.makeRequest(endpoint: .updateCart, parameters: param)
        }
        catch let error as RequestError {
             throw AppError(requestError: error)
        }
        
    }
    
}

