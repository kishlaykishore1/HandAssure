//
//  AppDelegate.swift
//  HandAssure
//
//  Created by kishlay kishore on 24/10/20.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    let notificationCenter = UNUserNotificationCenter.current()
    let weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var window: UIWindow?
    var weekValue = [1,2,3,4,5,6,7]
    var weekData:[Int] = []
    var notificationData = [NotificationData]()
    var timeData = [Scheduler]()
    var databaseArr = [Setting]()
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "HandAssure")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
     
    // MARK: App Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        addWeekDays()
        loadOnnWeekValue()
        registerBackgroundTaks()
        UIApplication.shared.applicationIconBadgeNumber = 0
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Confirm Delegete and request for Notification permission
        
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        // Root Window Setting Code
        if UserDefaults.standard.string(forKey: "userName") != nil {
            isUserLogin(true)
        } else {
            isUserLogin(false)
        }
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    //MARK: Regiater BackGround Tasks
    private func registerBackgroundTaks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.HandAssure.notification", using: nil) { task in
            //This task is cast with processing request (BGProcessingTask)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.HandAssure.apprefresh", using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
        }
    }
}
// MARK: Setting Root View Controller
extension AppDelegate {
    func isUserLogin(_ isLogin: Bool) {
        if isLogin {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.window?.rootViewController = UINavigationController(rootViewController: HomeVC)
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.window?.rootViewController = UINavigationController(rootViewController: welcomeVC)
            self.window?.makeKeyAndVisible()
        }
    }
}

