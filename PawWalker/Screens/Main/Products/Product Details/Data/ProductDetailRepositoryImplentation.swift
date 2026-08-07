//
//  ProductDetailRepositoryImplentation.swift
//  PawWalker
//
//  Created by shagar on 31/07/26.
//

import Foundation

class ProductDetailRepositoryImplentation : ProductDetailRepoistory {
    @Injected var serviceLayer : ServiceLayerProtocol
    @Injected var internet : NetworkMonitor
    
    func fetchProductDetail(productId: String) async throws -> ProductDetailModel {
        if internet.isConnectedToInternet {
            return try await serviceLayer.makeRequest(endpoint: .productDetail(productId: productId),
                                                      parameters: nil)
        }
        else {
            throw AppError.noInternet
        }
    }
    
    func fetchMoreOptions(productId: String,variantId: String,page: Int,
            latitude: String,longtitude: String) async throws -> MoreProductListModel {
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        do {
            return try await serviceLayer.makeRequest(endpoint:
                    .productMoreOptions(productId: productId, variantId: variantId, page: page, latitude: latitude, lontitude: longtitude),
                    parameters: nil)
        
        }
        catch {
           throw error
        }
    }
}
