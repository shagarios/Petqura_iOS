//
//  CartRepoistory.swift
//  PawWalker
//
//  Created by shagar on 06/08/26.
//

import Foundation
protocol CartRepoistory {
    func FetchCartDetails(guestId: String) async throws -> AddToCartModel
}
