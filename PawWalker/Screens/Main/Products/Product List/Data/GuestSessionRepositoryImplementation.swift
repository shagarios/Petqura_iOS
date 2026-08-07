//
//  GuestSessionRepositoryImplementation.swift
//  PawWalker
//
//  Created by shagar on 07/08/26.
//

import Foundation

class GuestSessionRepositoryImplementation : GuestSessionRepository {
   
    
    @Injected var coreDataService : CoreDataServiceProtocol
    var userSessionRespository : UserSessionRepository
    init(userSessionRespository : UserSessionRepository) {
        self.userSessionRespository = userSessionRespository
    }
    
    func fetchGuestId()  -> String {
            let result:Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user,
                sort: nil, predicate: nil, limit: nil)
            switch result {
            case .success(let users):
                return users.last?.guestId ?? TextResource.empty
            case .failure(_):
                return TextResource.empty
            }
    }
    func updateGuestId(guestId: String) {
        let entity : Any? = userSessionRespository.fetchUser() ?? coreDataService.createEntity(for: TableNames.user)
        guard let newUser = entity as? User else {return}
        newUser.guestId = guestId
        coreDataService.save(object: newUser)
        UserSessionManager.shared.guestId = guestId
    }
    func deleteGuestId() {
        let entity : Any? = userSessionRespository.fetchUser() ?? coreDataService.createEntity(for: TableNames.user)
        guard let newUser = entity as? User else {return}
        newUser.guestId = ""
        coreDataService.save(object: newUser)
        UserSessionManager.shared.guestId = ""
    }
}
