//
//  BlogListScreen.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import SwiftUI

struct BlogListScreen : View {
    @ObservedObject var viewModel : HomeScreenViewModel
    weak var coordinator : HomeCoordinator?
    init(viewModel: HomeScreenViewModel, coordinator : HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    let colomns : [GridItem] = [GridItem(.flexible(minimum: 100, maximum: 160),spacing: 20),
                                GridItem(.flexible(minimum: 100, maximum: 160))]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack{
            Spacer()
                .frame(height : 20)
            ScrollView(showsIndicators: false){
                LazyVGrid(columns: colomns) {
                    ForEach(viewModel.blogList,id: \.blogID) {blog in
                        BlogItemView(blog: blog)
                            .onTapGestureForced {
                                viewModel.selectedBlogId = blog.blogID
                                coordinator?.push(.blogDetail(blogId: viewModel.selectedBlogId))
                            }
                    }
                }
            }
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.blogs),
                    leftButtons: ViewUtils.shared.backButtonView {
            self.mode.wrappedValue.dismiss()
        })
//        .navigationDestination(isPresented: $viewModel.showBlogDetailScreen) {
//            BlogDetailsScreen(viewModel: BlogDetailViewModel(blogId: viewModel.selectedBlogId))
//        }
    }
}

struct BlogItemView : View {
    var blog : Blog
    var imageSize : CGFloat = 130
    var width : CGFloat = 130
    var height : CGFloat = 110
    var textSize = FontConstants.primaryMediumTitle14
    var body: some View {
        VStack{
            imageView
            nameView
        }
    }
    
    private var imageView: some View {
        ImageURLView(url: blog.image1,isFill: true)
            .frame(width: width,height: height)
            .clipped()
            .cornerRadius(10)
            .itemBorderStyle(spacing: 0,shadowRadius : 3,bottomShadow: 0)
            
    }
    private var nameView : some View {
        Text(blog.title)
            .font(textSize)
            .foregroundStyle(Color.black)
            .lineLimit(1)
            .frame(width: width)
    }
}
