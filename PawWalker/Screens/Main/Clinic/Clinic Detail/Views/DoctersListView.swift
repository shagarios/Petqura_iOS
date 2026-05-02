//
//  DoctersListView.swift
//  PawWalker
//
//  Created by shagar on 22/01/25.
//

import SwiftUI

extension ClinicDetailScreen {
    var doctersListView : some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.doctersList,id: \.doctorID) { docter in
                    DoctersItemView(docter: docter)
                        .padding(.top,10)
                }
            }
        }
    }
}

struct DoctersItemView: View {
    var docter : Doctor
    var body: some View {
        HStack{
            imageView
            detailsView
                .padding(.leading,12)
            Spacer()
        }
        .padding(.horizontal,15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(ColorResource.littleGray))
                .shadow(color: Color(ColorResource.shadowYellow), radius: 0.5,y: 2)
        )
    }
    @ViewBuilder
    private var imageView : some View {
        VStack{
            if let image = docter.profilePhoto {
                ImageURLView(url: docter.profilePhoto ?? "",isFill: true)
                    .frame(width: 50,height: 50)
                    .clipShape(Circle())
            }
            else {
                            Image(ImageResource.docterIcon)
                                .resizable()
                                .frame(width: 50,height: 50)
                                .clipShape(Circle())
            }
                
        }
    }
    private var detailsView : some View {
        VStack(alignment : .leading, spacing: 0) {
            Text(docter.doctorName ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle14)
                .padding(.top,10)
            doctersDiscriptions(text: docter.description)
            doctersDiscriptions(text: docter.qualifications)
                .padding(.bottom,10)
               
        }
    }
    
    func doctersDiscriptions(text : String?) -> some View {
        Text(text ?? TextResource.empty)
            .font(FontConstants.primaryRegularTitle12)
            .foregroundStyle(Color(ColorResource.darkGray))
            .padding(.top,5)
    }
}

