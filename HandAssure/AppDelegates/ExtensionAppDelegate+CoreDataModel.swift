//
//  ExtensionAppDelegate+CoreDataModel.swift
//  HandAssure
//
//  Created by Nandkishor Mewara on 03/11/20.
//

import Foundation
import CoreData
import UIKit

extension AppDelegate {
    // MARK: Add Notification Data To Notification History Table
    func addnotification(notifyId:Double,time:Date) {
        loadscheduler()
        let context = persistentContainer.viewContext
        let notificationClass = NotificationData(context: context)
        notificationClass.notification_id = notifyId
        notificationClass.notification_time = time
        notificationClass.received_date = Date()
        notificationClass.goals_number = Int16(timeData.count)
        saveSetting()
        self.getNewTime()
    }
    // MARK: - Load Data From Scheduler Table
    func loadscheduler() {
        let context = persistentContainer.viewContext
        let request : NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        request.predicate = NSPredicate(format:"status == %@",NSNumber(value: true))
        do {
            timeData = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
//    // MARK: - Load Data From Setting Table
//    func loadSetting() {
//        let context = persistentContainer.viewContext
//        let request: NSFetchRequest<Setting> = Setting.fetchRequest()
//        do {
//            databaseArr = try context.fetch(request)
//        } catch {
//            print("Error if any \(error)")
//        }
//        print(databaseArr)
//    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadNotification(selectedDate:Date) {
       let context = persistentContainer.viewContext
       notificationData.removeAll()
       let request : NSFetchRequest<NotificationData> = NotificationData.fetchRequest()
        let cal = Calendar.current
        let startOfDay = cal.startOfDay(for: selectedDate)
        let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(format: "received_date >= %@ AND received_date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "received_date", ascending: true)]
        do {
           notificationData = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
      print(notificationData)
    }
    // MARK: - Add WeekDays Data To Setting Table
    func addWeekDays() {
        var isEmpty: Bool {
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Setting")
                let count  = try persistentContainer.viewContext.count(for: request)
                return count == 0
            } catch {
                return true
            }
        }
        if isEmpty {
            for i in 0..<weekDays.count {
                let setting = Setting(context: persistentContainer.viewContext)
                setting.week_day = weekDays[i]
                setting.week_value = Int16(weekValue[i])
                saveSetting()
            }
        }
    }
    // MARK: - Save Setting Function To save The Table
    func saveSetting() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadOnnWeekValue()  {
        let context = persistentContainer.viewContext
        weekData.removeAll()
        let request : NSFetchRequest<Setting> = Setting.fetchRequest()
        request.predicate = NSPredicate(format:"is_selected == %@",NSNumber(value: true))
        do {
            databaseArr = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
        for i in 0..<databaseArr.count {
            weekData.append(Int(databaseArr[i].week_value))
        }
        print(weekData)
    }
    // MARK: - Core Data Saving support IF App get Terminated Suddenly
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
