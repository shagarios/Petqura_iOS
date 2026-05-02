//
//  ClinicDetailScreen.swift
//  PawWalker
//
//  Created by shagar on 21/01/25.
//
import Kingfisher
import SwiftUI

struct ClinicDetailScreen : View {
    @StateObject var viewModel : ClinicDetailScreenViewModel
    let colomns : [GridItem] = [GridItem(.flexible(minimum: 120, maximum: 160),spacing: 20),
                                GridItem(.flexible(minimum: 120, maximum: 160))]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var serviceId : String = ""
    var cancellCallBack : (String) -> () = { _ in }
    var body : some View {
        VStack (spacing: 0){
        ScrollView(showsIndicators: false) {
            VStack (spacing : 0){
                headerView
                    .padding(.leading,10)
                VStack(spacing: 0) {
                    ratingView
                    segmentView
                        .padding(.top,15)
                    if viewModel.selectedSegment == .docters {
                        doctersListView
                            .padding(.top,10)
                    }
                    else if viewModel.selectedSegment == .services {
                        serviceListView
                            .padding(.top,10)
                    }
                    else if viewModel.selectedSegment == .reviews {
                        reviewView
                            .padding(.top,10)
                    }
                }
                .padding(.horizontal,15)
            }
           

        }
        .task {
            await viewModel.fetchReviews()
            
        }
        .customPopupAlertView(
            alertView: ProductReviewAlert(
                placeHolder:TextResource.clinicReviewCaption,
                sumbitAction: {reviewText,rating in
                    self.viewModel.reviewText = reviewText
                    self.viewModel.reviewRating = Double(rating)
                    viewModel.submitReviewToServer()
                    self.viewModel.showReviewBottomSheet = false
                },
                closeAction: {
                    self.viewModel.showReviewBottomSheet = false
                }
            ),
            showAlert: $viewModel.showReviewBottomSheet
        )
        Spacer()
        appointmentButton
            .padding(.bottom,30)
    }
        .topBarView(titleView: ViewUtils.shared.titleView(title: "Clinic Details"),
                leftButtons: ViewUtils.shared.backButtonView(action: {
           // self.mode.wrappedValue.dismiss()
            viewModel.dismiss()
            cancellCallBack(serviceId)
        }))
        .makeWithLoader(isLoading: $viewModel.isLoading)
    
}
    private var headerView : some View {
        HospitalView(clinic: ClinicData(clinicName:viewModel.clinic?.clinicName ?? TextResource.empty,
                                        image: self.viewModel.clinic?.clinicImage ?? TextResource.empty,
                                        address:   self.viewModel.getAddress(),
                                        phoneNumber:  self.viewModel.clinic?.phone ?? TextResource.empty,
                                        email: self.viewModel.clinic?.email ?? TextResource.empty,
                                        clinicId: self.viewModel.clinic?.clinicID ?? TextResource.empty))
        .padding(.bottom,10)
        .padding(.top,15)
    }
 
    private var favoriteView : some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(ColorResource.favoriteWhite))
                .frame(width: 36,height: 36)
            Image(viewModel.isFavorite ? .favoriteFilledIcon : .favoriteIcon)
        }
        .onTapGesture {
            viewModel.isFavorite.toggle()
        }
    }
    
    private var segmentView : some View {
        HStack {
            SegmentView(name: ClinicSegment.services.rawValue, isSelected: viewModel.selectedSegment == .services) {
                self.viewModel.selectedSegment = .services
            }
            SegmentView(name: ClinicSegment.docters.rawValue, isSelected: viewModel.selectedSegment == .docters) {
                self.viewModel.selectedSegment = .docters
            }
            SegmentView(name: ClinicSegment.reviews.rawValue, isSelected: viewModel.selectedSegment == .reviews) {
                self.viewModel.selectedSegment = .reviews
            }
            Spacer()
        }
    }
    private var appointmentButton : some View {
        Button {
           // self.viewModel.navigateToSlotBooking = true
            viewModel.navigateToSlotBookingScreen()
        } label: {
            Text(TextResource.bookAnAppointment)
                .primaryButtonStyle(height: 48,font: FontConstants.primaryMediumTitle14,fullWidth: true,cornerRadius: 20)
                .padding(.horizontal,30)
        }
        
    }
}

