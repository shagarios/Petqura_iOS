//
//  SlotBookingViewModel.swift
//  PawWalker
//
//  Created by shagar on 26/01/25.
//

import SwiftUI
import Combine

class SlotBookingViewModel : ObservableObject {
    @Published var dates : [DateItem] = []
    @Published var clinicId : String = TextResource.empty
    @Published var selectedSegment : DateItem? {
        didSet {
            if selectedSegment != self.dates.first  {
                self.timeShiftList = [.morning,.noon,.evening]
            }
        }
    }
    @Published var selectedTimeShift : TimeShift = .morning
    @Published var timeShiftList : [TimeShift] = [.morning,.noon,.evening]
    @Injected var apiClient : ApiClientProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var slotList : [SlotList] = []
    @Published var navigateToAppointmentDetails : Bool = false
    @Published var seletedSlotTime : String = TextResource.empty
    @Published var docterData : DocterData?
    @Published var appoinmentData : AppointmentData?
    @Published var clinicData : ClinicData?
    @Published var isLoading : Bool = false
    var serviceList: [Service] = []
    weak var coordinator: SlotBookingNavigation?
    init(clinicId : String,coordinator: SlotBookingNavigation?,serviceList: [Service]) {
        self.clinicId = clinicId
        loadNextFiveDays()
        self.selectedSegment = dates.first
           self.selectedSegment = dates.first 
            self.selectedTimeShift = getCurrentTimeShift()
        self.coordinator = coordinator
        self.serviceList = serviceList
    }
    
    func loadNextFiveDays() {
        let today = Date()
        let calender = Calendar.current
        let labels = ["d1", "d2", "d3", "d4", "d5"]
        self.dates = (0..<5).map({ offset in
            let futureDate = calender.date(byAdding: .day, value: offset, to: today)
            let formattedDate = futureDate?.toString(format: DateFormats.e_dd_MMM.rawValue)
            let actualDate = futureDate?.toString(format: DateFormats.dd_MM_yyyy.rawValue) ?? TextResource.empty
            return DateItem(label: labels[offset], date: formattedDate ?? TextResource.empty, actualDate: actualDate)
        })
    }
  
    func fetchSlotingListing() {
        guard Connectivity.isConnectedToInternet else {
            ToastCenter.shared.showToast(TextResource.noInternet, type: .error)
            return
        }

        self.isLoading = true
        cancellables.removeAll() // cancel old sinks if any

        apiClient.APIRequest(
            router: .slotListing(
                clinicId: self.clinicId,
                day: self.selectedSegment?.label ?? "",
                time: self.selectedTimeShift.rawValue
            ),
            responseType: SlotListingModel.self
        )
        .sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.isLoading = false
                print("Slot listing error: \(error)")
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            let result = response.result

            self.slotList = result.slots.filter { !$0.slots.isEmpty }
            self.clinicData = ClinicData(
                clinicName: result.clinic?.clinicName ?? "",
                image: result.clinic?.clinicImage ?? "",
                address: (result.clinic?.clinicAddressLine1 ?? "") + (result.clinic?.clinicAddressLine2 ?? ""),
                phoneNumber: result.clinic?.phone ?? "",
                email: result.clinic?.email ?? "",
                clinicId: result.clinic?.clinicID ?? ""
            )
        }
        .store(in: &cancellables)
    }

    
    
     func getCurrentTimeShift() -> TimeShift {
        let now = Date()
        let calendar = Calendar.current

        // Extract hour and minute
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        let totalMinutes = hour * 60 + minute

        switch totalMinutes {
        case 0..<720: // 12:00 PM
            return .morning
        case 750..<960: // 12:30 PM - 4:00 PM
            if selectedSegment == self.dates.first {
                self.timeShiftList.removeAll(where: {$0 == .morning})
            }
            return .noon
        default: // From 4:30 PM onwards
            if selectedSegment == self.dates.first {
                self.timeShiftList.removeAll(where: {$0 != .evening})
            }
            return .evening
        }
    }
    func dismiss() {
        coordinator?.pop()
    }
    func navigateToAppoint() {
        coordinator?.navigateToAppointmentDetails(appointmentData: appoinmentData, clinicData: clinicData, docterData: docterData, serviceList: serviceList)
    }
}

enum TimeShift : String {
   case morning
   case noon
   case evening
    var displayValue : String {
        switch self {
        case .morning:
            return "Morning"
        case .noon:
            return "Afternoon"
        case .evening:
            return "Evening"
        }
    }
}
