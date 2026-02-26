
//
//  GoogleMapsView.swift
//  PawWalker
//
//  Created by shagar p.k on 27/10/22.
//  Copyright © 2022 Flashat. All rights reserved.
//

import SwiftUI
import GoogleMaps


struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var viewModel : MapViewModel
    @State var zoom : Float? = FloatingSize.zoom.rawValue
    @State var  selectedMarker : GMSMarker? = GMSMarker()
    @State var previewing: Bool = false
    @State var isDidTap : Bool = false
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self, marker: $selectedMarker, latitude: $viewModel.lat, longitude: $viewModel.long)
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.lat , longitude: viewModel.long, zoom: 12 ?? FloatingSize.zoom.rawValue)
        let mapView = GMSMapView()
        mapView.animate(to: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = !previewing
        selectedMarker!.position = CLLocationCoordinate2D(latitude: viewModel.lat, longitude: viewModel.long)

        let iconImage = UIImage(named: "currentLocationPin")
        selectedMarker?.icon = iconImage
        selectedMarker!.map = mapView
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let newPostion = CLLocationCoordinate2D(latitude: viewModel.lat, longitude: viewModel.long)
        selectedMarker?.position = newPostion
            let updatedCamera = GMSCameraPosition.camera(withLatitude: viewModel.lat, longitude: viewModel.long, zoom: 14)
            mapView.animate(to: updatedCamera)
        
    }
    class MapCoordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView       // access to owner view members,
        @Binding var selectedMarker: GMSMarker?
        @Binding var latitude: Double
        @Binding var longitude: Double
        init(parent: GoogleMapsView,
             marker: Binding<GMSMarker?>,
             latitude: Binding<Double>,
             longitude: Binding<Double>) {
            self.parent = parent
            _selectedMarker = marker
            _latitude = latitude
            _longitude = longitude
        }
        deinit {
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            guard !parent.previewing else { return }
            parent.viewModel.long = coordinate.longitude
            parent.viewModel.lat = coordinate.latitude
                    if let marker = selectedMarker {
                        marker.position = coordinate
                    } else {
                        let marker = GMSMarker(position: coordinate)
                        marker.icon = UIImage(named: "currentLocationPin")
                        marker.map = mapView
                        selectedMarker = marker
                    }
            parent.viewModel.getAddress(latitude: coordinate.latitude, longitude: coordinate.longitude) { place,address  in
                self.parent.viewModel.city = place.city
                self.parent.viewModel.country = place.country
                self.parent.viewModel.addressData = address
            }
        }
        
    }

}


