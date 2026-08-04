//
//  HomeScreenViewModel+Review.swift
//  PawWalker
//
//  Created by shagar on 07/03/26.
//

extension HomeScreenViewModel {
    func submitReviewToServer() {
        if Connectivity.isConnectedToInternet {
            var param : [String: Any] = [ApiParameters.clinicId : self.pendingReview?.entityId ?? TextResource.empty]
            param[ApiParameters.reviewContent] = self.clinicReviewText
            param[ApiParameters.reviewStarCount] = self.clinicRating
            param[ApiParameters.pendingReviewId] = self.pendingReview?.id ?? TextResource.empty
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
                } receiveValue: {[weak self] response in
                    self?.isLoading = false
                    self?.showClinicReviewBottomSheet = false
                    self?.clinicRating = 0
                    self?.clinicReviewText = ""
                    ToastCenter.shared.showToast(response.message ?? TextResource.empty,type: .success)
                    Task {
                      await self?.fetchHomeDetails()
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func closeReviewSheet() {
        if Connectivity.isConnectedToInternet {
            self.showClinicReviewBottomSheet = false
            guard let id = self.pendingReview?.id else {return}
            let param : [String: Any] = [ApiParameters.id : id]
            apiClient.APIRequest(router: .closeClinicReview,parameters: param ,responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        ToastCenter.shared.showToast(error.backendError?.message ?? "There is an error occured while adding review",type: .error)
                        break
                    }
                } receiveValue: { [weak self] response in
                    print(response)
                    self?.clinicRating = 0
                    self?.clinicReviewText = ""
                    Task {
                        await self?.fetchHomeDetails()
                    }
                }
                .store(in: &cancellables)

        }
    }
}
