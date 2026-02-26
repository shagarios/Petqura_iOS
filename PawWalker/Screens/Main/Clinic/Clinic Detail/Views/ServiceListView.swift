//
//  ServiceListView.swift
//  PawWalker
//
//  Created by shagar on 30/01/25.
//

import SwiftUI

extension ClinicDetailScreen {
    var serviceListView: some View {
        ScrollView {
            LazyVGrid(columns: colomns,alignment: .leading) {
                ForEach(viewModel.serviceList,id: \.serviceID) { service in
                    ServiceItemView(serviceName: service.service ?? TextResource.empty,
                                    serviceImage: service.icon ?? TextResource.empty)
                        .padding(.top,20)
                    
                }
            }
        }
    }
}

struct ServiceItemView : View {
    var serviceName : String
    var serviceImage : String
    var height : CGFloat = 180
    var body: some View {
        ZStack{
            VStack{
                imageView
                    .gradientBorderStyle(shadowRadius : 3,bottomShadow: 0)
                textView
            }
        }
    }
    
    @ViewBuilder
   private var imageView : some View {
       if serviceImage.isNotEmpty {
           ImageURLView(url: serviceImage)
               .frame(width: 100, height: 100)
       }
       else {
           Image(ImageResource.service)
               .resizable()
               .scaledToFit()
               .frame(width: 100, height: 100)
       }
    }
    
    private var textView : some View {
        Text(serviceName)
            .font(FontConstants.primaryMediumTitle14)
    }
}
