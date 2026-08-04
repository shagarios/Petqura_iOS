//
//  ReviewRequest.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//

struct SubmitReviewRequest {
    let clinicId: String
    let reviewContent: String
    let reviewStarCount: Int
    let pendingReviewId: String
}
