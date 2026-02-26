//
//  ContentView.swift
//  PawWalker
//
//  Created by shagar p k on 10/09/24.
//

import SwiftUI
import CoreData
import FirebaseAnalytics
import FirebaseRemoteConfig

struct ContentView: View {
    @StateObject var viewModel : ContentVIewModel = ContentVIewModel()
    @State var shouldShowSkip = false
    @State var shouldShowUpdateAlert = false
    @State var appStoreUrl: String?
    @State var remoteConfig: RemoteConfig!
    var body: some View {
        VStack{
        AppCoordinatorView()
        }
        .onAppear {
           self.setupRemoteConfig()
            self.fetchAndActivateRemoteConfig()
            print("scheme :\(Bundle.main.scheme)")
        }
        .alert(isPresented: $shouldShowUpdateAlert) {
            if shouldShowSkip {
                return Alert(title: Text(TextResource.updateAvailable), message: Text(TextResource.updateAlertContent), primaryButton: .default(Text("Update"), action: {
                    self.alertUpdateAction()
                }), secondaryButton: .default(Text("Skip"),action: {
                    self.resetFlagsAndProps()
                })
                )
            } else {
                return Alert(title: Text(TextResource.updateAvailable), message: Text(TextResource.updateAlertContent), dismissButton: .default(Text("Update"), action: {
                    self.alertUpdateAction()
                })
                )
            }
        }
        .fullScreenCover(isPresented: $viewModel.showMapScreen, content: {
            MapScreen(address: nil, isAccountRelated: false, coordinator: nil)
        })
    }
    
    private var dashboardView : some View {
            DashboardScreen()
    }

    
    /// Initializes defaults from `RemoteConfigDefaults.plist` and sets config's settings to developer mode
    private func setupRemoteConfig() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        if remoteConfig != nil {
            self.remoteConfig.setDefaults(fromPlist: FileNames.remoteConfigPlist)
        }
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
    }
    
    private func fetchAndActivateRemoteConfig() {
        self.remoteConfig.fetchAndActivate { status, error in
            guard error == nil else {
                return
            }
            do {
                let versionInfo: VersionInfo = try self.remoteConfig.decoded(asType: VersionInfo.self)
                DispatchQueue.main.async {
                    self.handleUIUpdate(versionInfo: versionInfo.appInfo)
                    handleMapScreen(showMapScreen: versionInfo.showMapInfo.showMapScreen)
                }
            } catch {
                return
            }
            
        }
    }
    
    func handleMapScreen(showMapScreen: Bool) {
        viewModel.handleMap(shouldShowMapScreen: showMapScreen)
    }
    func handleUIUpdate(versionInfo: AppVersionInfo) {
        guard versionInfo.showPopUp, versionInfo.version != Bundle.main.appVersion else {
            resetFlagsAndProps()
            return
        }
                self.shouldShowUpdateAlert = true
        
    }
    func resetFlagsAndProps() {
        shouldShowSkip = false
        shouldShowUpdateAlert = false
        appStoreUrl = nil
    }
    func alertUpdateAction() {
        if let url = appStoreUrl {
            UIApplication.shared.open(URL(string: url)!, options: [:]) { completed in
                if completed {
                    resetFlagsAndProps()
                }
            }
        }
        
    }
    
}

//        .onAppear {
//            // Analytics.logEvent("onBoarding_Screen", parameters: [:])
//        }
