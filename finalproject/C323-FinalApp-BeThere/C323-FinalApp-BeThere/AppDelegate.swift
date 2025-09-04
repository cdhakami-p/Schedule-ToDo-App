//
//  AppDelegate.swift
//  C323-BeThere
//
//  Created by Hope Barker on 4/22/25.
//
// Casey Hakami - cdhakami@iu.edu, Jarret Rockwell - jarrrock@iu.edu
// BeThere
// 05/07/2025


import UIKit
import UserNotifications
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var myBeThereModel: BeThereModel = BeThereModel()
    var locationManager: CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let savedData = BeThereModel.load() {
            self.myBeThereModel = savedData
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Noti perm error")
            } else {
                if granted {
                    print("Noti perm granted")
                } else {
                    print("Noti perm denied")
                }
            }
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        print("location permission")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            let content = UNMutableNotificationContent()
            content.title = "You're near an event!"
            content.body = "You're near \(region.identifier)"
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: "region-\(region.identifier)", content: content, trigger: nil)
            
            UNUserNotificationCenter.current().add(request)
            print("loc noti check")
        }
    }
}

