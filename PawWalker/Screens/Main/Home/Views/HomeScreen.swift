//
//  HomeScreen.swift
//  PawWalker
//
//  Created by shagar on 08/12/24.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel : HomeScreenViewModel
    @EnvironmentObject var appCoordinator : AppCoordinator
    weak var coordinator : HomeCoordinator?
    init(coordinator : HomeCoordinator,viewModel : HomeScreenViewModel) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing : 0) {
                BannerCaurouserView(banners: viewModel.bannerImages)
                    .padding(.top,20)
                    .itemBorderStyle(spacing: 0, shadowRadius: 1,bottomShadow: 0)
                SectionTitleView(title: TextResource.services.uppercased()) {
                    viewModel.showServiceViewAll = true
                }
                .padding(.top,20)
               serviceListView

//                SectionTitleView(title: TextResource.product.uppercased()) {
//                    viewModel.showCategoryViewAll = true
//                }
//                .padding(.top,20)
//               categoryListView
                
                SectionTitleView(title: TextResource.blogs.uppercased()) {
                    coordinator?.push(.blogList)
                }
                .padding(.top,20)
               blogList
                    .padding(.bottom,20)
                    
            }
            .padding(.horizontal,10)
//            .onAppear{
//                viewModel.isLoading = false
//                if tabBarIndex == .home {
//                    categoryId = ""
//                    selectedServiceId = ""
//                }
//            }
            .task {
                viewModel.appCoordinator = appCoordinator
                viewModel.appCoordinator?.selectedServiceId = ""
                if viewModel.appCoordinator?.selectedTab == .home {
                    viewModel.fetchHomePageData()
                    await viewModel.fetchBlogList()
                }
            
            }
        }
        .bottomSheet(isPresented: $viewModel.showServiceViewAll) {
            ServiceBottomSheet(services: viewModel.services, completion: { service in
                viewModel.showServiceViewAll = false
                viewModel.appCoordinator?.selectedServiceId = service.id
                viewModel.appCoordinator?.selectedTab = .clinic
            })
                .frame(height: UIScreen.screenHeight * 0.70)
        }
        .bottomSheet(isPresented: $viewModel.showCategoryViewAll) {
            CategoriesBottomSheet(categories: viewModel.categories,completion: {category in
                viewModel.showCategoryViewAll = false
                viewModel.selectedCategoryId = category.id
                viewModel.appCoordinator?.selectedCategoryId = category.id
                viewModel.appCoordinator?.selectedTab = .store
            })
                .frame( height: UIScreen.screenHeight * 0.70)
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
//        .topBarView(titleView: appCoordinator.titleView(),
//        rightButtons: ViewUtils.shared.cartButtonView(count: appCoordinator.cartItemCount, action: {
//           // viewModel.navigateToCart = true
//        }))
        .topBarView(titleView: appCoordinator.titleView())
        .bottomSheet(isPresented: $viewModel.showClinicReviewBottomSheet) {
            ClinicRatingBottomSheet(viewModel: viewModel)
                .padding(.bottom,100)
        }
    }
    
    private var serviceListView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack {
                ForEach(viewModel.services,id: \.id) { service in
                    ServiceCellView(
                        name: service.title ?? TextResource.empty,
                        image: service.icon ?? TextResource.empty
                    )
                    .padding(.leading,10)
                    .padding(.top,15)
                    .onTapGestureForced {
                        viewModel.appCoordinator?.selectedCategoryId = service.id
                        viewModel.appCoordinator?.selectedTab = .clinic
                    }
                }
            }
        }
    }
    private var categoryListView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack{
                ForEach(viewModel.categories,id: \.id) { category in
                    ServiceCellView(
                        name: category.categoryName ?? TextResource.empty,
                        image: category.icon ?? TextResource.empty
                    )
                    .padding(.top,15)
                    .padding(.leading,10)
                    .onTapGestureForced {
                        viewModel.selectedCategoryId = category.id
                        viewModel.appCoordinator?.selectedServiceId = category.id
                        viewModel.appCoordinator?.selectedTab = .store
                    }
                }
            }
        }
    }
    
    private var blogList : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack{
                ForEach(viewModel.blogList,id: \.blogID) {blog in
                    BlogItemView(blog: blog,imageSize: 100,
                                 textSize: FontConstants.primaryMediumTitle12)
                    .onTapGestureForced {
                        viewModel.selectedBlogId = blog.blogID
                        self.coordinator?.push(.blogDetail(blogId: viewModel.selectedBlogId))
                    }
                    .padding(.top,15)
                    .padding(.leading,10)
                }
            }
        }
    }
}


