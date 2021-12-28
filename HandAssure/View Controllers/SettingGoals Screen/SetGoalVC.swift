//
//  SetGoalVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 26/10/20.
//

import UIKit
import CoreData
class SetGoalVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var roundView: UIView!
    // MARK: Properties
    var toolBar = UIToolbar()
    var toolBar1 = UIToolbar()
    var picker  = UIPickerView()
    let weekValue = [1,2,3,4,5,6,7]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.minuteInterval = 15
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        }
        return picker
    }()
    var weekData:[Int] = []
    var convertedTime:[Date] = []
    var param: [String:Any] = [:]
    var timeListArr:[Date] = []
    var timeData = [Scheduler]()
    var databaseArr = [Setting]()
    var notificationData = [NotificationData]()
    var newTimeAfterEdit:[Date] = []
    var selectedTimes:Int = 0
    var timeInterval:Int = 0
    var isFromSetting:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerViewConnection()
        DatePickerViewConnection()
        loadOnnWeekValue()
        getNewTime()
        if isFromSetting {
            self.title = "Set Reminder"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        }
        DispatchQueue.main.async {
            self.roundView.roundCorners([.topRight, .topLeft], radius: 20.0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFromSetting {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.navigationController?.isNavigationBarHidden =  true
        }
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func BtnSetGoalsPressed(_ sender: UIView) {
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    @IBAction func btnSetTimeInterval(_ sender: UIView) {
        self.view.addSubview(datePicker)
        self.view.addSubview(toolBar1)
    }
    // MARK: - Format to save time in array
    func toStringDate(givenDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let convertedDate = formatter.date(from: givenDate) else { return Date() }
        return convertedDate
    }
    // MARK: - Format to save time in array
    func toPerFectDate(givenDate: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = formatter.string(from: givenDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let convertedDate = dateFormatter.date(from: strDate) else { return Date() }
        return convertedDate
    }
    
}
//MARK:- UiPicker View DataSource Assigning
extension SetGoalVC : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)  Times"
    }
}
//MARK:- UiPicker View Delegate Assigning
extension SetGoalVC : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //         let itemselected = extraServices[row]
        //         lblGetServices.text = itemselected
    }
}
// MARK: - The Time Difference Function
extension SetGoalVC {
    
    // MARK:  Function To Add Time And Get List
    
    func timeDiff(t1:Date, t2:Date, noOfTimesMain:Int, timeSlotInMinMain:Int, isFromGoal: Bool) {
        deleteNotifications()
        deleteAllRecords(entityName: "Scheduler")
        timeListArr.removeAll()
        let difference = Calendar.current.dateComponents([.hour, .minute], from: t1, to: t2)
        var totalTimeInMin = 0
        var timeSlotInMin = timeSlotInMinMain
        var noOfTimes = noOfTimesMain
        if isFromGoal {
            totalTimeInMin = (difference.hour! * 60) + (difference.minute!)
            if totalTimeInMin >= noOfTimes {
                timeSlotInMin = (totalTimeInMin / noOfTimes)
            } else {
                showAlert(title: "Warning", message: "Manage your selected interval")
            }
        } else {
            totalTimeInMin = (difference.hour! * 60) + (difference.minute!)
            if totalTimeInMin >= timeSlotInMin {
                noOfTimes = Int(totalTimeInMin / timeSlotInMin)
            } else {
                showAlert(title: "Warning", message: "Manage your selected interval")
            }
        }
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: (calendar.component(.hour, from: t1)), minute: (calendar.component(.minute, from: t1)), second: (calendar.component(.second, from: t1)), of: Date())!
        var previousValue: Date?
        for i in 0..<noOfTimes {
            var addminutes = date.addingTimeInterval(TimeInterval(timeSlotInMin * 60))
            if previousValue != nil {
                addminutes = previousValue!.addingTimeInterval(TimeInterval(timeSlotInMin * 60))
            }
            previousValue = addminutes
            timeListArr.append(toPerFectDate(givenDate: addminutes))
            addTimeSchedule(time: timeListArr[i], identifier: NSDate().timeIntervalSince1970)
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        for j in 0..<weekData.count {
            for i in 0..<timeListArr.count {
                let comp = timeListArr[i].get(.hour,.minute,.year)
                let timestamp = NSDate().timeIntervalSince1970
                appDelegate?.scheduleNotification(id: "\(timestamp)", i: NSNumber(value: i + 1),weekday: weekData[j] ,hour:comp.hour ?? 10,minute: comp.minute ?? 10,title: "It's time to wash your hands to stay safe!",body: "Swipe or tap to record your handwash!")
            }
        }
        getNewTime()
        print(timeListArr)
    }
    
    //MARK:  Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true)
    }
    
    func getNewTime() {
        loadSchedulerValue()
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
                let comp = date?.get(.hour,.minute,.year)
           // let timestamp = NSDate().timeIntervalSince1970
            appDelegate?.scheduleNotification(id: "\(30 + j)Last", i: NSNumber(value: 1),weekday: weekData[j] ,hour:comp?.hour ?? 10,minute: comp?.minute ?? 10,title: "Congratulations!",body: "You have achieved your daily handwash goal")
            }
        } else {
            for j in 0..<weekData.count {
                let comp = date?.get(.hour,.minute,.year)
            //let timestamp = NSDate().timeIntervalSince1970
            appDelegate?.scheduleNotification(id: "\(30 + j)Last", i: NSNumber(value: 1),weekday: weekData[j] ,hour:comp?.hour ?? 10,minute: comp?.minute ?? 10,title: "Almost there!",body: "Try to meet your daily handwash goal tommorow!")
            }
        }
        print(date)
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
}
extension NSDate: Comparable { }

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqual(to: rhs as Date)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}


