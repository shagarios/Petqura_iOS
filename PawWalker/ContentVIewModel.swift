//
//  ContentVIewModel.swift
//  PawWalker
//
//  Created by shagar p k on 12/09/24.
//

import Foundation
import Combine

class ContentVIewModel : ObservableObject {
    @Injected private var apiClient : ApiClientProtocol
    @Injected private var AnalyticsManager : AnalyticsManagerProtocol
   private var cancellables = Set<AnyCancellable>()
    @Published var showMapScreen : Bool = false
     
    func fetchData() {
        apiClient.APIRequest(router: .getPost, responseType: [PostElement].self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error): 
                    print("error : \(error)")
                    break
                }
            } receiveValue: { elementList in
                print("list : \(elementList)")
            }
            .store(in: &cancellables)
    }
    func onAppear() {
        AnalyticsManager.logEvent(event: AnalyticEvents.chapterTapped(name: "chapter_1"))
    }
    func handleMap(shouldShowMapScreen: Bool) {
        let mapShowed = UserDefaults.standard.value(forKey: UserDefaultConstants.mapShowed.rawValue) as? Bool ?? false
        if shouldShowMapScreen && mapShowed == false {
            showMapScreen = true
        }
    }

}
