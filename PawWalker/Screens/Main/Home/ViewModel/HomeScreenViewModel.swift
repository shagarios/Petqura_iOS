//
//  HomeScreenViewModel.swift
//  PawWalker
//
//  Created by shagar on 11/02/25.
//

import SwiftUI
import Combine

class HomeScreenViewModel : ObservableObject {
    @Injected var apiClient : ApiClientProtocol
     var cancellables = Set<AnyCancellable>()
    @Published var bannerImages : [String] = []
    @Published var services : [Services] = []
    @Published var categories : [Category] = []
    @Published var selectedCategoryId : String = TextResource.empty
    @Published var showServiceViewAll : Bool = false
    @Published var showCategoryViewAll : Bool = false
    @Published var showBlogPage : Bool = false
    @Injected var internet : NetworkMonitor
    @Published var showBlogDetailScreen : Bool = false
    @Published var selectedBlogId : String = ""
    @Published var blogList : [Blog] = []
    let column: [GridItem] = [GridItem(.fixed(150),spacing: 20),
                              GridItem(.fixed(150),spacing: 20)]
    @Published var isLoading : Bool = false
    @Published var hasNext : Bool = false
    @Published var showMapScreen : Bool = false
    @Published var clinicRating : Int = 0
    weak var appCoordinator: AppCoordinator?
    @Published var pendingReview : PendingReview?
    @Injected var coreDataService : CoreDataServiceProtocol
    @Published var showClinicReviewBottomSheet : Bool = false
    @Published var clinicReviewText: String = ""
    init() {
        fetchUser()
    }
    func fetchHomePageData() {
        guard Connectivity.isConnectedToInternet else {
            ToastCenter.shared.showToast(TextResource.noInternet, type: .error)
            return
        }
        
        isLoading = true
        apiClient.APIRequest(router: .home, responseType: HomeModel.self)
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let result = response.result {
                    self.bannerImages = result.banners.compactMap { $0.bannerImageMobile }
                    self.services = result.services
                    self.categories = result.categories
                    UserSessionManager.shared.services = result.services
                    UserSessionManager.shared.categories = result.categories
                    if  result.pendingReviews.count >= 1{
                        pendingReview = result.pendingReviews.first
                        showClinicReviewBottomSheet = true
                    }
                }
            }
            .store(in: &cancellables)
    }

    func fetchBlogList() async {
        guard internet.isConnectedToInternet else {
            ToastCenter.shared.showToast(TextResource.noInternet, type: .error)
            return
        }

        apiClient.APIRequest(router: .blogList, responseType: BlogListModel.self)
            .receive(on: DispatchQueue.main)
            .sink {  completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    ToastCenter.shared.showToast(error.backendError?.message ?? error.localizedDescription, type: .error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let result = response.result {
                    self.blogList = result.blogs
                } else {
                    self.blogList = []
                }
            }
            .store(in: &cancellables)
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
   
}
