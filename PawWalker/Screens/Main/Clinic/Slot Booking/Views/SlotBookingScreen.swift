//
//  SlotBookingScreen.swift
//  PawWalker
//
//  Created by shagar on 26/01/25.
//

import SwiftUI

struct SlotBookingScreen: View {
    @StateObject var viewModel : SlotBookingViewModel
    
    init(coordinator : SlotBookingNavigation?,clinicId: String,serviceList: [Service]) {
        _viewModel = StateObject(wrappedValue: SlotBookingViewModel(clinicId: clinicId, coordinator: coordinator,serviceList: serviceList))
    }
    var body: some View {
            VStack{
                slotBookingHeader
                if viewModel.slotList.isEmpty {
                    emptySlotView
                }
                else {
                    slotView
                }
            }
            .padding(.horizontal,PaddingConstants.layoutHorizontal)
        .topBarView(titleView: ViewUtils.shared.titleView(title: viewModel.clinicData?.clinicName ?? ""),
                    leftButtons: ViewUtils.shared.backButtonView(action: {
            viewModel.coordinator?.pop()
        }))
        .task {
            viewModel.fetchSlotingListing()
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
    }
    
    private var slotBookingHeader: some View {
        VStack(alignment: .leading,spacing: 0){
            dateView
                .padding(.top,15)

            timeShiftView
                .padding(.top,15)
                
            Divider()
                .padding(.top,20)
        }
    }
    
    private var dateView: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 0){
                ForEach(viewModel.dates,id: \.label) {item in
                    DateSegmentView(dateItem: item, isSelected: viewModel.selectedSegment == item)
                        .padding(.leading,5)
                        .onTapGestureForced {
                            self.viewModel.selectedSegment = item
                            if viewModel.selectedSegment == viewModel.dates.first {
                                viewModel.selectedTimeShift = viewModel.getCurrentTimeShift()
                            }
                            else {
                                viewModel.selectedTimeShift = .morning
                            }
                            viewModel.fetchSlotingListing()
                        }
                }
            }
        }
        .frame(height : 42)
    }
    private var timeShiftView: some View {
        HStack {
            ForEach(viewModel.timeShiftList,id: \.self) {shift in
                SegmentView(
                    name: shift.displayValue,
                    font: FontConstants.primaryMediumTitle12,
                    isSelected: viewModel.selectedTimeShift == shift,
                    horizontalSpace: 12,
                    verticalSpace: 6,
                    cornerRadius: 10 , completion: {
                    self.viewModel.selectedTimeShift = shift
                        viewModel.fetchSlotingListing()
                })
            }
        }
        }
    private var slotView : some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.slotList,id: \.doctorID) { slotItem in
                    SlotItemView(slotInfo: slotItem,completion: { docter, slot in
                        self.viewModel.docterData = docter
                        self.viewModel.appoinmentData = AppointmentData(
                            date: self.viewModel.selectedSegment?.actualDate ?? TextResource.empty,
                            time: slot.time,
                            slotId: slot.slotID)
                        viewModel.navigateToAppoint()
                    })
                        .isHidden(slotItem.slots.isEmpty)
                        .padding(.top,10)
                }
            }
        }
    }
    private var emptySlotView : some View {
        VStack {
            Spacer()
            Text(TextResource.noSlotAvailable)
                .font(FontConstants.primaryRegularTitle16)
                .padding(.top,-50)
            Spacer()
        }
    }
}

struct DateSegmentView : View {
    let dateItem : DateItem
     var isSelected : Bool
    
    var body: some View {
        VStack (spacing : 0){
            BorderedSegmentView(
                color: isSelected ? Color(ColorResource.primaryButton) : ColorContants.dateGray,
                height: 40,
                horzontalPadding: 20,
                cornerRadius: 15,
                font: FontConstants.primaryRegularTitle14,
                text: dateItem.date
            )
        }
    }
}

struct SlotItemView : View {
    var slotInfo : SlotList
    var completion : (DocterData,Slot) -> ()
    let colomns : [GridItem] = [
        GridItem(.flexible(minimum: 60, maximum: 60)),GridItem(.flexible(minimum: 60, maximum: 60)),
        GridItem(.flexible(minimum: 60, maximum: 60)),GridItem(.flexible(minimum: 60, maximum: 60))]
    var body: some View {
        VStack(spacing: 0) {
            headerView
            slotView
                .padding(.top,10)
            
        }
    }
    @ViewBuilder
    private var imageView : some View {
        if let profilePhoto = slotInfo.profilePhoto, profilePhoto.isNotEmpty {
            ImageURLView(url: profilePhoto,isFill: true)
                .frame(width: 40,height: 40)
                .clipShape(Circle())
        }
        else {
            Image(ImageResource.docterIcon)
                .resizable()
                .scaledToFill()
                .frame(width: 40,height: 40)
                .clipShape(Circle())
        }
    }
    private var headerView : some View {
        HStack {
            imageView
            
            Text(slotInfo.doctorName ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle14)
            Spacer()
            Text("\(TextResource.rupeesSymbol)\(slotInfo.doctorFee ?? TextResource.empty)")
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(Color(ColorResource.priceGray))
                .isRemove(slotInfo.doctorFee == nil)
        }
    }

    private var slotView: some View {
        LazyVGrid(columns: colomns,alignment: .leading) {
               ForEach(slotInfo.slots,id: \.self) { slot in
                   SlotView(slot: slot) {slotItem in
                       completion(
                        DocterData(
                            docterName: self.slotInfo.doctorName ?? "",
                            image: "",
                            qualification: self.slotInfo.qualifications ?? "",
                            price: self.slotInfo.doctorFee ?? "",
                            description: slotInfo.description ?? "",
                            profilePhoto: self.slotInfo.profilePhoto ?? ""
                        ),
                        Slot(
                            active: "",
                            slotID: slotItem.slotID,
                            time: slotItem.time
                        )
                       )
                   }
                   .padding(.leading,10)
                }
            }
    }
}


struct SlotView : View {
    var slot : Slot
    var completion : (Slot) -> ()
    var body: some View {
        VStack {
            Text(slot.time)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(getColor())
                .frame(width : 60,height: 35)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundStyle(getColor())
        )
        .onTapGestureForced {
            if slot.active == SlotBookingStatus.active.rawValue {
                completion(slot)
            }
        }
    }
    func getColor() -> Color {
        return slot.active == SlotBookingStatus.active.rawValue ? ColorContants.slotGray : ColorContants.inAciveGray
    }
}

enum SlotBookingStatus : String {
    case active
}


protocol SlotBookingNavigation: AnyObject {
    func pop()
    func navigateToSlotBooking(
        clinicId: String,serviceList: [Service]
    )
    func navigateToAppointmentDetails(
        appointmentData : AppointmentData?,clinicData: ClinicData?,docterData: DocterData?,
        serviceList: [Service]
    )
}
