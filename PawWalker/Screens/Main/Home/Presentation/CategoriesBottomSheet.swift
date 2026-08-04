//
//  CategoriesBottomSheet.swift
//  PawWalker
//
//  Created by shagar on 21/03/25.
//

import SwiftUI

struct CategoriesBottomSheet: View {
    let column: [GridItem] = [GridItem(.fixed(150),spacing: 20),
                              GridItem(.fixed(150),spacing: 20)]
    var categories : [Category]
    var completion : (Category) -> ()
    var body: some View {
        categoriesList
            .padding(.bottom,80)
    }
    private var categoriesList : some View {
        ScrollView(.vertical,showsIndicators: false) {
            LazyVGrid(columns: column) {
                ForEach(categories,id: \.id) {category in
                    ServiceCellView(name: category.categoryName ?? TextResource.empty,
                                    image: category.icon ?? TextResource.empty)
                    .onTapGesture {
                        completion(category)
                    }
                    .padding(.top,10)
                }
            }
        }
    }
}
