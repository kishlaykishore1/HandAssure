//
//  ExtensionAppDelegate+BackgroundTask.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/11/20.
//

import Foundation
import BackgroundTasks

//MARK:- BackGround Task helper
extension AppDelegate {
    
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    func scheduleNotification() {
        let request = BGProcessingTaskRequest(identifier: "com.HandAssure.notification")
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * (1 * 60 * 60)) // Featch Notification After 1 day.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule Notification fetch: \(error)")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.HandAssure.apprefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * (1 * 60 * 60)) // App Refresh after 24 hrs.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
