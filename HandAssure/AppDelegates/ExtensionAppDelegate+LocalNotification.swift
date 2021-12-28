//
//  ExtensionAppDelegate+LocalNotification.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/11/20.
//

import Foundation
import CoreData
import UIKit

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // MARK: Prepare New Notificaion with deatils and trigger
    func scheduleNotification(id:String,i:NSNumber,weekday: Int, hour: Int, minute: Int,title:String,body:String) {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        content.sound = UNNotificationSound.default
        content.title = title
        content.body = body
        content.badge = i
        content.categoryIdentifier = categoryIdentifire
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.weekday = weekday
        let trigger = UNCalendarNotificationTrigger(dateMatching:components, repeats: true)
        print(trigger.nextTriggerDate())
        let identifier = id
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("Scheduled :: ", request.identifier)
                print("okk :: ",request.trigger)
            }
        }
        // MARK: Add Action button to the Notification
        let acceptAction = UNNotificationAction(identifier: "Accept", title: "Accept", options: [])
        let rejectAction = UNNotificationAction(identifier: "Reject", title: "Reject", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [acceptAction, rejectAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
        print(self.notificationCenter)
    }
    // MARK: - Alert Controller After Tapping On Notification
    func alertAction(notifyID:Double,time:Date) {
        let alertController = UIAlertController(title: "", message: "Washed The Germs Away?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.addnotification(notifyId: notifyID, time: time)
          //  self.getNewTime()
            NotificationCenter.default.post(name: NSNotification.Name("handleNotification"), object: nil, userInfo: nil)
//            if let getNav =  UIApplication.topViewController()?.navigationController {
//                getNav.viewWillAppear(true)
//            }
            alertController.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("handleNotification"), object: nil, userInfo: nil)
//                if let getNav =  UIApplication.topViewController()?.navigationController {
//                    getNav.viewWillAppear(true)
//                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            
        }))
        if let getNav =  UIApplication.topViewController()?.navigationController {
            getNav.present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Local Notification Delegate functions
    
    //Handle Notification Center Delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        let time = response.notification.date
        let actionIdentifier = response.actionIdentifier
        switch actionIdentifier {
        case "Accept":
            if !identifier.contains("Last") {
                addnotification(notifyId: Double(identifier) ?? 0.0 , time: time)
            }
            NotificationCenter.default.post(name: NSNotification.Name("handleNotification"), object: nil, userInfo: nil)
//            if let getNav =  UIApplication.topViewController()?.navigationController {
//                getNav.viewWillAppear(true)
//            }
        case "Reject":
            print("Unsubscribe Reader")
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            if !identifier.contains("Last") {
             alertAction(notifyID: Double(identifier) ?? 0.0, time: time)
            }
            completionHandler()
        default:
            completionHandler()
        }
        completionHandler()
    }
    func getNewTime() {
        loadscheduler()
        var newTime = Date()
        if !timeData.isEmpty {
            newTime = timeData[timeData.count - 1].time ?? Date()
        }
        print(newTime)
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 30, to: newTime)
        loadNotification(selectedDate: newTime)
        if notificationData.count == timeData.count {
            for j in 0..<weekData.count {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(Double(30 + j))"])
                let comp = date?.get(.hour,.minute,.year)
           // let timestamp = NSDate().timeIntervalSince1970
            scheduleNotification(id: "\(30 + j)Last", i: NSNumber(value: 1),weekday: weekData[j] ,hour:comp?.hour ?? 10,minute: comp?.minute ?? 10,title: "Congratulations!",body: "You have achieved your daily handwash goal.")
            }
        } else {
            for j in 0..<weekData.count {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(Double(30 + j))"])
                let comp = date?.get(.hour,.minute,.year)
            //let timestamp = NSDate().timeIntervalSince1970
            scheduleNotification(id: "\(30 + j)Last", i: NSNumber(value: 1),weekday: weekData[j] ,hour:comp?.hour ?? 10,minute: comp?.minute ?? 10,title: "Almost there!",body: "Try to meet your daily handwash goal tommorow!")
            }
        }
        print(date)
    }
}

