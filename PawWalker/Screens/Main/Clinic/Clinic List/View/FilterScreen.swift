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
                    viewModel.getFliterData()
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
            HStack {

                Button("Close") {
                    viewModel.showFilterList = false
                }

                Spacer()

                Button("Apply") {
                    onApply()
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        .onAppear {
            viewModel.getFliterData()
        }
    }
}

extension ClinicFilterBottomSheet {

    var filterTypeList: some View {

        List(viewModel.filters) { filter in

            Text(filter.name)
                .foregroundColor(
                    viewModel.selectedFilter?.id == filter.id
                    ? .black : .gray
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedFilter = filter
                }
        }
        .listStyle(.plain)
        .frame(width: 150)
    }
}

extension ClinicFilterBottomSheet {

    var filterItemsList: some View {

        List {

            ForEach(
                viewModel.selectedFilter?.displayItems ?? []
            ) { item in

                HStack {

                    Text(item.name)

                    Spacer()

                    Image(systemName:
                        viewModel.selectedItems.contains(item)
                        ? "checkmark.square.fill"
                        : "square"
                    )
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleItem(item)
                }
            }
        }
        .listStyle(.plain)
    }
}
