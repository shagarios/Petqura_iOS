//
//  ClinicListScreen.swift
//  PawWalker
//
//  Created by shagar on 09/12/24.
//

import SwiftUI


struct ClinicListScreen: View {
    @StateObject var viewModel : ClinicListViewModel
    init(coordinator: ClinicCoordinator) {
        _viewModel =  StateObject(wrappedValue: ClinicListViewModel(coordinator: coordinator))
    }
    let colomns : [GridItem] = [GridItem(.flexible(minimum: 100, maximum: 160),spacing: 20),
                                GridItem(.flexible(minimum: 100, maximum: 160))]
    var body: some View {
            VStack {
                topView
                    .padding(.horizontal,20)
                    .padding(.top,10)
                if viewModel.shouldShowEmptyView {
                    emptyView
                }
                else if viewModel.shouldShowEmptySearchView {
                    emptySearchView
                }
                else {
                    clinicListView
                }
            }
            .makeWithLoader(isLoading: $viewModel.isLoading)
        .onAppear {
            viewModel.shouldShowEmptyView = false
            viewModel.shouldShowEmptySearchView = false
            viewModel.page = 1
            viewModel.searchText = ""
        }
        .task {
            if viewModel.filterArrayString.isEmpty {
                viewModel.fetchLocation()
            }
            else {
                viewModel.fetchClinicList(serviceId: viewModel.filterArrayString)
            }
         
        }
        .if(viewModel.showFilterList, transform: { view in
            view
                .toolbar(.hidden, for: .tabBar)
        })
        .bottomSheet(isPresented: $viewModel.showFilterList) {
            ClinicFilterBottomSheet(
                viewModel: viewModel,
                onApply: {
                    UserSessionManager.shared.selectedItems.removeAll()
                    UserSessionManager.shared.filersApiData.removeAll()
                    viewModel.filterArrayString = viewModel.makeApiString()
                    viewModel.showFilterList = false
                }
            )
                .frame(height: UIScreen.screenHeight * 0.70)
        }
        .topBarView(titleView: viewModel.coordinator?.appCoordinator?.titleView())
        .alert(TextResource.autheticationRequired,
               isPresented: $viewModel.showLoginRequiredAlert, actions: {
            Button(TextResource.signIn) {
                viewModel.coordinator?.appCoordinator?.selectedAccountPage = .register
                viewModel.coordinator?.appCoordinator?.selectedTab = .account
            }
            Button(TextResource.cancel) {
                viewModel.showLoginRequiredAlert = false
            }
        },message: {
            Text(TextResource.loginAlertMessage)
        })
       
    }
    private var searchView : some View {
        TextField(TextResource.clinicSearchPlaceholder, text: $viewModel.searchText)
    }
    private var topView : some View {
        HStack {
            searchView
            filterView
        }
        .makeSearchView()
    }
    private var filterView : some View {
        Button(action: {
            viewModel.showFilterList.toggle()
        }, label: {
            Image(ImageResource.filterIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.darkGray)
                .overlay(alignment: .topTrailing) {
                    if viewModel.filterArrayString.isNotEmpty {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color.primaryButton)
                    }
                     
                }
        })
    }
    var emptyView : some View {
        VStack{
            Spacer()
            Image(ImageResource.noProducts)
                .resizable()
                .frame(width: 200,height: 200)
                .padding(.top,-30)
            Text(TextResource.noClinicInCategory)
                .font(FontConstants.primaryRegularTitle14)
                .multilineTextAlignment(.center)
               
            Button(action: {
                viewModel.coordinator?.appCoordinator?.selectedServiceId = ""
                viewModel.fetchClinicList(serviceId:  viewModel.coordinator?.appCoordinator?.selectedServiceId ?? "")
            }, label: {
                Text(TextResource.browseClnic)
                    .font(FontConstants.primaryRegularTitle16)
                    .primaryButtonStyle(fullWidth : true)
            })
            .padding(.top,20)
            Spacer()
        }
        .padding(.horizontal,30)
    }
    var emptySearchView : some View {
        VStack{
            Spacer()
            Image(ImageResource.noProducts)
                .resizable()
                .frame(width: 200,height: 200)
                .padding(.top,-30)
            Text(TextResource.noClinicInCategory)
                .font(FontConstants.primaryRegularTitle14)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal,30)
    }
}

