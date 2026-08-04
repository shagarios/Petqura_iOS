//
//  HomeRepositoryImplementation.swift
//  PawWalker
//
//  Created by shagar on 08/07/26.
//

import Foundation

class HomeRepositoryImplementation : HomeRepository {
    @Injected var serviceLayer : ServiceLayerProtocol
    @Injected var internet : NetworkMonitor
    @Injected var coreDataService : CoreDataServiceProtocol
    
    func fetchHome() async throws -> HomeModel {
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        do {
            return try await serviceLayer.makeRequest(endpoint: .home)
        }
        catch let error as RequestError {
             throw AppError(requestError: error)
        }
    }
    func fetchBlog() async throws -> BlogListModel {
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        do {
            return try await serviceLayer.makeRequest(endpoint: .blogList)
        }
        catch let error as RequestError {
            throw AppError(requestError: error)
        }
    }
    func fetchUser()  {
            let result:Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user,
                sort: nil, predicate: nil, limit: nil)
            switch result {
            case .success(let users):
                UserSessionManager.shared.user =  users.last
            case .failure(_):
                break
            }
    }
//    func submitReviewToServer(postData : SubmitReviewRequest) {
//        var param : [String: Any] = [ApiParameters.clinicId : postData.clinicId]
//        param[ApiParameters.reviewContent] = postData.reviewContent
//        param[ApiParameters.reviewStarCount] = postData.reviewStarCount
//        param[ApiParameters.pendingReviewId] = postData.pendingReviewId
//        
//    }
    
}
