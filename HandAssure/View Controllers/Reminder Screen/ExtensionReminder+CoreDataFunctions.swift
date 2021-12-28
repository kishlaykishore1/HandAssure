//
//  ExtensionReminder+CoreDataFunctions.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/11/20.
//

import Foundation
import CoreData

extension ReminderVC {
    // MARK: - Add Data To Scheduler Table
    func addTimeSchedule(time:Date,identifier:Double) {
        let scheduler = Scheduler(context: context)
        scheduler.id = identifier
        scheduler.time = time
        saveSetting()
    }
    // MARK: - Save To Core Data
    func saveSetting() {
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    // MARK: - Load Setting Data From Core Data
    func loadSetting() {
        let request: NSFetchRequest<Setting> = Setting.fetchRequest()
        do {
            databaseArr = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
        print(databaseArr)
    }
    // MARK: - Load Scheduler Table Data From Core Data
    func loadscheduler() {
        let request: NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        do {
            fullTimeList = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - Load Schedular Data From Core Data Where status = 1
    func loadSchedulerValue()  {
        let request : NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        request.predicate = NSPredicate(format:"status == %@",NSNumber(value: true))
        do {
            timeList = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - Load Data From Core Data Where is_selected = 1
    func loadOnnWeekValue()  {
        weekData.removeAll()
        let request : NSFetchRequest<Setting> = Setting.fetchRequest()
        request.predicate = NSPredicate(format:"is_selected == %@",NSNumber(value: true))
        do {
            weekCount = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
        for i in 0..<weekCount.count {
            weekData.append(Int(weekCount[i].week_value))
        }
        print(weekData)
    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadNotification(selectedDate:Date) {
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
    // MARK: - Conert Date to Houre And Min Format
    func toTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
    }
}
