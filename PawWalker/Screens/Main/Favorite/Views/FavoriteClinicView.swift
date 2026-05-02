//
//  FavoriteClinicView.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI

struct FavoriteClinicView : View {
    var clinic : FavoriteClinic
    var appointmentCallBack : (String) -> ()
    var deleteCallback : (FavoriteClinic) -> ()
    var body: some View {
        HStack(spacing: 20){
            imageView
            detailsView
        }
        .padding(.bottom,10)
    }
    
    private var imageView : some View {
        ImageURLView(url: clinic.clinicImage ?? TextResource.empty,
                     placeHolderImage: ImageName.clinicPlaceHolder,placeHolderSize: (90,90))
            .frame(width : 90, height: 90)
            .itemBorderStyle(radius : 20)
    }
    private var detailsView : some View {
        VStack {
            HStack {
                Text(clinic.clinicName ?? "")
                    .font(FontConstants.primaryMediumTitle12)
                Spacer()
                favoriteView
            }
            HStack{
                Spacer()
                Button(action: {
                    appointmentCallBack(clinic.clinicID ?? "")
                }, label: {
                    Text(TextResource.bookAppointment)
                        .foregroundStyle(.white)
                        .font(FontConstants.primaryRegularTitle11)
                        .makeBackgroundView(color: Color(ColorResource.primaryButton),horizontalPadding: 10,
                        verticalPadding: 5,radius: 5)
                })
            }
        }
    }
    private var favoriteView : some View {
        Button(action: {
            deleteCallback(clinic)
        }, label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color(ColorResource.favoriteWhite))
                    .frame(width: 36,height: 36)
                Image(.favoriteFilledIcon)
            }
        })
       
    }
}
