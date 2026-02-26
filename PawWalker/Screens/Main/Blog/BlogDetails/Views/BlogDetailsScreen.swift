//
//  BlogDetailsScreen.swift
//  PawWalker
//
//  Created by shagar on 14/05/25.
//

import SwiftUI

struct BlogDetailsScreen : View {
    @StateObject var viewModel : BlogDetailViewModel
    weak var coordinator : HomeCoordinator?
    init(blogId : String,coordinator : HomeCoordinator) {
        _viewModel = StateObject(wrappedValue: BlogDetailViewModel(blogId: blogId))
        self.coordinator = coordinator
    }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack{
            VStack(spacing: 0) {
                 imageView
                .padding(.top,10)
                   
                    contentView
                
            }
            .padding(.horizontal,20)
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: viewModel.blog?.title ?? TextResource.blogDetails),
                    leftButtons: ViewUtils.shared.backButtonView {
            coordinator?.pop()
        })
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .task {
            viewModel.fetchBlogData()
        }
    }
 
    private var imageView : some View {
        HStack{
            Spacer()
            ImageURLView(url: viewModel.blog?.image1 ?? "",isFill: true)
                .frame(width: UIScreen.screenWidth - 100,height: 200)
                .clipped()
                .cornerRadius(10)
                .itemBorderStyle(radius : 15, spacing : 0,shadowRadius: 4,bottomShadow: 0)
            Spacer()
        }
    }
    private var contentView : some View {
        HTMLStringView(htmlContent: viewModel.blog?.content ?? "")
            .padding(.top,20)
    }
    private var titleView : some View {
        Text(viewModel.blog?.title ?? "")
            .font(FontConstants.primaryMediumTitle14)
            .padding(.top,10)
    }
}
