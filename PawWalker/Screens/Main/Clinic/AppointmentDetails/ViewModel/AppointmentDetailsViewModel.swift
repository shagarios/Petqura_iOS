//
//  AppointmentDetailsScreen.swift
//  PawWalker
//
//  Created by shagar on 04/02/25.
//

import Foundation
import Combine

class AppointmentDetailsViewModel : ObservableObject {
    @Injected var apiClient : ApiClientProtocol
    @Published var appointmentData : AppointmentData?
    @Published var clinicData : ClinicData?
    @Published var docterData : DocterData?
    @Published var petName : String = TextResource.empty
    @Published var showCashfreePage: Bool = false
    private var cancellable = Set<AnyCancellable>()
    @Published var orderID : String = TextResource.empty
    @Published var sessionID : String = TextResource.empty
    @Published var showLoader : Bool = false
    @Published var isEmptyPetName : Bool = false
    @Published var navigateToMyAppointment : Bool = false
    @Published var isLoading: Bool = false
    @Injected var networkMonitor : NetworkMonitor
    @Published var appoinmentChargeData : AppointmentChargeResponse?
    weak var coordinator: ClinicCoordinator?
    weak var appCoordinator : AppCoordinator?
    @Published var showCouponView: Bool = false
    @Published var couponText : String = ""
    @Published var isCouponApplied : Bool = false
    @Published var couponId : String = ""
    @Published var showLoginRequiredAlert: Bool = false
    @Published var fromMyAppointment : Bool = false
    @Published var showServiceList : Bool = false
    @Published var selectedServiceData : Services?
    @Published var selectedService : String = ""
    @Published var serviceList: [Services] = []
    @Published var serviceName: String = ""
    init(appointmentData: AppointmentData?, clinicData: ClinicData?,
         docterData: DocterData?,
         fromMyAppointmet: Bool = false,serviceList: [Service]) {
        self.fromMyAppointment = fromMyAppointmet
        if self.fromMyAppointment == false {
            self.appointmentData = appointmentData
            self.clinicData = clinicData
            self.docterData = docterData
            
        }
        makeServiceList(serviceArray: serviceList)
        CashFreeBroker.cashFreeCompletion.sink { status in
            self.showCashfreePage = false
            if status {
                self.coordinator?.popToRoot()
                self.appCoordinator?.selectedAccountPage = .myAppointments
                self.appCoordinator?.selectedTab = .account
            }
        }
        .store(in: &cancellable)
    }
    func makeServiceList(serviceArray: [Service])  {
        self.serviceList = serviceArray.map({ service in
            return Services(description: service.description,
                            icon: service.icon, id: service.serviceID,
                            status: 0,
                            title: service.service)
        })
    }
    func clinicPayment() {
        if Connectivity.isConnectedToInternet {
            if petName.isEmpty {
                ToastCenter.shared.showToast("Please enter the petname",type: .error)
            }
            else {
                let date = appointmentData?.date ?? TextResource.empty
                self.isLoading = true
                var param : [String : Any] = [ApiParameters.petName : petName,
                                              ApiParameters.startTime : appointmentData?.time ?? TextResource.empty,
                                              ApiParameters.timeSlotId : appointmentData?.slotId ?? TextResource.empty,
                                              ApiParameters.appointmentDate : date,
                                              ApiParameters.slotPrice : Double(docterData?.price ?? "0") ?? 0.0,
                                              ApiParameters.clinicId : clinicData?.clinicId ?? TextResource.empty,
                                              ApiParameters.serviceId: selectedServiceData?.id ?? ""
                ]
                if self.couponId.isNotEmpty {
                    param[ApiParameters.couponId] = self.couponId
                }
                apiClient.APIRequest(router: .clinicPayment, parameters: param, responseType: ClinicPaymentOrder.self)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.isLoading = false
                            ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError)
                        }
                    } receiveValue: { result in
                        self.isLoading = false
                        self.orderID = result.response.orderID
                        self.sessionID = result.response.paymentSessionID
                        self.showCashfreePage = true
                    }
                    .store(in: &cancellable)
            }
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func convertDateFormat(input : String,inputFormat : String,outputFormat : String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        }
        else {
            return nil
        }
    }
    func postToCart(productId : String, varaintId : String,quantity : Int) async {
        if Connectivity.isConnectedToInternet {
            let params : [String : Any] = [
                ApiParameters.productId : productId,
                ApiParameters.productVariantId : varaintId,
                ApiParameters.quantity : quantity
            ]
            self.isLoading = true
            apiClient.APIRequest(router: .addTocat, parameters: params, responseType: AddToCartModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        guard let cartCount = result.cart?.count else {return}
                        EventHandler.cartCountSubject.send(cartCount)
                        ToastCenter.shared.showToast(TextResource.addedToCartAlert)
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func fetchPriceDetails(couponCode : String) {
        if networkMonitor.isConnectedToInternet,let slotId = appointmentData?.slotId  {
            self.isLoading = true
            let param : [String : Any] = [ApiParameters.timeSlotId : slotId,ApiParameters.coupons : couponCode]
            apiClient.APIRequest(router: .appointmentCharge, parameters: param, responseType: AppointmentChargeModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { result in
                    self.isLoading = false
                    self.appoinmentChargeData = result.response
                    self.couponId = result.response.couponId ?? ""
                    if couponCode.isNotEmpty {
                        self.isCouponApplied = true
                    }
                    else {
                        self.isCouponApplied = false
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    var seriveAndGstPrice : String {
        let serviceFee = appoinmentChargeData?.serviceFees ?? 0
        let gst = appoinmentChargeData?.gst ?? 0
        let price = Double(serviceFee) + gst
        return price.stringValue()
    }
    func dismiss() {
        coordinator?.pop()
    }
    func fetchAppointmentDetails() {
        apiClient.APIRequest(router: .getAppointmentDetails(appointmentId: UserSessionManager.shared.appointmentId), responseType: AppointmentResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                break
                case .finished:
                    break
                }
            } receiveValue: { response in
                // response.result is an AppointmentResult (not a collection), so avoid using map
                let result = response.result

                // Build and assign AppointmentData
                self.appointmentData = AppointmentData(
                    date: result.appointmentDate,
                    time: result.endTime ?? "",
                    slotId: ""
                )

                // Build and assign DocterData
                self.docterData = DocterData(
                    docterName: result.doctorName ?? "",
                    image: result.doctorPhoto ?? "",
                    qualification: result.doctorQualifications ?? "",
                    price: result.slotPrice ?? "",
                    description: result.doctorDescription ?? "",
                    profilePhoto: result.doctorPhoto ?? ""
                )

                // Build and assign ClinicData
                self.clinicData = ClinicData(
                    clinicName: result.clinicDetails.clinicName ?? "",
                    image: result.clinicDetails.clinicImage ?? "",
                    address: result.clinicDetails.clinicAddressLine1 ?? "",
                    phoneNumber: result.clinicDetails.phone ?? "",
                    email: result.clinicDetails.email ?? "",
                    clinicId: result.clinicDetails.email ?? ""
                )

                // Build and assign AppointmentChargeResponse
                self.appoinmentChargeData = AppointmentChargeResponse(
                    couponPrice: 0,
                    gst: Double(result.gst ?? "0") ?? 0,
                    serviceFees: Double(result.serviceFee ?? "") ?? 0,
                    slotPrice: Double(result.slotPrice ?? "") ?? 0,
                    total: Double(result.total ?? "") ?? 0,
                    couponId: ""
                )
                self.petName = result.petName ?? ""
                self.serviceName = result.serviceName ?? ""
            }
            .store(in: &cancellable)
    }
}
