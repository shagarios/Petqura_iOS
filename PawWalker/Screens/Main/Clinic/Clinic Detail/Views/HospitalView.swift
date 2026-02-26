//
//  HospitalView.swift
//  PawWalker
//
//  Created by shagar on 05/02/25.
//

import SwiftUI

struct HospitalView: View {
    var clinic : ClinicData
    var body: some View {
        HStack {
            imageView
            addressView
            Spacer()
        }
    }
    private var imageView : some View {
            VStack {
                ImageURLView(url: self.clinic.image)
                    .frame(width: 130,height: 150)
            }
            .itemBorderStyle()
    }
    private var addressView : some View {
        VStack(alignment : .leading,spacing: 5) {
            Text(self.clinic.clinicName)
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(Color(ColorResource.priceGray))
            HStack(alignment: .top){
                Image(.addressIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12,height: 12)
                   
                Text(self.clinic.address)
                    .font(FontConstants.primaryRegularTitle11)
            }
            
            ClinicDataView(image: .phoneIcon, title: self.clinic.phoneNumber)
            
            ClinicDataView(image: .emailIcon, title: self.clinic.email)
               
        }
    }
}

struct ClinicDataView : View {
    var image : ImageResource
    var title : String
    var body: some View {
        HStack(spacing: 5){
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 12,height: 12)
            Text(title)
                .font(FontConstants.primaryRegularTitle11)
        }
    }
}
