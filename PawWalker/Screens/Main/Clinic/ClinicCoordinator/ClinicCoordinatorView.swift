//
//  ClinicCoordinatorView.swift
//  PawWalker
//
//  Created by shagar on 08/11/25.
//

import SwiftUI

struct ClinicCoordinatorView: View {
    @StateObject var coordinator  = ClinicCoordinator()
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .clinicList)
                .hideNavigationBar()
                .navigationDestination(for: ClinicPages.self) { page in
                    coordinator.build(page: page)
                        .toolbar(.hidden, for: .tabBar)
                }
        }
        .onAppear {
            coordinator.appCoordinator = appCoordinator
            if coordinator.appCoordinator?.navigateToAppointmentDetailsScreen == true {
                coordinator.push(.appointmentDetails(appointmentData: nil,
                                                     clinicData: nil, docterData: nil,
                                                     fromAppointMent: true, serviceList: []))
            }
        }
    }
}
