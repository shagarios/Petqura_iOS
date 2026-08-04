//
//  HomeCoordinator.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//
import SwiftUI

enum HomePages : Hashable {
    case home
    case blogList
    case blogDetail(blogId: String)
}

class HomeCoordinator : ObservableObject {
        @Published var path = NavigationPath()
        weak var appCoordinator: AppCoordinator?
       @Published var showSheet : Bool = false
       @Published var homeViewModel = HomeScreenViewModel(getHomeUseCase:
       GetHomeUseCase(repository: HomeRepositoryImplementation()),
        getBlogUseCase: GetBlogUseCase(blogRepository: HomeRepositoryImplementation()))
        func push(_ page: HomePages) {
            path.append(page)
        }
        func pop() {
            path.removeLast()
        }
        func popToRoot() {
            path.removeLast(path.count)
        }
        
        @ViewBuilder
    func build(page: HomePages) -> some View {
        switch page {
        case .home:
            HomeScreen(coordinator: self, viewModel: homeViewModel)
        case .blogList:
            BlogListScreen(viewModel: homeViewModel,coordinator: self)
        case .blogDetail(let blogId):
            BlogDetailsScreen(blogId: blogId, coordinator: self)
        }
    }
}
