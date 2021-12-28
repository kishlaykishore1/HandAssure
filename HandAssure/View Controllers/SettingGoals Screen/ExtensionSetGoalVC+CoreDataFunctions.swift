//
//  ExtensionSetGoalVC+CoreDataFunctions.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/11/20.
//

import Foundation
import UIKit
import CoreData

extension SetGoalVC {
    // MARK: - Load Data From Core Data With Matching Date
    func loadOnnWeekValue()  {
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
    // MARK: - Load Schedular Data From Core Data Where status = 1
    func loadSchedulerValue()  {
        let request : NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        request.predicate = NSPredicate(format:"status == %@",NSNumber(value: true))
        do {
            timeData = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - Delete Data From Core Data With Matching Date
    func deleteNotifications() {
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
       let cal = Calendar.current
       let startOfDay = cal.startOfDay(for: Date())
       let endOfDay = cal.date(byAdding: .day, value: 1, to: startOfDay)!
        fetchRequest.predicate = NSPredicate(format:"received_date >= %@ AND received_date < %@", startOfDay as NSDate, endOfDay as NSDate)
       let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - Save To Core Data
    func saveScheduler() {
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
    }
    // MARK: - Delete All Data In An Entity
    func deleteAllRecords(entityName:String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    // MARK: - Add Data To Scheduler Table 
    func addTimeSchedule(time:Date,identifier:Double) {
        let scheduler = Scheduler(context: context)
        scheduler.id = identifier
        scheduler.time = time
        saveScheduler()
    }
}
