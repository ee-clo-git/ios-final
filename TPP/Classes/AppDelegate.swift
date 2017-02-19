//
//  AppDelegate.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Mapbox
import Fabric
import Crashlytics
import FBSDKCoreKit
import TwitterKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        self.registerServices()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        return true
    }

    func registerServices() {
        Fabric.with([Crashlytics.self, Twitter.self])
        MGLAccountManager.setAccessToken(nil)
        BackgroundService.shared.registerForEvents()
        UserService.shared.registerForEvents()
        UIService.shared.registerForEvents()
        PushNotificationsService.shared.registerForEvents()
        TPPActivityService.shared.registerForEvents()
        LocationService.shared.registerForEvents()
        LocationSenderService.shared.registerForEvents()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL = ", url)
        UIAppUrlEvent(url: url).send()
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .inactive {
            PushNotificationsService.shared.handle(userInfo: userInfo)
        }
        completionHandler(.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        PushNotificationsService.shared.handle(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
}
