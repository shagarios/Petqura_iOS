//
//  HomeScreenViewModel.swift
//  PawWalker
//
//  Created by shagar on 11/02/25.
//

import SwiftUI
import Combine

class HomeScreenViewModel : ObservableObject,ErrorHandable {
    @Injected var apiClient : ApiClientProtocol
    @Injected var serviceLayer : ServiceLayerProtocol
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
    @Injected var homeRepository : HomeRepository
    
    @Published var showClinicReviewBottomSheet : Bool = false
    @Published var clinicReviewText: String = ""
    private let getHomeUseCase : GetHomeUseCase
    private let getBlogUseCase : GetBlogUseCase
    init(getHomeUseCase : GetHomeUseCase,getBlogUseCase : GetBlogUseCase) {
        self.getHomeUseCase = getHomeUseCase
        self.getBlogUseCase = getBlogUseCase
        self.homeRepository.fetchUser()
    }
    
    @MainActor
    func fetchHomeDetails() async {
        defer{
            isLoading = false
        }
        isLoading = true
        do {
            let home : HomeData = try await getHomeUseCase.execute()
            self.bannerImages = home.banners.compactMap { $0.bannerImageMobile }
            self.services = home.services
            self.categories = home.categories
            if home.pendingReviews.count >= 1 {
                pendingReview = home.pendingReviews.first
                showClinicReviewBottomSheet = true
            }
        }
        catch let error as AppError {
            showError(error.errorDescription ?? "Something went wrong")
        }
        catch {
            showError(TextResource.apiError)
        }
    }
    @MainActor
    func fetchBlogList() async {
        defer {
            isLoading = false
        }
        do {
            isLoading = true
            self.blogList = try await getBlogUseCase.execute()
        }
        catch let error as AppError {
            showError(error.errorDescription ?? "Something went wrong")
        }
        catch {
            showError(TextResource.apiError)
        }
    }
    
    func fetchData() async {
        await withTaskGroup { group in
            group.addTask {
                await self.fetchHomeDetails()
            }
            group.addTask {
                await self.fetchBlogList()
            }
        }
    }
    
   
}
