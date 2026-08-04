//
//  SubmitReviewUseCase.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//

import Foundation

class SubmitReviewUseCase {
    var homeRepository : HomeRepository
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
    
    func execute(param : SubmitReviewRequest) {
        
    }
}
