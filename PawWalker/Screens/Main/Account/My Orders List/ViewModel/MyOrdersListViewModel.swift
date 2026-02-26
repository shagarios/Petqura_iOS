//
//  MyOrdersListViewModel.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI
import Combine

class MyOrdersListViewModel : ObservableObject {
    @Published var myOrderList : [MyOrder] = []
    @Injected var apiClient : ApiClientProtocol
    var cancellable = Set<AnyCancellable>()
    @Published var isLoading : Bool = false
    
    func fetchMyordersList() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .myOrders, responseType: MyOrdersModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.myOrderList = result.orders
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
}
