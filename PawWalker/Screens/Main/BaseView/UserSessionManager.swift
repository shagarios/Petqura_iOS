//
//  UserSessionManager.swift
//  PawWalker
//
//  Created by shagar on 13/01/25.
//

import SwiftUI
import Combine
class UserSessionManager : ObservableObject{
    @Injected var coreDataService : CoreDataServiceProtocol
    static let shared  = UserSessionManager()
    @Published var accessToken : String = ""
    @Published var refreshToken : String = ""
    @Published var orderID : String = TextResource.empty
    @Published var sessionID : String = TextResource.empty
    private var cancellables = Set<AnyCancellable>()
    @Published var services : [Services] = []
    @Published var categories : [Category] = []
    @Published var cartItemCount : Int = 0
    @Published var name : String = TextResource.empty
    @Published var isMapCompleted : Bool = false
    @Published var deviceToken : String = TextResource.empty
    @Published var showMapScreen: Bool = false
    @Published var appointmentId : String = ""
    @Published var productIdententiyArray : [ProductIdentity] = []
    @Published var guestId: String = ""
    @Published var user : User? {
        didSet {
            self.accessToken = user?.accessToken ?? ""
            self.refreshToken = user?.refreshToken ?? ""
            self.isMapCompleted = user?.isMapCompleted ?? false
            self.name = user?.name ?? TextResource.empty
            self.guestId = user?.guestId ?? ""
        }
    }
    init() {
        self.user = fetchUser()
    }
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
