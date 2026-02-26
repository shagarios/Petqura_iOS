//
//  ClinicCoordinator.swift
//  PawWalker
//
//  Created by shagar on 08/11/25.
//

import SwiftUI
enum ClinicPages : Hashable {
    case clinicList
    case clinicDetail(clinic: Clinic?)
    case slotBooking(clinicId: String,serviceList : [Service])
    case appointmentDetails(appointmentData : AppointmentData?,
                            clinicData: ClinicData?,docterData: DocterData?,
                            fromAppointMent: Bool,serviceList: [Service])
}

class ClinicCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    weak var appCoordinator: AppCoordinator?
    func push(_ page: ClinicPages) {
        path.append(page)
    }
    func pop() {
        path.removeLast()
    }
    func popToRoot() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func build(page: ClinicPages) -> some View {
        switch page {
        case .clinicList:
               makeClinicListView()
        case .clinicDetail(let clinic):
             makeClinicDetailView(clinic: clinic)
        case .slotBooking(let clinicId,let serviceList):
            makeSlotBookingView(clinicId: clinicId,serviceList: serviceList)
        case .appointmentDetails(let appointmentData, let clinicData, let docterData,
                                 let fromAppointMent,let serviceList):
             makeAppointmentDetailsScreen(appointmentData: appointmentData,
                                          clinicData: clinicData, docterData: docterData, fromAppointment: fromAppointMent,serviceList: serviceList)
        }
    }
    func makeClinicListView()  -> ClinicListScreen {
        return ClinicListScreen(coordinator: self)
    }
    func makeClinicDetailView(clinic : Clinic?) -> ClinicDetailScreen {
        let viewModel = ClinicDetailScreenViewModel(clinic: clinic)
        viewModel.coordinator = self
       return ClinicDetailScreen(viewModel: viewModel)
    }
    func makeSlotBookingView(clinicId : String,serviceList: [Service]) -> SlotBookingScreen {
        return SlotBookingScreen(coordinator: self, clinicId: clinicId, serviceList: serviceList)
    }
    func makeAppointmentDetailsScreen(appointmentData : AppointmentData?,clinicData: ClinicData?,docterData: DocterData?,
                                      fromAppointment : Bool = false,serviceList : [Service]) -> AppointmentDetailsScreen {
        let viewModel = AppointmentDetailsViewModel(appointmentData: appointmentData,
                                                    clinicData: clinicData, docterData: docterData,fromMyAppointmet: fromAppointment, serviceList: serviceList)
        viewModel.coordinator = self
        return AppointmentDetailsScreen(viewModel: viewModel)
    }
  
}

extension ClinicCoordinator: SlotBookingNavigation {
   
    func navigateToAppointmentDetails(appointmentData: AppointmentData?, clinicData: ClinicData?, docterData: DocterData?,serviceList: [Service]) {
        self.push(.appointmentDetails(appointmentData: appointmentData, clinicData: clinicData, docterData: docterData, fromAppointMent: false,serviceList: serviceList))
    }
    
    func navigateToSlotBooking(clinicId: String,serviceList: [Service]) {
        self.push(.slotBooking(clinicId: clinicId, serviceList: serviceList))
    }
}

