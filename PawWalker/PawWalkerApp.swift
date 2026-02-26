//
//  PawWalkerApp.swift
//  PawWalker
//
//  Created by shagar p k on 10/09/24.
//

import SwiftUI

@main
struct PawWalkerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    @StateObject var toastManager = ToastManager()

    var body: some Scene {
        WindowGroup {
            GlobalToastPresenter {
                ContentView()
            }
            
        }
    }
 
}
