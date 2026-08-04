////
////  ProductCoordinatorView.swift
////  PawWalker
////
////  Created by shagar on 21/07/26.
////
//
//import SwiftUI
//
//struct ProductCoordinatorView: View {
//    @StateObject var coordinator  = ProductCoordinator()
//    @EnvironmentObject var appCoordinator: AppCoordinator
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.path) {
//            coordinator.build(page: .productListing)
//                .hideNavigationBar()
//                .navigationDestination(for: ProductPages.self) { page in
//                    coordinator.build(page: page)
//                        .toolbar(.hidden, for: .tabBar)
//                }
//        }
//        .onAppear {
//            coordinator.appCoordinator = appCoordinator
//            //            if coordinator.appCoordinator?.navigateToAppointmentDetailsScreen == true {
//            //                coordinator.push(.appointmentDetails(appointmentData: nil,
//            //                                                     clinicData: nil, docterData: nil,
//            //                                                     fromAppointMent: true, serviceList: []))
//            //            }
//            //            else if coordinator.appCoordinator?.navigateToSlotBookingScreen == true {
//            //                coordinator.push(.slotBooking(clinicId: appCoordinator.selectedClinicId,
//            //                                              serviceList: appCoordinator.serviceList))
//            //                coordinator.appCoordinator?.navigateToSlotBookingScreen = false
//            //            }
//            //        }
//        }
//    }
//}
