//
//  SPDX-License-Identifier: MIT
//  https://github.com/jamf/CertificateSDK
//
//  Copyright 2024, Jamf
//
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    let requestManager = CertificateRequestManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            let navController = splitViewController.viewControllers[splitViewController.viewControllers.count-1]
                as? UINavigationController
            navController?.topViewController!.navigationItem.leftBarButtonItem
                = splitViewController.displayModeButtonItem

            if UIDevice.current.userInterfaceIdiom == .pad {
                splitViewController.preferredDisplayMode = .allVisible
            }
            splitViewController.delegate = self
        }

        // Register for notifications in this app delegate method to ensure all notifications are properly sent to us.
        let notificationService = LocalNotificationService.shared
        notificationService.requestManager = self.requestManager
        notificationService.registerForNotifications()

        return true
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let navController = secondaryViewController as? UINavigationController else {
            return false
        }
        guard let actionLogController = navController.topViewController as? ActionLogViewController else {
            return false
        }

        if actionLogController.testConfiguration == nil {
            // Return true to indicate that we have handled the collapse by doing nothing.
            // The secondary controller will be discarded.
            return true
        }
        return false
    }
}
