//
//  FavoriteCoordinator.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//

import SwiftUI
enum FavoritePage : Hashable {
    case favoritePage
//    case slotBooking(clinicId: String)
//    case appointMentDetailsScreen(appointmentData : AppointmentData?,
//                                  clinicData: ClinicData?,docterData: DocterData?,
//                                  serviceList: [Service])
}

class FavoriteCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    weak var appCoordinator: AppCoordinator?
    func push(_ page: FavoritePage) {
        path.append(page)
    }
    func pop() {
        path.removeLast()
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: FavoritePage) -> some View {
        switch page {
        case .favoritePage:
            FavoriteScreen(coordinator: self)
//        case .slotBooking(let clinicId):
//            makeSlotBookingView(clinicId: clinicId)
//        case .appointMentDetailsScreen(appointmentData: let appointmentData, clinicData: let clinicData, docterData: let docterData,let serviceList):
//            makeAppointmentDetailsScreen(appointmentData: appointmentData, clinicData: clinicData, docterData: docterData,serviceList: serviceList)
        }
    }
    
//    func makeAppointmentDetailsScreen(appointmentData : AppointmentData?,clinicData: ClinicData?,docterData: DocterData?,serviceList: [Service]) -> AppointmentDetailsScreen {
//        let viewModel = AppointmentDetailsViewModel(appointmentData: appointmentData,
//                                                    clinicData: clinicData,
//            docterData: docterData, serviceList: serviceList)
//        viewModel.coordinator = self
//        return AppointmentDetailsScreen(viewModel: viewModel)
//    }
//    func makeSlotBookingView(clinicId : String) -> SlotBookingScreen {
//        return SlotBookingScreen(coordinator: self, clinicId: clinicId, serviceList: [])
//    }
}

//extension FavoriteCoordinator: SlotBookingNavigation {
//    func navigateToSlotBooking(clinicId: String, serviceList: [Service]) {
//        self.push(.slotBooking(clinicId: clinicId))
//    }
//    
//    func navigateToAppointmentDetails(appointmentData: AppointmentData?, clinicData: ClinicData?, docterData: DocterData?, serviceList: [Service]) {
//        self.push(.appointMentDetailsScreen(appointmentData: appointmentData, clinicData: clinicData, docterData: docterData,serviceList: serviceList))
//    }
    
//}
