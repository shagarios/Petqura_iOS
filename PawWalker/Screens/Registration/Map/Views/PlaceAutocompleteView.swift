//
//  PlaceAutocompleteView.swift
//  PawWalker
//
//  Created by shagar on 24/08/25.
//
import GooglePlaces
import SwiftUI
// A SwiftUI view to present the Google Places autocomplete
struct PlaceAutocompleteView: UIViewControllerRepresentable {
    @Binding var selectedPlace: GMSPlace?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var parent: PlaceAutocompleteView

        init(_ parent: PlaceAutocompleteView) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            self.parent.selectedPlace = place
            self.parent.isPresented = false
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            self.parent.isPresented = false
        }
    }
}
