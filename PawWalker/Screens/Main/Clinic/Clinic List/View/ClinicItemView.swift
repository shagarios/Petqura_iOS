//
//  ClinicItemView.swift
//  PawWalker
//
//  Created by shagar on 09/05/25.
//

import SwiftUI

struct ClinicItemView : View {
    @EnvironmentObject var viewModel : ClinicListViewModel
    @State var isFavorite : Bool = false
    var clinic : Clinic
    var completionHandler : (String?) -> ()
    var loginRequiredHandler: () -> ()
    var body: some View {
        VStack {
            imageView
            nameView
           // locationView
            appoinmentButton
        }
        .onAppear{
            self.isFavorite = self.clinic.isfavorite ?? false
        }
            }
    private var imageView : some View {
        VStack {
            ImageURLView(url: clinic.clinicImage ?? TextResource.empty)
                .frame(width: 130,height: 130)
        }
        .overlay(alignment: .topTrailing, content: {
            favoriteView
            .padding(.top,5)
            .padding(.trailing,5)
            
        })
        .itemBorderStyle()
    }
    
    private var favoriteView : some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(ColorResource.favoriteWhite))
                .frame(width: 36,height: 36)
            Image(self.isFavorite ? .favoriteFilledIcon : .favoriteIcon)
        }
        .onTapGesture {
            if UserSessionManager.shared.accessToken.isNotEmpty {
                if isFavorite == true {
                    if let clinicId = clinic.clinicID,clinicId.isNotEmpty {
                        viewModel.deleteFavorite(clinicId: clinicId) { status in
                            if status {
                                self.isFavorite = false
                            }
                        }
                    }
                }
                else {
                    if let clinicId = clinic.clinicID,clinicId.isNotEmpty {
                        viewModel.addToFavorite(clinicId: clinicId) { status in
                            if status {
                                self.isFavorite = true
                            }
                        }
                    }
                }
            }
            else {
                viewModel.showLoginRequiredAlert = true
            }
        }
        
    }
    private var nameView : some View {
        HStack(spacing: 0) {
            Text(clinic.clinicName ?? "")
                .font(FontConstants.primaryMediumTitle12)
                .lineLimit(1)
            Spacer()
        }
     
    }
    private var locationView : some View {
        HStack(spacing: 0) {
            Image(.currentLocationPin)
                .resizable()
                .frame(width : 13, height: 15)
            Text(clinic.clinicAddressLine1 ?? "")
                .font(FontConstants.primaryRegularTitle12)
                .padding(.leading,5)
                .lineLimit(1)
                .foregroundStyle(Color(.darkGray))
            Spacer()
        }
    }
    private var appoinmentButton : some View {
        Button {
            completionHandler(clinic.clinicID)
        } label: {
            Text(TextResource.bookAppointment)
                .primaryButtonStyle(height: 33,font: FontConstants.primaryMediumTitle12,fullWidth: true,cornerRadius: 15)
        }

    }
    func isFavoriteClinic() -> Bool {
        return clinic.isfavorite ?? false
    }
}
