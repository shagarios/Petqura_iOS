//
//  MyAppointmentListViewModel.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI
import Combine
class MyAppointmentListViewModel : ObservableObject {
    @Published var myAppointmentData : [MyAppointmentData] = []
    @Injected var apiClient : ApiClientProtocol
    @Published var isLoading : Bool = false
    @Published var myAppointmentList : [MyAppointments] = []
    var cancellable = Set<AnyCancellable>()
    
    func getAppointments() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .myAppointments, responseType: MyAppointmentModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self.isLoading = false
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    self.myAppointmentList = response.result?.appointments ?? []
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
}
