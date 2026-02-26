//
//  UserDataManager.swift
//  PawWalker
//
//  Created by shagar on 19/01/25.
//

import SwiftUI
import CoreData

class UserDataManager {
    @Injected var coredataService : CoreDataServiceProtocol
    
    static let shared = UserDataManager()
    
    func fetchUser() -> User? {
        let fetchRequest = User.fetchRequest()
        let result: Result<[User],Error> = coredataService.fetch(tableName: TableNames.user, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let users):
            return users.first
        case .failure(let failure):
            return nil
        }
    }
}
