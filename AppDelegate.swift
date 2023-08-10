//
//  AppDelegate.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//


import UIKit
import UserNotifications
import FirebaseCore
import FirebaseCrashlytics

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    //In this method, you can perform any setup tasks that need to be done before the app is ready to use.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        bootService()
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let userId = uuid
        Crashlytics.crashlytics().setUserID(userId)
        registerForRemoteNotifications()
        return true
    }
    
    func bootService() {
        let isRunningUITests = ProcessInfo.processInfo.arguments.contains("isRunningUITests")
        if(isRunningUITests && ProcessInfo.processInfo.arguments.count > 2){
            let launchArgs = ProcessInfo.processInfo.arguments
            let testArgs: ArraySlice<String> = launchArgs[2...(launchArgs.count-1)]
            let testCaseIdentifiers: Array<String> = [] + testArgs
            
            Environments.shared.testVars["testCaseIdentifiers"] = testCaseIdentifiers
        }
        DependencyContainer.shared.setApiService(isRunningUITests: isRunningUITests)
        UserStateViewModel.shared.getCurrentUser()
    }
    /**
     Registers the app for remote notifications with Apple Push Notification service (APNs).
     
     If permission is granted, it registers the app for remote notifications with `UIApplication.shared.registerForRemoteNotifications()`.
     If there is an error requesting authorization, it prints an error message to the console.
     */
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        // Request permission to display alerts, play sounds, and badge the app's icon
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Failed to request notification authorization: \(error)")
            }
        }
    }
    
    // This method is called when the app successfully registers for remote notifications. In this method, you can send the device token to your server for further processing.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", { $0 + String(format: "%02x", $1) })
        sendDeviceTokenToServer(tokenString)
    }
    
    // This method is called when the app fails to register for remote notifications. In this method, you can handle the error and take appropriate action.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    // This method is a helper method that sends the device token to your server for further processing.
    func sendDeviceTokenToServer(_ token: String) {
        // Send the device token to your server for further processing
        print("Device token: \(token)")
    }
    
    // This method is called when the app receives a remote notification while it is running in the foreground. In this method, you can present a local notification to the user to alert them of the incoming notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Customize the presentation options based on your requirements
        completionHandler([.banner, .sound, .badge, .list])
    }
    
    // This method is called when the user taps on a remote notification. In this method, you can present a local notification to the user to alert them of the incoming notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification payload here
        let payload = response.notification.request.content
        print(payload)
        // Process the payload as needed
        
        // Call the completion handler when you're done handling the notification
        completionHandler()
    }
}
