//
//  AppDelegate.swift
//  PawWalker
//
//  Created by shagar on 30/10/24.
//

import SwiftUI
import FirebaseCore
import GoogleMaps
import Firebase
import UserNotifications
import GooglePlaces


class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       FirebaseApp.configure()
      GMSServices.provideAPIKey(Bundle.main.googleMapKey)
      GMSPlacesClient.provideAPIKey("AIzaSyAmQwZD_TEal9pHg9gQGy3O69jyFFdYYAI")
      print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
      UNUserNotificationCenter.current().delegate = self
      //MARK: CONFIGURE PUSHNOTIFICATION
      Messaging.messaging().delegate = self
      configureNotification(application)
    return true
  }
    
    func configureNotification(_ appication : UIApplication) {
        let authOptions : UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            if granted {
                DispatchQueue.main.sync {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    //MARK: listens to remote notifications and will alert the app when a new push notification comes in
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("message ID : \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken : [String : String] = ["token" : fcmToken ?? ""]
        print("Device token ", deviceToken) // This token can be used for testing notifcation on FCM
        UserSessionManager.shared.deviceToken = fcmToken ?? ""
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification: \(notification.request.content.userInfo)")
        
        // 👇 Choose how to present notification in foreground
        completionHandler([.banner, .list, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User tapped notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

