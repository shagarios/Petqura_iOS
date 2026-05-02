//
//  ClinicDetailScreenViewModel.swift
//  PawWalker
//
//  Created by shagar on 21/01/25.
//

import SwiftUI
import Combine

class ClinicDetailScreenViewModel : ObservableObject {
    @Published var clinic : Clinic?
    @Published var isFavorite : Bool = false
    @Published var selectedSegment : ClinicSegment = .services
    @Published var doctersList : [Doctor] = []
    @Published var navigateToSlotBooking : Bool = false
    @Published var serviceList : [Service] = []
    @Published var reviewList: [ClinicReview] = []
    @Injected var apiClient : ApiClientProtocol
    @Injected var internet : NetworkMonitor
    @Published var reviewText : String = TextResource.empty
    @Published var reviewRating : Double = 0
    @Published var showReviewBottomSheet : Bool = false
    @Published var averageReviewRating: Double = 0
    @Published var isLoading: Bool = false
    weak var coordinator: ClinicCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    init(clinic : Clinic?) {
        self.clinic = clinic
        self.doctersList = clinic?.doctors ?? []
        self.serviceList = clinic?.services ?? []
       
    }
    func getAddress() -> String {
        let address1 = (clinic?.clinicAddressLine1 ?? "") + ", "
        let address2 = (clinic?.clinicAddressLine2 ?? "") + ", "
        let clinicCity = (clinic?.clinicCity ?? "") + ", "
        let clinicState = (clinic?.clinicState ?? "") + ", "
        let pinCode = (clinic?.clinicPincode ?? "") 
        return address1 + address2 + clinicCity + clinicState + pinCode
    }
    func fetchReviews () async {
        if internet.isConnectedToInternet {
            apiClient.APIRequest(router: .clinicReview(clinicId: clinic?.clinicID ?? ""),
                                 responseType: ClinicReviewModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        break
                    }
                } receiveValue: { response in
                    if let result = response.result {
                        self.reviewList = result.reviews
                        self.averageReviewRating = result.averageRating ?? 0
                    }
                }
                .store(in: &cancellables)
        }
    }
    func submitReviewToServer() {
        if Connectivity.isConnectedToInternet {
            var param : [String: Any] = [ApiParameters.clinicId : self.clinic?.clinicID ?? TextResource.empty]
            param[ApiParameters.reviewContent] = self.reviewText
            param[ApiParameters.reviewStarCount] = self.reviewRating
           isLoading = true
            apiClient.APIRequest(router: .addClinicReview, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? "There is an error occured while adding review",type: .error)
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(response.message ?? TextResource.empty,type: .success)
                    Task {[weak self] in
                        await self?.fetchReviews()
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func navigateToSlotBookingScreen() {
        guard let clinicId = clinic?.clinicID else {return}
        coordinator?.push(.slotBooking(clinicId: clinicId, serviceList: serviceList))
    }
    func dismiss() {
        coordinator?.pop()
    }

}

enum ClinicSegment : String {
    case services = "Services"
    case docters = "Doctors"
    case reviews = "Reviews"
}
