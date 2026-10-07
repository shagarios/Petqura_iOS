//
//  MyAddressListViewModel.swift
//  PawWalker
//
//  Created by shagar on 26/02/25.
//
import SwiftUI
import Combine

class MyAddressListViewModel : ObservableObject {
    @Injected var apiClient : ApiClientProtocol
    @Published var isLoading : Bool = false
    var cancellable = Set<AnyCancellable>()
    @Published var addressList : [Address] = []
    @Published var navigateToNewAddress : Bool = false
    @Published var selectedId : String = TextResource.empty
    @Published var navidateToEditAddess : Bool = false
    @Published var selectedAddress : Address?
    @Injected var internet : NetworkMonitor
    weak var coordinator : AccountCoordinator?
    @Published var showMakeAsPrimaryAlert : Bool = false
    init(coordinator : AccountCoordinator?) {
        self.coordinator = coordinator
    }
    
    func getAddressList() {
        if Connectivity.isConnectedToInternet {
            isLoading = true
            apiClient.APIRequest(router: .getAddress, responseType: MyAdressListModel.self).sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.isLoading = false
                    break
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                if let result = response.result {
                    self?.addressList = result
                }
                else {
                    self?.addressList = []
                }
                //            if result.count > 0 {
                //                self?.addressList = result
                //            }
            }
            .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }

    }
    
    func handleAddressActions(address : Address, action : AddressActionType) {
        switch action {
        case .makePrimary:
            selectedAddress = address
            showMakeAsPrimaryAlert = true
            break
        case .edit:
            editAddress(addrress: address)
            break
        case .delete:
            if let id = address.id {
                deleteAdress(id: id)
            }
           break
        }
    }
    
    func deleteAdress(id : String) {
        if Connectivity.isConnectedToInternet {
            self.isLoading = false
            apiClient.APIRequest(router: .deleteAddress(id: id), responseType: SimpleResponse.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        if let errorMessage = error.backendError?.message {
                            ToastCenter.shared.showToast(errorMessage,type: .error)
                        }
                        
                    }
                } receiveValue: { [weak self] response in
                    self?.isLoading = false
                    self?.getAddressList()
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
    func editAddress(addrress : Address) {
        self.selectedAddress = addrress
        coordinator?.push(.location(isAccountRelated: true, address: addrress))
      // coordinator?.push(.addNewAddress(isEdit: true, address: selectedAddress))
    }
    func makeAsPrimary(address : Address) {
        if internet.isConnectedToInternet {
            var param = getParams(address: address)
            param[ApiParameters.id] = address.id
            self.isLoading = false
            apiClient.APIRequest(router: .editAddress,parameters: param ,responseType: AddressModel.self)
                .sink {[weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        if let errorMessage = error.backendError?.message {
                            ToastCenter.shared.showToast(errorMessage,type: .error)
                        }

                    }
                } receiveValue: { response in
                    if let result = response.result {
                        self.isLoading = false
                        ToastCenter.shared.showToast(TextResource.primaryAddressAlert,type: .success)
                        self.getAddressList()
                    }
                    else {
                        self.isLoading = false
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
    func getParams (address : Address) -> [String : Any] {
        let param : [String : Any] = [ApiParameters.fullname : address.fullname ?? "",
                                      ApiParameters.address : address.address ?? "",
                                      ApiParameters.pin : address.pin ?? "",
                                      ApiParameters.address_type : address.addressType ?? "",
                                      ApiParameters.city : address.city ?? "",
                                      ApiParameters.phone : address.phone ?? "",
                                      ApiParameters.state : address.state ?? "",
                                      ApiParameters.email : address.email ?? "",
                                      ApiParameters.defaultAddress : true
        ]
        return param
    }
}


