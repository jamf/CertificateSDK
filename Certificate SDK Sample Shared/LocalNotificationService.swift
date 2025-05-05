//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import UserNotifications

class LocalNotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = LocalNotificationService()

    weak var requestManager: CertificateRequestManager?

    static private let kRenewalCategory = "com.jamf.certificate-sdk.sample.renewal.category"
    static private let kRenewalIdentifier = "com.jamf.certificate-sdk.sample.renewal"
    static private let kDelayInSeconds = 5.0

    /// These are custom actions that we put onto the notification for the user to choose how to proceed
    /// without launching the entire app.
    ///
    /// - renew: This is the renew button; we will try to renew the certificate in the background.
    /// - decline: The is the decline button; we schedule another notification to remind the user to renew later.
    private enum CertificateNotificationAction: String {
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
                self.requestManager?.textOutputHandler?("Error requesting notification authorization: \(error!)")
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
        let renewalCategory = UNNotificationCategory(identifier: Self.kRenewalCategory,
                                                     actions: [renewAction, declineAction],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)

        center.setNotificationCategories([renewalCategory])
    }

    func scheduleLocalNotificationForRenewal(_ expirationDate: Date) {
        let center = UNUserNotificationCenter.current()

        // First, remove any pending renewal local notifications.
        center.removePendingNotificationRequests(withIdentifiers:
            [Self.kRenewalIdentifier])

        center.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else { return }

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let dateAsString = dateFormatter.string(from: expirationDate)

            // Schedule the new local notification.
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = Self.kRenewalCategory
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

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Self.kDelayInSeconds,
                                                            repeats: false)

            let request = UNNotificationRequest(identifier: Self.kRenewalIdentifier,
                                                content: content,
                                                trigger: trigger)

            center.add(request) { error in
                guard let actualError = error else { return }
                // Could do better error handling to let user know the notification to renew failed to be scheduled.
                self.requestManager?.textOutputHandler?("Scheduling error: \(actualError)")
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
                                withCompletionHandler
                                completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        if notification.request.identifier == Self.kRenewalIdentifier {
            // Since we're in the foreground already, we can automatically do this renewal and not show the alert.
            self.requestManager?.textOutputHandler?("Auto renew in foreground")
            self.requestManager?.startRequest(with:
                CertRequestConfiguration(isActual: false, slowSpeed: false, simulateError: false))

            completionHandler(.init(rawValue: 0))
        } else {
            // Some other kind of notification; we should show it.
            if #available(iOS 14.0, *) {
                completionHandler(.banner)
            } else {
                completionHandler(.alert)
            }
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
                self.requestManager?.textOutputHandler?("User did not choose an action")
            } else {
                self.requestManager?.textOutputHandler?("User tapped renew")
            }
            self.requestManager?.startRequest(with:
                CertRequestConfiguration(isActual: false, slowSpeed: false, simulateError: false))

        case .decline:
            // Could schedule another local notification here to nag the user again.
            self.requestManager?.textOutputHandler?("User tapped decline; scheduling again")
            // Again, the real app should pick some useful date here.
            self.scheduleLocalNotificationForRenewal(Date(timeIntervalSinceNow: 60))
        }

        completionHandler()
    }
}
