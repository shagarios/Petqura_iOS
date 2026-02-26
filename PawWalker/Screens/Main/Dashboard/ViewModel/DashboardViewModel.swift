//
//  DashboardViewModel.swift
//  PawWalker
//
//  Created by shagar on 08/12/24.
//
import SwiftUI
import Combine

class DashboardViewModel : ObservableObject {
    @Published var selection : TabBarItems = .home
    @Published var cartItemCount : Int = 0
    @Published var selectedCategoryId : String = TextResource.empty
    @Published var selectedServiceId : String = TextResource.empty
    private var cancellable = Set<AnyCancellable>()
    @Published var navigateToCart : Bool = false
    @Published var navigateToMyorder = false
    @Published var naviagateToMyAppointment = false
    @Injected var apiClient : ApiClientProtocol
    
    init() {
      //  handleCartCountUpdate()
    }
 
   
}

// EventHandler.cartCountSubject.send(cartCount)
