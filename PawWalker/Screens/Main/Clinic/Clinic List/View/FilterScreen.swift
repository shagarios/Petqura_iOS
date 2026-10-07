//
//  FilterScreen.swift
//  PawWalker
//
//  Created by Sathya S on 25/02/26.
//

import SwiftUI

import SwiftUI

struct ClinicFilterBottomSheet: View {
    @ObservedObject var viewModel: ClinicListViewModel
    var onApply: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            /// HEADER
            HStack {
                Text("Filters")
                    .font(.headline)
                Spacer()
                Button("Clear All") {
                    viewModel.makeClearAllTemporary()
                }
                .foregroundColor(.red)
            }
            .padding()
            Divider()
            /// FILTER CONTENT
            HStack(spacing: 0) {
                filterTypeList
                Divider()
                filterItemsList
            }
            Divider()
            /// BOTTOM BUTTONS
//            HStack(spacing: 0) {
//                Button("Close") {
//                    viewModel.showFilterList = false
//                }
//                Spacer()
//                Button("Apply") {
//                    onApply()
//                }
//                .foregroundColor(.red)
//            }
//            .padding()
            Button(action: {
                onApply()
            }, label: {
                Text("Apply")
                    .primaryButtonStyle(fullWidth: true)
                    .padding(.horizontal,20)
            })
            .padding(.vertical,20)
        }
        .onAppear {
            viewModel.getFliterData()
            viewModel.checkInitialData()
        }
    }
}

extension ClinicFilterBottomSheet {
    var filterTypeList: some View {
        List(viewModel.filters) { filter in
            HStack(spacing: 0) {
                Text(filter.name ?? "")
                    .font(FontConstants.primaryRegularTitle14)
                if filter.hasDot {
                    dotView
                        .padding(.leading,5)
                }
            }
            .foregroundColor(
                viewModel.selectedFilter?.id == filter.id
                ? .black : .gray
            )
            .contentShape(Rectangle())
            .onTapGestureForced {
                viewModel.selectedFilter = filter
            }
        }
        .listStyle(.plain)
        .frame(width: 150)
    }
    var dotView : some View {
        Circle()
            .frame(width: 8,height: 8)
            .foregroundStyle(.primaryButton)
    }
}


extension ClinicFilterBottomSheet {
    
    var filterItemsList: some View {
        List {
            ForEach(
                viewModel.selectedFilter?.displayItems ?? []
            ) { item in
                HStack(spacing: 0) {
                    Text(item.name ?? "")
                        .font(FontConstants.primaryRegularTitle14)
                    Spacer()
                    Image(systemName:
                            viewModel.selectedItems.contains(item)
                          ? "checkmark.square.fill"
                          : "square"
                    )
                }
                .contentShape(Rectangle())
                .onTapGestureForced {
                    guard let type = viewModel.selectedFilter?.type else {return}
                    viewModel.toggleItem(item,type: type)
                }
            }
        }
        .listStyle(.plain)
    }
}
