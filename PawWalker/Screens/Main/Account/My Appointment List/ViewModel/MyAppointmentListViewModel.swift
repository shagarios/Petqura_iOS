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
    @Published var page : Int = 1
    @Published var hasNext : Bool = false
    
    func getAppointments() {
        if Connectivity.isConnectedToInternet {
            if page == 1 {
                myAppointmentList.removeAll()
            }
            self.isLoading = true
            apiClient.APIRequest(router: .myAppointments(page: self.page), responseType: MyAppointmentModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self.isLoading = false
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    self.myAppointmentList.append(contentsOf: response.result?.appointments ?? [])
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
}
