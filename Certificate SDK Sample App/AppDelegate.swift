//
//  AppDelegate.swift
//  Certificate SDK Sample App
//
//  Copyright © 2018 Jamf. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    let requestManager = CertificateRequestManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1]
                as? UINavigationController
            navigationController?.topViewController!.navigationItem.leftBarButtonItem
                = splitViewController.displayModeButtonItem

            if UIDevice.current.userInterfaceIdiom == .pad {
                splitViewController.preferredDisplayMode = .allVisible
            }
            splitViewController.delegate = self
        }

        // Register for notifications in this app delegate method to ensure all notifications are properly sent to us.
        self.registerForNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of
        // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the
        // application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games
        // should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application
        // state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate:
        // when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the
        // changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the
        // application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also
        // applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {
            return false
        }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? ActionLogViewController else {
            return false
        }

        if topAsDetailController.setup == nil {
            // Return true to indicate that we have handled the collapse by doing nothing;
            // the secondary controller will be discarded.
            return true
        }
        return false
    }
}

// MARK: -

typealias LocalNotificationHandler = AppDelegate

extension LocalNotificationHandler: UNUserNotificationCenterDelegate {
    static let kRenewalCategory = "com.jamf.certificate-sdk.sample.renewal.category"
    static let kRenewalIdentifier = "com.jamf.certificate-sdk.sample.renewal"
    static let kDelayInSeconds = 5.0

    /// These are custom actions that we put onto the notification for the user to choose how to proceed
    /// without launching the entire app.
    ///
    /// - renew: This is the renew button; we will try to renew the certificate in the background.
    /// - decline: The is the decline button; we schedule another notification to remind the user to renew later.
    enum CertificateNotificationAction: String {
        case renew = "com.jamf.certificate-sdk.sample.renew"
        case decline = "com.jamf.certificate-sdk.sample.decline"
    }

    /// Register for notifications and set up the notification delegate
    func registerForNotifications() {
        let center = UNUserNotificationCenter.current()

        // First, set ourselves as the delegate to handle incoming notifications.
        center.delegate = self

        // Second, request authorization from the user for alerts
        center.requestAuthorization(options: [.alert]) { (_, error) in
            // enable or disable features based on authorization.
            // We check for authorization later anyway so...nothing to do in this callback.
            if error != nil {
                print("Error requesting notification authorization: \(error!)")
            }
        }

        // Third, set up our two custom actions on our category.
        let renewText = NSLocalizedString("Renew", comment: "Action button to renew from a notification")
        let declineText = NSLocalizedString("Decline", comment: "Action button to decline renewal from a notification")
        let renewAction = UNNotificationAction(identifier: CertificateNotificationAction.renew.rawValue,
                                               title: renewText,
                                               options: .init(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: CertificateNotificationAction.decline.rawValue,
                                                 title: declineText,
                                                 options: .init(rawValue: 0))
        let renewalCategory = UNNotificationCategory(identifier: LocalNotificationHandler.kRenewalCategory,
                                                     actions: [renewAction, declineAction],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)

        center.setNotificationCategories([renewalCategory])
    }

    func scheduleLocalNotificationForRenewal(_ expirationDate: Date) {
        let center = UNUserNotificationCenter.current()

        // First, remove any pending renewal local notifications.
        center.removePendingNotificationRequests(withIdentifiers:
            [LocalNotificationHandler.kRenewalIdentifier])

        center.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else { return }

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let dateAsString = dateFormatter.string(from: expirationDate)

            // Schedule the new local notification.
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = LocalNotificationHandler.kRenewalCategory
            content.title = NSLocalizedString("Renew SSO Cert",
                                              comment: "Short title of the notification to renew the user certificate")
            content.subtitle = String(format: NSLocalizedString("Expires: %@",
                                                                comment: """
    Subtitle of notification to renew the user certificate;
    the expiration date will be substituted for %@
    """),
                                      dateAsString)
            // swiftlint:disable line_length
            if expirationDate < Date(timeIntervalSinceNow: 0) {
                content.body = NSLocalizedString("Your Single Sign On certificate has expired.  Renew your certificate to restore SSO functionality.",
                            comment: "Notification text to renew the user certificate if it has expired.")
            } else {
                content.body = NSLocalizedString("Your Single Sign On certificate will expire soon.  Renew your certificate to continue enjoying SSO functionality.",
                            comment: "Notification text to renew the user certificate if it will expire in the future.")
            }
            // swiftlint:enable line_length

            content.userInfo = ["CustomData": "Anything else you want to keep track of can go here"]

            // This is going to schedule a notification for 5 seconds from now (for testing)
            // In a real app, you probably want to examine the certificate expiration date, pick a day a
            // couple weeks in advance of that and use a UNCalendarNotificationTrigger instead.

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: LocalNotificationHandler.kDelayInSeconds,
                                                            repeats: false)

            let request = UNNotificationRequest(identifier: LocalNotificationHandler.kRenewalIdentifier,
                                                content: content,
                                                trigger: trigger)

            center.add(request) { error in
                guard let actualError = error else { return }
                // Could do better error handling to let user know the notification to renew failed to be scheduled.
                print(actualError)
            }
        }
    }

    // MARK: -

    /// If the application is in the foreground when the notification fires, this method is called first.
    /// This gives us the opportunity to do things automatically and not show an alert to the user.
    /// NOTE: This method is called on a background thread.
    ///
    /// - Parameters:
    ///   - center: The notification center.
    ///   - notification: The notification itself.
    ///   - completionHandler: A completion handler that must be called once during this method to let the system
    ///                         know how to display the notification (or to NOT display the notification at all).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping
        (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == LocalNotificationHandler.kRenewalIdentifier {
            // Since we're in the foreground already, we can automatically do this renewal and not show the alert.
            self.requestManager.textOutputHandler?("Auto renew in foreground")
            self.requestManager.startRequest(with:
                CertificateSDKSetup(isActual: false, slowSpeed: false, simulateError: false))

            completionHandler(.init(rawValue: 0))
        } else {
            // Some other kind of notification; we should show it.
            completionHandler(.alert)
        }
    }

    /// Called when a notification comes in.  The user may have tapped the notification itself,
    /// or one of our two custom actions (Renew and Decline).
    ///
    /// - Parameters:
    ///   - center: The notification center.
    ///   - response: The response the user choose
    ///   - completionHandler: A completion handler that must be called after finished processing the notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let action = CertificateNotificationAction(rawValue: response.actionIdentifier) ?? .renew

        switch action {
        case .renew:
            if CertificateNotificationAction(rawValue: response.actionIdentifier) == nil {
                self.requestManager.textOutputHandler?("User did not choose an action")
            } else {
                self.requestManager.textOutputHandler?("User tapped renew")
            }
            self.requestManager.startRequest(with:
                CertificateSDKSetup(isActual: false, slowSpeed: false, simulateError: false))

        case .decline:
            // Could schedule another local notification here to nag the user again.
            self.requestManager.textOutputHandler?("User tapped decline; scheduling again")
            // Again, the real app should pick some useful date here.
            self.scheduleLocalNotificationForRenewal(Date(timeIntervalSinceNow: 60))
        }

        completionHandler()
    }
}
