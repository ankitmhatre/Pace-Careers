//
//  Pace_Careers_NotificationApp.swift
//  Pace Careers Notification
//
//  Created by Ankit Mhatre on 7/6/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import FirebaseFirestore




class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Apple Remote Notifications")
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "newjobs") { error in
          print("Subscribed to newjobs topic")
        }
        let db = Firestore.firestore()
        print(deviceToken.hexString)
        let data : [String: Any] = [
            "token": deviceToken.hexString
        ]
        
        
        
        db.collection("deviceTokens").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully.")
            }
        }
    }
    
    
    
    
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

      
      // 1
      UNUserNotificationCenter.current().delegate = self
      // 2
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions) { _, _ in }
      // 3
      application.registerForRemoteNotifications()
      
    return true
  }
}
  
    
@main 
struct Pace_Careers_NotificationApp: App {
    

    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

   
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    private func process(_ notification: UNNotification) {
      // 1
      let userInfo = notification.request.content.userInfo
        print(userInfo);
        // 2
      UIApplication.shared.applicationIconBadgeNumber = 0
        
//      if let newsTitle = userInfo["newsTitle"] as? String,
//        let newsBody = userInfo["newsBody"] as? String {
//        let newsItem = NewsItem(title: newsTitle, body: newsBody, date: Date())
//        NewsModel.shared.add([newsItem])
//      }
    }


    
    
    
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        
        //process(notification)

      completionHandler([[.banner, .sound]])
    }

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        process(response.notification)

        
      completionHandler()
    }
  }


extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

