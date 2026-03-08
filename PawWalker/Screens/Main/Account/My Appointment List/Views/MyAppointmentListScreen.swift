//
//  MyAppointmentListScreen.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI

struct MyAppointmentListScreen: View {
    @StateObject var viewModel = MyAppointmentListViewModel()
    weak var coordinator : AccountCoordinator?
    init(coordinator : AccountCoordinator) {
        self.coordinator = coordinator
    }
    var body: some View {
        ScrollView() {
            LazyVStack {
                ForEach(viewModel.myAppointmentList,id: \.appointmentId) { item in
                    MyAppointmentView(myAppointmentData: item)
                        .onTapGestureForced {
                            UserSessionManager.shared.appointmentId = item.appointmentId
                            coordinator?.appCoordinator?.navigateToAppointmentDetailsScreen = true
                        }
                        .onAppear {
                            if viewModel.myAppointmentList.last?.appointmentId
                                == item.appointmentId && viewModel.hasNext {
                                viewModel.page += 1
                                viewModel.getAppointments()
                            }
                        }
                }
            }
            .padding(.top,30)
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .task {
            viewModel.getAppointments()
        }
        .padding(.horizontal,20)
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.myAppointments),
                    leftButtons: ViewUtils.shared.backButtonView {
            coordinator?.pop()
        })
    }
}
