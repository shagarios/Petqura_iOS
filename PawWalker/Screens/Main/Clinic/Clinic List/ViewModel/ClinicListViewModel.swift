//
//  ClinicListViewModel.swift
//  PawWalker
//
//  Created by shagar on 09/12/24.
//
import SwiftUI
import Combine

class ClinicListViewModel : ObservableObject {
    @Injected var apiClient : ApiClientProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var clinicList : [Clinic] = []
    @Published var navigateToDetailScreen : Bool = false
    @Published var selectedClinic : Clinic?
    @Published var navigateToSlotBooking : Bool = false
    @Published var selectedClinicId : String = TextResource.empty
    @Published var filteredClinicList : [Clinic] = []
    @Published var searchSubject = PassthroughSubject<String,Never>()
    @Published var hasNext : Bool = false
    @Published var page : Int = 1
    @Published var searchPage : Int = 1
    @Published var searchHasNext : Bool = false
    @Injected var internet : NetworkMonitor
    @Published var shouldShowEmptyView : Bool = false
    @Published var shouldShowEmptySearchView : Bool = false
    @Published var isLoading: Bool = false
    @Published var selctedServiceId : String = ""
    @Published var showLoginRequiredAlert : Bool = false
    @Published var locationData: LocationData?
    @Published var searchText : String = TextResource.empty {
        didSet {
            if searchText.isEmpty {
                shouldShowEmptySearchView = false
            }
            searchSubject.send(searchText)
        }
    }
    @Published var showFilterList : Bool = false
    @Published var shouldSearch = true
    
    // Filter
    @Published var filters: [FilterType] = []
    @Published var selectedFilter: FilterType?
    @Published var selectedItems: Set<FilterItem> = []
    weak var coordinator: ClinicCoordinator?
    @Injected var coredataService : CoreDataServiceProtocol
    @Published var filterArrayString: String = ""
    @Published var filersApiData : [FilterApiData] = []
    
    init(coordinator: ClinicCoordinator) {
        setupSearchPublisher()
        self.coordinator = coordinator
    }
    func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                guard self.shouldSearch else {
                    self.shouldSearch = true
                    return
                }
                self.filteredClinicList.removeAll()
                self.searchPage = 1
                self.shouldShowEmptySearchView = false
                if self.searchText.isNotEmpty {
                    self.searchClinicList()
                }
                else {
                    UIApplication.shared.endEditing()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchClinicList(serviceId: String) {
        let latitude = self.locationData?.latitude ?? ""
        let longitude = self.locationData?.longitude ?? ""
        guard Connectivity.isConnectedToInternet else {
            ToastCenter.shared.showToast(TextResource.noInternet, type: .error)
            return
        }
        isLoading = true
        if page == 1 {
            clinicList.removeAll()
        }
        apiClient.APIRequest(
            router: .clinicList(serviceId: serviceId, page: page,
                keyword: TextResource.empty,latitude: latitude,longitude: longitude),
            responseType: ClinicListModel.self
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false

            switch completion {
            case .finished:
                break
            case .failure(let error):
                ToastCenter.shared.showToast(
                    error.backendError?.message ?? error.localizedDescription,
                    type: .error
                )
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }

            let clinics = response.result.clinics ?? []
            if clinics.isEmpty {
                self.shouldShowEmptyView = true
            } else {
                if self.page == 1 {
                    self.clinicList = clinics
                } else {
                    self.clinicList.append(contentsOf: clinics)
                }
                self.shouldShowEmptyView = false
            }

            self.hasNext = response.result.hasNext ?? false
            filterArrayString = ""
            selectedItems.removeAll()
        }
        .store(in: &cancellables)
    }

    func addToFavorite(clinicId : String,completion : @escaping (Bool) -> Void) {
        if Connectivity.isConnectedToInternet {
            let param : [String : Any] = [ApiParameters.id : clinicId,ApiParameters.favoriteItem : FavoriteType.clinic.rawValue]
            self.isLoading = true
            apiClient.APIRequest(router: .addToFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink {[weak self]  completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(TextResource.addedTofavorite,type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func deleteFavorite(clinicId : String,completion : @escaping (Bool) -> Void) {
        if internet.isConnectedToInternet {
            let param : [String : Any] = [ApiParameters.id : clinicId,ApiParameters.favoriteItem : FavoriteType.clinic.rawValue]
            self.isLoading = true
            apiClient.APIRequest(router: .deleteFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { [weak self]completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { [weak self]response in
                    self?.isLoading = false
                    ToastCenter.shared.showToast(TextResource.deleteFromFavorite,type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func searchClinicList() {
        let latitude = self.locationData?.latitude ?? ""
        let longitude = self.locationData?.longitude ?? ""
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .clinicList(serviceId: TextResource.empty,page: self.searchPage,keyword: self.searchText,latitude: latitude,longitude: longitude),
                                 responseType: ClinicListModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                        self?.shouldSearch = false
                        UIApplication.shared.endEditing()
                        break
                    }
                } receiveValue: { response in
                    if let clinics = response.result.clinics {
                        self.isLoading = false
                        self.filteredClinicList = clinics
                    }
                    self.searchHasNext = response.result.hasNext ?? false
                    if self.filteredClinicList.isEmpty {
                        self.shouldShowEmptySearchView = true
                    }
                    self.isLoading = false
                    self.shouldSearch = false
                    UIApplication.shared.endEditing()
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func fetchLocation()  {
        let result : Result<[LocationData],Error> = coredataService.fetch(tableName: TableNames.locationData, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let location):
        self.locationData = location.first
            if filterArrayString.isEmpty {
                self.fetchClinicList(serviceId: "service_id[]=\(coordinator?.appCoordinator?.selectedServiceId ?? "")")
            }
            else {
                self.fetchClinicList(serviceId: filterArrayString)
            }
        case .failure(let failure):
            break
        }
    }
    
    
    /// get clinic filter data
    func getFliterData() {
        if internet.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .clinicFilters, responseType: FilterResponse.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { [weak self] response in
                    if let data = response.result?.filters {
                        self?.filters = data
                        self?.selectedFilter = data.first
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    
    func toggleItem(_ item: FilterItem,type : String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
            filersApiData.removeAll(where: {$0.id == item.id})
        } else {
            selectedItems.insert(item)
//            filterArrayString.append("\(type)[]=\(item.id)")
            filersApiData.append(FilterApiData(type: type, name: item.name, id: item.id))
        }
    }
    func makeApiString() -> String {
        var parts : [String] = []
         for item in filersApiData {
             parts.append("\(item.type)[]=\(item.id)")
        }
        return parts.joined(separator: "&")
    }
}


struct FilterApiData {
    var type : String
    var name : String
    var id : String
}
