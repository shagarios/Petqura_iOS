
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
    @State var previewing: Bool = false
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self, latitude: $viewModel.lat, longitude: $viewModel.long)
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.lat ,
                        longitude: viewModel.long, zoom: zoom ?? FloatingSize.zoom.rawValue)
        let mapView = GMSMapView()
        mapView.animate(to: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = !previewing
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true

        if let iconImage = UIImage(named: "currentLocationPin") {
            let pinImageView = UIImageView(image: iconImage)
            pinImageView.translatesAutoresizingMaskIntoConstraints = false
            pinImageView.contentMode = .scaleAspectFit
            mapView.addSubview(pinImageView)
            NSLayoutConstraint.activate([
                pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -18),
                pinImageView.widthAnchor.constraint(equalToConstant: 36),
                pinImageView.heightAnchor.constraint(equalToConstant: 36)
            ])
        }
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let updatedCamera = GMSCameraPosition.camera(withLatitude: viewModel.lat,
                                        longitude: viewModel.long, zoom: 14)
        if context.coordinator.shouldUpdateCamera(mapView: mapView, to: updatedCamera.target) {
            mapView.animate(to: updatedCamera)
        }
        
    }
    class MapCoordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView       // access to owner view members,
        @Binding var latitude: Double
        @Binding var longitude: Double
        private var shouldMoveCameraFromViewModel = true
        init(parent: GoogleMapsView,
             latitude: Binding<Double>,
             longitude: Binding<Double>) {
            self.parent = parent
            _latitude = latitude
            _longitude = longitude
        }
        deinit {
        }
        
        func shouldUpdateCamera(mapView: GMSMapView, to coordinate: CLLocationCoordinate2D) -> Bool {
            guard shouldMoveCameraFromViewModel else { return false }
            let latDiff = abs(mapView.camera.target.latitude - coordinate.latitude)
            let longDiff = abs(mapView.camera.target.longitude - coordinate.longitude)
            return latDiff > 0.0001 || longDiff > 0.0001
        }

        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            if gesture {
                shouldMoveCameraFromViewModel = false
            }
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            guard !parent.previewing else { return }
            parent.viewModel.lat = position.target.latitude
            parent.viewModel.long = position.target.longitude
            shouldMoveCameraFromViewModel = true
        }
        
    }

}
