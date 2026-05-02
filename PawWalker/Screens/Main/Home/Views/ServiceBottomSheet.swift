//
//  ServiceBottomSheet.swift
//  PawWalker
//
//  Created by shagar on 18/03/25.
//

import SwiftUI

struct ServiceBottomSheet: View {
    let column: [GridItem] = [GridItem(.fixed(150),spacing: 20),
                              GridItem(.fixed(150),spacing: 20)]
    var services : [Services]
    var completion : (Services) -> ()
    var body: some View {
        serviceListView
            .padding(.bottom,80)
    }
    private var serviceListView : some View {
        ScrollView(.vertical,showsIndicators: false) {
            LazyVGrid(columns: column) {
                ForEach(services,id: \.id) { service in
                    ServiceCellView(
                        name: service.title ?? TextResource.empty,
                        image: service.icon ?? TextResource.empty
                    )
                    .padding(.leading,10)
                    .padding(.top,10)
                    .onTapGesture {
                        completion(service)
                    }
                }
            }
        }
    }
}

