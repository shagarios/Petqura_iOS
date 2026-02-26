//
//  AppointmentDetailsScreen.swift
//  PawWalker
//
//  Created by shagar on 04/02/25.
//

import SwiftUI

struct AppointmentDetailsScreen: View {
    @StateObject var viewModel: AppointmentDetailsViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var appCoodinator : AppCoordinator
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                docterView
                    .padding(.top,20)
                appointmentTimeView
                    .padding(.top,20)
                    .padding(.horizontal,10)
                
                clinicView
                    .padding(.top,20)
                
                selectedService
                    .padding(.top,20)
                    .isRemove(viewModel.fromMyAppointment)
                
                petView
                    .padding(.top,5)
                couponView
                    .padding(.top,10)
                    .isRemove(viewModel.fromMyAppointment)
                billDetails
                    comfirmButtonView
                        .padding(.top,20)
                        .isRemove(viewModel.fromMyAppointment)
            
            }
        }
        .keyboardAware()
        .sheet(isPresented: $viewModel.showCashfreePage) {
            CashFreeHandler(paymentSessionId: viewModel.sessionID, orderId: viewModel.orderID)
        }
        .padding(.horizontal,15)
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.appointmentDetails),leftButtons: ViewUtils.shared.backButtonView(action: {
           // self.mode.wrappedValue.dismiss()
            viewModel.coordinator?.pop()
        }))
        .onTapGestureForced {
            UIApplication.shared.endEditing()
        }
        .task {
            if viewModel.fromMyAppointment {
                viewModel.fetchAppointmentDetails()
            }
            else {
                viewModel.fetchPriceDetails(couponCode: "")
            }
          
        }
        .onAppear(perform: {
            viewModel.appCoordinator = appCoodinator
            appCoodinator.navigateToAppointmentDetailsScreen = false
        })
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .alert(TextResource.autheticationRequired,
               isPresented: $viewModel.showLoginRequiredAlert, actions: {
            Button(TextResource.signIn) {
                appCoodinator.selectedAccountPage = .register
                appCoodinator.selectedTab = .account
            }
            Button(TextResource.cancel) {
                viewModel.showLoginRequiredAlert = false
            }
        },message: {
            Text(TextResource.loginAlertMessage)
        })
        .bottomSheet(isPresented: $viewModel.showServiceList) {
            ServiceBottomSheet(services: viewModel.serviceList, completion: { service in
                viewModel.showServiceList = false
                viewModel.selectedServiceData = service
                viewModel.selectedService = service.title ?? ""
            })
                .frame(height: UIScreen.screenHeight * 0.70)
        }
        
    }
    private var couponView : some View {
        VStack{
            HStack {
                Image(ImageResource.coupons)
                    .resizable()
                    .frame(width: 20,height: 20)
                Text(TextResource.applyCoupon)
                    .font(FontConstants.primaryRegularTitle14)
                Spacer()
                Image(ImageResource.downArrow)
            }
            .onTapGestureForced {
                viewModel.showCouponView.toggle()
            }
            if viewModel.showCouponView {
                HStack {
                    TextField(TextResource.enterCoupeCode, text: $viewModel.couponText)
                        .font(FontConstants.primaryRegularTitle14)
                    Spacer()
                    Button(action: {
                        if viewModel.isCouponApplied {
                            viewModel.couponText = TextResource.empty
                        }
                        viewModel.fetchPriceDetails(couponCode: viewModel.isCouponApplied ? TextResource.empty : viewModel.couponText)
                    }, label: {
                        Text(viewModel.isCouponApplied ? TextResource.clear.uppercased() : TextResource.apply.uppercased())
                            .foregroundStyle(Color(.primaryButton))
                            .font(FontConstants.primaryMediumTitle14)
                    })
                }
                .applyOutline()
            }
        }
    }
    private var selectedService: some View {
        Button(action: {
            viewModel.showServiceList = true
        },
               label: {
            HStack {
                HStack {
                    Text(viewModel.selectedService == "" ? "Select Service" : viewModel.selectedService)
                        .foregroundColor(viewModel.selectedService == "" ? .gray : .black)
                        .font(FontConstants.primaryRegularTitle14)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5))
                )
            }
        })
    }
    
    private var docterView : some View {
        HStack(spacing: 15) {
            docterImageView
            docterDetailView
        }
    }
    @ViewBuilder
    private var docterImageView : some View {
        if let photo = viewModel.docterData?.profilePhoto {
            if photo.isNotEmpty {
                ImageURLView(url: photo,isFill: true)
                    .frame(width: 80, height: 80)
                    .clipped()
            }
            else {
                Image(ImageResource.docterIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
        }
        else {
            Image(ImageResource.docterIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
        }
        
    }
    private var docterDetailView : some View {
        VStack(alignment: .leading) {
            Text(viewModel.docterData?.docterName ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(ColorContants.dateGray)
            Text(viewModel.docterData?.description ?? TextResource.empty)
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(ColorContants.dateGray)
            Text(viewModel.docterData?.qualification ?? TextResource.empty)
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(ColorContants.dateGray)
        }
    }
    private var appointmentTimeView : some View {
        HStack {
            Text(TextResource.appointmentTime)
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(ColorContants.dateGray)
            Spacer()
            ImageTextView(image: ImageResource.calendarIcon,
                          text: self.viewModel.appointmentData?.date ?? TextResource.empty)
            ImageTextView(image: ImageResource.timeIcon,
                          text: self.viewModel.appointmentData?.time ?? TextResource.empty)
                .padding(.leading,10)
        }
        .padding(.horizontal,15)
        .padding(.vertical,10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(ColorResource.primaryButton))
        )
    }
    @ViewBuilder
    private var clinicView : some View {
        if let clinic = viewModel.clinicData {
            HospitalView(clinic: clinic)
        }
        
    }
    private var priceView: some View {
        VStack{
            Text(TextResource.charges)
                .font(FontConstants.primaryRegularTitle14)
                .foregroundStyle(Color(ColorResource.priceGray))
            Text((self.viewModel.docterData?.price ?? TextResource.empty).addRupees())
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(ColorContants.dateGray)
        }
    }
    private var billDetails: some View {
        VStack(alignment: .leading) {
            Text(TextResource.billDetails)
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(Color.black)
                .padding(.top,5)
            BillItemView(name: TextResource.consultation,
                         value: (viewModel.appoinmentChargeData?.slotPrice ?? 0).stringValue())
            BillItemView(name: TextResource.serviceFeeAndGst,
                         value: viewModel.seriveAndGstPrice)
            BillItemView(name: TextResource.coupon,
                         value: (viewModel.appoinmentChargeData?.couponPrice ?? 0).stringValue())
            
            Divider()
            BillItemView(name: TextResource.totalPayable,
                         value: (viewModel.appoinmentChargeData?.total ?? 0).stringValue())
            
        }
        .makeBackgroundView()
    }
    @ViewBuilder
    private var petView: some View {
        if viewModel.fromMyAppointment {
            VStack(alignment : .leading,spacing: 0) {
                Text(TextResource.addPetName)
                    .foregroundStyle(Color(ColorResource.darkGray))
                    .font(FontConstants.primaryRegularTitle12)
                    .padding(.leading,5)
                    .padding(.bottom,10)
                    .padding(.top,15)
               
                Text(viewModel.petName)
                    .font(FontConstants.primaryRegularTitle14)
                    .padding(.leading,10)
                    .padding(.bottom,15)
                
            }
        }
        else {
            LabelTextField(label: TextResource.addPetName,
                           placeHolder: TextResource.enterPeterName,
                           height: 50, text: $viewModel.petName)
        }
    }
    private var comfirmButtonView: some View {
        Button(action: {
            if UserSessionManager.shared.accessToken.isNotEmpty {
                if viewModel.selectedService.isNotEmpty {
                    viewModel.clinicPayment()
                }
                else {
                    ToastCenter.shared.showToast("Please select a service")
                }
               
            }
            else {
                self.viewModel.showLoginRequiredAlert = true
            }
        }, label: {
            Text(TextResource.confirm)
                .primaryButtonStyle(fullWidth: true,cornerRadius: 20)
        })
        .padding(.horizontal,30)
        .padding(.bottom,20)
    }
}


