//
//  MyAccountScreen.swift
//  PawWalker
//
//  Created by shagar on 06/02/25.
//

import SwiftUI

struct MyAccountScreen: View {
    @StateObject var viewModel = MyAccountViewModel(
        cartDetailUseCase: CartDetailsUsecase(repository: CartRepositroyImplementation(),
                                              guestReposiotry: GuestSessionRepositoryImplementation(userSessionRespository: UserSessionRepostoryImplentation())))
    @EnvironmentObject var appCoordinator: AppCoordinator
    weak var coordinator : AccountCoordinator?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isIPad: Bool {
            horizontalSizeClass == .regular
    }
    init(coordinator : AccountCoordinator) {
        self.coordinator = coordinator
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment : .leading) {
                Group {
                    if UserSessionManager.shared.accessToken.isNotEmpty {
                        accountView
                    }
                    else {
                        Button(action: {
                            coordinator?.push(.register)
                        }, label: {
                            Text(TextResource.signIn)
                                .outlineButtonStyle(color: .primaryButton,fullWidth: true)
                        })
                    }
                }
                .padding(.top,isIPad ? 80 :  10)
//                if UserSessionManager.shared.accessToken.isNotEmpty {
//                    locationUpdateTextView
//                }
                
                AccountItemView(title: TextResource.myAddress, contentView: addressContentView, completiion: {
                    if UserSessionManager.shared.accessToken.isNotEmpty {
                        coordinator?.push(.myAddressList)
                    }
                    else {
                        viewModel.showLoginRequiredAlert = true
                    }
                }, count: viewModel.addressCount)
                    .padding(.top,20)
                
                AccountItemView(title: TextResource.myAppointment,contentView: myAppointmentContentView,completiion: {
                    if UserSessionManager.shared.accessToken.isNotEmpty {
                        coordinator?.push(.myAppointments)
                    }
                    else {
                        viewModel.showLoginRequiredAlert = true
                    }
                }, count: viewModel.appoinmentCount)
                    .padding(.top,20)
                
                AccountItemView(title: TextResource.myOrders,contentView: myOrderContentView,completiion: {
                   if UserSessionManager.shared.accessToken.isNotEmpty {
                        coordinator?.push(.myOrders)
                    }
                    else {
                        viewModel.showLoginRequiredAlert = true
                    }
                }, count: viewModel.orderCount)
                    .padding(.top,20)
                
                if UserSessionManager.shared.accessToken.isNotEmpty {
                    Button(action: {
                        viewModel.logout()
                    }, label: {
                        Text(TextResource.logout)
                            .outlineButtonStyle(color: .primaryButton,fullWidth: true)
                    })
                    .padding(.top,40)
                    Button(action: {
                        viewModel.showDeleteAccountAlert = true
                    }, label: {
                        Text(TextResource.deleteAccount)
                            .outlineButtonStyle(color: .red,fullWidth: true)
                    })
                    .padding(.top,10)
                    .padding(.bottom,50)
                }
                                
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 70)
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .alert("\(TextResource.deleteAccount)?",
               isPresented: $viewModel.showDeleteAccountAlert, actions: {
            Button(TextResource.delete,role: .destructive) {
                viewModel.deleteAccount()
            }
        },message: {
            Text(TextResource.deleteAccountConfirmationMessage)
        })
        .padding(.horizontal,20)
        .task {
            viewModel.getAddressList()
            viewModel.getAppointments()
            viewModel.fetchMyordersList()
            await viewModel.fetchCartDetails()
        }
        .onChange(of: appCoordinator.navigateToMyOrders) { newValue in
            if newValue {
                coordinator?.push(.myOrders)
            }
        }
        .onChange(of: appCoordinator.navigateToClinicOrders) { newValue in
            if newValue {
                coordinator?.push(.myAppointments)
            }
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .topBarView(titleView: coordinator?.appCoordinator?.titleView(),
                    rightButtons: ViewUtils.shared.cartButtonView(count: coordinator?.appCoordinator?.cartItemCount ?? 0,
                                                                  action: {
            viewModel.showCart = true
        }))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                viewModel.checkIfMapIsShowed()
            })
            
        }
        .alert(TextResource.autheticationRequired,
               isPresented: $viewModel.showLoginRequiredAlert, actions: {
            Button(TextResource.signIn) {
                coordinator?.push(.register)
            }
            Button(TextResource.cancel) {
                viewModel.showLoginRequiredAlert = false
            }
        },message: {
            Text(TextResource.loginAlertMessage)
        })
        .navigationDestination(isPresented: $viewModel.showCart) {
            CartDeatilsScreen(browseCompletion: {}, payementCompletion: {})
        }
        .navigationDestination(isPresented: $appCoordinator.navigateTologin) {
         MobileNumberRegistrationView(coordinator: coordinator)
        }
        .navigationDestination(isPresented: $appCoordinator.navigateToMyAddress) {
            MyAddressListScreen(coordinator: coordinator)
        }
        .navigationDestination(isPresented: $appCoordinator.navigateToMyOrders) {
            MyOrdersListScreen(coordinator: coordinator)
        }
        
    }
    
    @ViewBuilder
    private var addressContentView : some View {
        if viewModel.myAddress == nil {
            addNewAddressView
        }
        else {
            addressView
                .padding(.leading,20)
        }
    }
    @ViewBuilder
    private var myAppointmentContentView : some View {
        if let appointMentData = viewModel.myAppointmentData {
            MyAppointmentView(myAppointmentData: appointMentData)
        }
        else {
            EmptyView()
        }
    }
   
    @ViewBuilder
    private var myOrderContentView : some View {
        if let orderContentData = viewModel.myOrder {
            MyOrderView(myOrder: orderContentData)
        }
    }
    
    private var addNewAddressView : some View {
        HStack {
            Spacer()
            Button(action: {
                if UserSessionManager.shared.accessToken.isNotEmpty {
                    coordinator?.push(.location(isAccountRelated: true))
                    //coordinator?.push(.addNewAddress(isEdit: false, address: nil))
                }
                else {
                    viewModel.showLoginRequiredAlert = true
                }
                
            }, label: {
                Text(TextResource.addNewAddress)
                    .font(FontConstants.primaryRegularTitle14)
                    .foregroundStyle(Color(ColorResource.primaryButton))
                    .applyOutline(verticalPadding : 10,hortizontalPadding: 20,
                                  cornerRadius: 15,outlineColor: Color(ColorResource.primaryButton))
            })
            Spacer()
        }
    }
    private var addressView : some View {
        VStack(alignment : .leading) {
            Text(viewModel.myAddress?.fullname ?? TextResource.empty)
            Text(viewModel.myAddress?.address ?? TextResource.empty)
        }
        .font(FontConstants.primaryRegularTitle12)
        .foregroundStyle(ColorContants.slotGray)
    }
    private var accountView : some View {
        HStack {
            nameLogoView
            nameView
                .padding(.leading,20)
            Spacer()
        }
        .makeBackgroundView()
        .overlay(
            editIcon,alignment: .topTrailing
        )
    }
    private var locationUpdateTextView : some View {
            Button(action: {
                viewModel.showMapScreen = true
            }, label: {
                Text(message)
                    .multilineTextAlignment(.leading)
                    .font(FontConstants.primaryRegularTitle12)
            })
    }
    var message: AttributedString {
        var text = AttributedString("Updating your location will help us suggest the nearest clinics for you. ")
        text.font = .system(size: 12, weight: .regular)
        text.foregroundColor = .darkGray
        var update = AttributedString("Update Location")
        update.foregroundColor = .primaryButton
        update.font = .system(size: 12, weight: .regular)
        text.append(update)   // no space automatically
        
        return text
    }
    private var nameLogoView : some View {
            Text(UserSessionManager.shared.name.prefix(2).uppercased())
                .font(FontConstants.primaryMediumTitle30)
                .foregroundStyle(Color.white)
                .padding(20)
                .background(
                    Circle()
                        .foregroundStyle(Color.primaryButton)
                )
    }
    private var nameView : some View {
        HStack{
            VStack(alignment: .leading) {
                Text(UserSessionManager.shared.name)
                    .font(FontConstants.primaryMediumTitle18)
                Text(UserSessionManager.shared.user?.mobileNumber ?? TextResource.empty)
                    .font(FontConstants.primaryRegularTitle12)
                Text(UserSessionManager.shared.user?.email ?? TextResource.empty)
                    .font(FontConstants.primaryRegularTitle12)
            }
        }
    }
    private var editIcon: some View {
        Button(action: {
            coordinator?.push(.register)
        }, label: {
            Image(.editIcon)
                .padding(.top,10)
                .padding(.trailing,10)
        })
       
    }
    
}

struct AccountItemView <ContentView : View> : View {
    var title : String
    var contentView : ContentView
    var completiion : () -> ()
    var count : Int
    var body: some View {
        VStack(alignment: .leading,spacing : 0) {
            headerView
            Divider()
                .padding(.vertical,10)
            contentView
        }
        .frame(maxWidth : .infinity)
        .padding(.vertical,20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(ColorResource.littleGray))
        )
    }
    private var headerView : some View {
        HStack {
            Text("\(title)(\(count))")
                .font(FontConstants.primaryMediumTitle14)
                .padding(.leading,20)
            Spacer()
            Image(ImageResource.arrowButton)
                .resizable()
                .scaledToFit()
                .frame(width : 30, height: 30)
                .padding(.trailing,20)
                .onTapGesture {
                    completiion()
                }
        }
    }
}
