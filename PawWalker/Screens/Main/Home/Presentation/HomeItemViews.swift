//
//  Home+Views.swift
//  PawWalker
//
//  Created by shagar on 14/05/25.
//
import SwiftUI

struct ServiceCellView : View {
    let name : String
    let image : String
    var body: some View {
        VStack(spacing: 0) {
            if image == TextResource.empty {
                Image(ImageResource.categoryPlaceHolder)
                    .frame(width : 100,height: 100)
                    .scaledToFit()
                    .gradientBorderStyle(shadowRadius : 3,bottomShadow: 0)
            }
            else {
                ImageURLView(url: image)
                    .frame(width : 100,height: 100)
                    .scaledToFit()
                    .gradientBorderStyle(shadowRadius : 3,bottomShadow: 0)
            }
            Text(name)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(ColorContants.dateGray)
                .padding(.top,5)
                .lineLimit(2)
        }
        
    }
}
struct BannerCaurouserView : View {
    let banners : [String]
    @State var currentIndex = 0
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(banners.indices,id: \.self) {index in
                ImageURLView(url: banners[index])
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height : 200)
    }
}

struct  SectionTitleView: View {
    var title : String
    var buttonName : String = TextResource.viewAll
    var completion : () -> ()
    var body : some View {
        HStack {
            Text(title.uppercased())
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(Color(ColorResource.primaryButton))
            Spacer()
            Button {
                completion()
            } label: {
                Text(TextResource.viewAll.uppercased())
                    .foregroundStyle(ColorContants.softYellow)
                    .font(FontConstants.primaryRegularTitle14)
            }

        }
        
    }
}
