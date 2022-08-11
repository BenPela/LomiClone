//
//  AppDelegate+pushNotification.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-07-15.
//

import FirebaseMessaging

// MARK: - Basic set up
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func setupPushNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self // Apple
        Messaging.messaging().delegate = self // FCM
        
        // Ask user to authorize push notification
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions) { success, error in
            if success {
                SystemLogger.log.debug(messages: "\(#function): Authorizing push notification: Success")
            } else {
                SystemLogger.log.debug(messages: "\(#function): Authorizing push notification: Failure")
            }
            if let error = error {
                SystemLogger.log.error(messages: error.localizedDescription)
            }
        }
        application.registerForRemoteNotifications()
    }
    
    /// This method is called generally once per app start with registration token.
    /// FCM delegate.
    ///
    /// When this method is called, it is the ideal time to:
    /// - If the registration token is new, send it to your application server.
    /// - Subscribe the registration token to topics. This is required only for new subscriptions or for situations where the user has re-installed the app.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        SystemLogger.log.debug(messages: "\(#function): Token \(fcmToken ?? "")")
        // If necessary subscribe to topics. e.g
        // Messaging.messaging().subscribe(toTopic: "SomeTopi")
        
        // If necessary send token to application server.
    }
    
}

// MARK: - Functions call after receiving the push notification
extension AppDelegate {
    
    /// This is called when a notification arrived while the app was running in the **foreground**.
    /// UserNotificationCenter delegate.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        SystemLogger.log.debug(messages: "\(#function): Received push notification in the foreground")
        // Specify presentation options for the push notification.
        completionHandler([[.banner, .sound]])
    }
    
    /// This is called when a **user takes some response to the push notification**.
    /// This is called regardless the app is foreground, background or is not running. (As long as a user tap it.)
    /// UserNotificationCenter delegate.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        SystemLogger.log.debug(messages: "\(#function): A user has tapped to the push notification")
        
        // The way to handle received info
        // response.notification.request.content.userInfo
        completionHandler()
    }

}
