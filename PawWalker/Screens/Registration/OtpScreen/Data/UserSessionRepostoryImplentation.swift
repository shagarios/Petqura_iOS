//
//  UserSessionRepostoryImplentation.swift
//  PawWalker
//
//  Created by shagar on 07/08/26.
//

import Foundation

class UserSessionRepostoryImplentation : UserSessionRepository {
    @Injected var coreDataService : CoreDataServiceProtocol
    
    func fetchUser() -> User? {
        let result:Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user,
            sort: nil, predicate: nil, limit: nil)
        switch result {
        case .success(let users):
            return users.first
        case .failure(_):
            return nil
        }
    }
}
