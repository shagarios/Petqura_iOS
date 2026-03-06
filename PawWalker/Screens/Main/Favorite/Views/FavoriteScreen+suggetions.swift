//
//  FavoriteScreen+suggetions.swift
//  PawWalker
//
//  Created by shagar on 05/03/26.
//

import Foundation
import SwiftUI

extension FavoriteScreen {
    
    var suggetionNameView : some View {
        HStack {
            Text("Add to Favorites?")
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(Color.black)
                .padding(.leading,10)
            Spacer()
        }
    }
    
    var clinicSuggetionListView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach($viewModel.suggetionClinicList,
                        id: \.clinicID) {$clinic in
                    ClinicItemView(viewModel: viewModel, clinic: clinic, completionHandler: { id in
                        if let clinicId = id {
                            self.viewModel.selectedClinicId = clinicId
                           // self.viewModel.navigateToSlotBooking = true
                          //  viewModel.coordinator?.push(.slotBooking(clinicId: clinicId, serviceList: clinic.services ?? []))
                        }
                    }, loginRequiredHandler: {
                    
                    }, addToFavoriteHandler: {
                        viewModel.fetchClnicFavorites()
                        viewModel.fetchClinicSuggetions()
                        
                    })
                    .padding(.leading,15)
                    .environmentObject(viewModel)
                    .onTapGestureForced {
                        //self.viewModel.coordinator?.push(.clinicDetail(clinic: clinic))
                    }
                    .onAppear {
                        if viewModel.suggetionClinicList.last?.clinicID == clinic.clinicID
                            && viewModel.hasNextClinicSuggention {
                            self.viewModel.suggetionsPage += 1
                            viewModel.fetchClinicSuggetions()
                        }
                    }
                }
            }
        }
    }
}
