//
//  Clinic+Views.swift
//  PawWalker
//
//  Created by shagar on 31/05/25.
//

import SwiftUI
extension ClinicListScreen {
     
    var clinicListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: colomns, alignment: .leading) {
                ForEach(viewModel.searchText.isEmpty ? $viewModel.clinicList : $viewModel.filteredClinicList,
                        id: \.clinicID) {$clinic in
                    ClinicItemView(viewModel: viewModel, clinic: clinic, completionHandler: { id in
                        if let clinicId = id {
                            self.viewModel.selectedClinicId = clinicId
                           // self.viewModel.navigateToSlotBooking = true
                            viewModel.coordinator?.push(.slotBooking(clinicId: clinicId, serviceList: clinic.services ?? []))
                        }
                    }, loginRequiredHandler: {
                        viewModel.showLoginRequiredAlert = true
                    }, addToFavoriteHandler: {
                        
                    })
                    .padding(.leading,20)
                    .environmentObject(viewModel)
                    .onTapGestureForced {
                        self.viewModel.coordinator?.push(.clinicDetail(clinic: clinic))
                    }
                    .onAppear {
                        if let lastClinicId = viewModel.clinicList.last?.clinicID,
                           lastClinicId == clinic.clinicID && viewModel.hasNext {
                            self.viewModel.page += 1
                            viewModel.fetchClinicList(serviceId: "")
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 80)
        }
    }
}
