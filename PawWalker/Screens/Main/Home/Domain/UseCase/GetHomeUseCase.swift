//
//  GetHomeUseCase.swift
//  PawWalker
//
//  Created by shagar on 08/07/26.
//

import Foundation

final class GetHomeUseCase {
    private var repository: HomeRepository
    init(repository: HomeRepository) {
        self.repository = repository
    }
    func execute() async throws -> HomeData {
            let response : HomeModel = try await repository.fetchHome()
            guard let result = response.result else {
                throw AppError.invalidResponse
            }
            
            return result
        }
    }

