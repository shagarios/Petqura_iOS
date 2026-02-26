//
//  MapViewModel.swift
//  PawWalker
//
//  Created by shagar on 13/11/24.
//

import SwiftUI
import Combine
import GoogleMaps
import GooglePlaces

class MapViewModel : ObservableObject {
    var locationManager : LocationManager?
    private var cancellables = Set<AnyCancellable>()
    @Published var showingPlacesAutocomplete = false
    @Injected var coredataService : CoreDataServiceProtocol
    @Published var addressData : AddressData?
    @Published var addressDetails : Address?
    @Published var addressLine : String = ""
    @Published var selectedPlace: GMSPlace?  {
        didSet {
            guard let latitude = selectedPlace?.coordinate.latitude else {return}
            guard let longtitude = selectedPlace?.coordinate.longitude else {return}
            self.lat = latitude
            self.long = longtitude
            getAddress(latitude: latitude, longitude: longtitude) { place,address  in
                self.city = place.city
                self.country = place.country
                self.addressLine = place.address.joined(separator: " ")
                self.addressData = address
            }
        }
    }
    @Published var lat : Double = 0.0
    @Published var long : Double = 0.0 {
        didSet {
            getAddress(latitude: lat, longitude: long) { place,address  in
                self.city = place.city
                self.country = place.country
                self.addressLine = place.address.joined(separator: " ")
                self.addressData = address
            }
        }
    }
    @Published var city : String = ""
    @Published var country : String = ""
    @Published var navigateToHomeScreen = false
    private var latitudeCancellable: AnyCancellable?
    private var longitudeCancellable: AnyCancellable?
    @Injected var apiClient : ApiClientProtocol
    @Published var isLoading : Bool = false
    private var cancellable = Set<AnyCancellable>()
    init(address: Address?) {
        if let latitude = address?.latitude,let longitude = address?.longitude,latitude != 0.0,longitude != 0.0 {
            self.lat = latitude
            self.long = longitude
            self.addressDetails = address
        }
        else {
            self.locationManager = LocationManager()
        }
        
        latitudeCancellable = locationManager?.$latitude
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLat in
                self?.lat = newLat
                if self?.lat != 0.0 {
                    self?.latitudeCancellable = nil // Cancel all subscriptions
                }
            }
        longitudeCancellable = locationManager?.$longtitube
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLong in
                self?.long = newLong
                if self?.long != 0.0 {
                    self?.longitudeCancellable = nil // Cancel all subscriptions
                }
            }
    }
    func getAddress(latitude : Double, longitude : Double, completion: @escaping (((Place,AddressData) -> ()))) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
        var  city = ""
        var  country = ""
        geocoder.reverseGeocodeCoordinate(coordinate) {
            response,
            error in
            if let address = response?.firstResult() {
                let locality = address.locality
                let subLocality = address.subLocality
                let region = address.administrativeArea
                let addressLine = address.lines
                let postalCode = address.postalCode
                if let countryValue = address.country {
                    country = countryValue
                }
                if locality != nil && subLocality != nil {
                    city = "\(subLocality!), \(locality!)"
                    completion(Place(city: city,country: country,region: region ?? "",
                                     address: addressLine ?? []),
                               AddressData(address: addressLine ?? [], locality: locality ?? "",
                                           administrativeArea: region ?? "",
                                           postalCode: postalCode ?? "",
                                           country: country,
                                           subLocality: subLocality ?? "",latitude: latitude,longitude: longitude))
                }
                else if locality != nil && subLocality == nil {
                    city = locality!
                    completion(
                        Place(city: city,country: country,
                              region: region ?? "",
                              address: addressLine ?? []),
                        AddressData(address: addressLine ?? [], locality: locality ?? "",
                                    administrativeArea: region ?? "",
                                    postalCode: postalCode ?? "",
                                    country: country,
                                    subLocality: subLocality ?? ""))
                }
                else if locality == nil && subLocality != nil {
                    city = subLocality!
                    completion(
                        Place(
                            city: city,
                            country: country,
                            region: region ?? "",address: addressLine ?? []
                        ),
                        AddressData(address: addressLine ?? [], locality: locality ?? "",
                                    administrativeArea: region ?? "",
                                    postalCode: postalCode ?? "",
                                    country: country,
                                    subLocality: subLocality ?? "",latitude: latitude,longitude: longitude)
                    )
                }
                else {
                    city = ""
                    completion(
                        Place(city: city,country: country,
                              region: region ?? "",
                              address: addressLine ?? []),
                        AddressData(address: addressLine ?? [], locality: locality ?? "",
                                    administrativeArea: region ?? "",
                                    postalCode: postalCode ?? "",
                                    country: country,
                                    subLocality: subLocality ?? "",latitude: latitude,longitude: longitude)
                    )
                }
            }
        }
    }
    
    
    
    func saveLocationToLocalDatabase(result : AddressData?,completion: @escaping () -> ()) {
        let entity : Any? = fetchLocalData() ??  coredataService.createEntity(for: TableNames.locationData)
        guard let location = entity as? LocationData else {return}
        guard let userLocation = result else {return}
        location.latitude = lat.stringValue()
        location.longitude = long.stringValue()
        location.administativeArea = userLocation.administrativeArea
        location.locality = userLocation.locality
        location.subLocality = userLocation.subLocality
        location.postalCode = userLocation.postalCode
        location.country = userLocation.country
        saveAddressToDB(address: userLocation.address, locationData: location)
        coredataService.save(object: location)
        completion()
        
    }
    func saveAddressToDB (address: [String],locationData : LocationData) {
        address.forEach { name in
            let addressDB = coredataService.createEntity(
                for: TableNames.address
            ) as! AddressDB
            addressDB.name = name
            addressDB.location = locationData   // To-One side
        }
    }
    func saveToLocalStorage() {
        guard let entity : User = fetchUser() else {return}
        entity.isMapCompleted = true
        coredataService.save(object: entity)
    }
    func fetchUser() -> User? {
        let result: Result<[User],Error> = coredataService.fetch(tableName: TableNames.user,
                                                                 sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let users):
            return users.first
        case .failure(_):
            return nil
        }
    }
    func fetchLocalData() -> LocationData? {
        let result: Result<[LocationData],Error> = coredataService.fetch(tableName: TableNames.locationData, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let location):
            return location.first
        case .failure(_):
            return nil
        }
    }
    func makeAccountAddress() -> Address? {
        if let addressData = self.addressData {
            return Address(address: addressLine,
                           addressType: nil, addressUse: nil, city: addressData.locality,
                           defaultAddress: nil, email: addressDetails?.email ?? nil,
                           fullname: addressDetails?.fullname ?? nil,
                           id: addressDetails?.id ?? nil,
                           phone: addressDetails?.phone ?? nil,
                           pin: addressData.postalCode,
                           state: addressData.administrativeArea,
                           user: addressDetails?.user ?? nil,
                           landmark: addressDetails?.landmark ?? nil,
                           userID: addressDetails?.userID ?? nil,
                           latitude: addressData.latitude,
                           longitude: addressData.longitude)
        }
        else {
            return nil
        }
    }
}

