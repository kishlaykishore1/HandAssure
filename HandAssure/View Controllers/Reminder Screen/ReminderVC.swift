//
//  ReminderVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 02/11/20.
//

import UIKit
import CoreData
class ReminderVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var weekArr = ["S","M","T","W","T","F","S"]
    var databaseArr = [Setting]()
    var fullTimeList = [Scheduler]()
    var timeList = [Scheduler]()
    var weekCount = [Setting]()
    var notificationData = [NotificationData]()
    var weekData:[Int] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOnnWeekValue()
        loadSetting()
        loadscheduler()
        self.title = "Reminder"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func switchAction(_ sender: UISwitch) {
        fullTimeList[sender.tag].status = !fullTimeList[sender.tag].status
        saveSetting()
        //  let comp = fullTimeList[sender.tag].time?.get(.hour,.minute,.year)
        if fullTimeList[sender.tag].status {
            loadOnnWeekValue()
            notification()
        } else {
            loadOnnWeekValue()
            notification()
        }
        tableView.reloadData()
    }
}
// MARK: -  CollectionView DataSource Methods
extension ReminderVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderCollectionCell", for: indexPath) as! ReminderCollectionCell
        cell.lblWeekName.text = weekArr[indexPath.row]
        cell.backView.backgroundColor = (databaseArr[indexPath.row].is_selected) ? #colorLiteral(red: 0.07450980392, green: 0.1058823529, blue: 0.6039215686, alpha: 1) : #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        cell.lblWeekName.textColor = (databaseArr[indexPath.row].is_selected) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
}
// MARK: -  CollectionView Delegate Methods
extension ReminderVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        context.delete(databaseArr[indexPath.row])
        //        databaseArr.remove(at: indexPath.row)
        databaseArr[indexPath.row].is_selected = !(databaseArr[indexPath.row].is_selected)
        saveSetting()
        if !databaseArr[indexPath.row].is_selected {
            loadOnnWeekValue()
            notification()
            print("ok")
        } else {
            loadOnnWeekValue()
            notification()
            print(print("Notok"))
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadData()
    }
}
// MARK: - CollectionView DelegateFlowLayout
extension ReminderVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth / 7, height: 35.0)
    }
}
//MARK:- TableView DataSource Methods
extension ReminderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullTimeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableCell", for: indexPath) as! ReminderTableCell
        cell.lblSwitch.tag = indexPath.row
        cell.lblSwitch.isOn = fullTimeList[indexPath.row].status
        cell.lblTime.text = toTime(time: fullTimeList[indexPath.row].time ?? Date())
        return cell
    }
}
//MARK:- TableView Delegate Methods
extension ReminderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
}
// MARK: - Collection View Cell Class For Table View Second Cell
class ReminderCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblWeekName: UILabel!
    
}
//MARK:- TableView cell class
class ReminderTableCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSwitch: UISwitch!
    
}
// MARK: - Notification Related Functions
extension ReminderVC {
    func notification() {
        loadSchedulerValue()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for j in 0..<weekData.count {
            for i in 0..<timeList.count {
                let comp = timeList[i].time?.get(.hour,.minute,.year)
                let timestamp = NSDate().timeIntervalSince1970
                appDelegate?.scheduleNotification(id: "\(timestamp)", i: NSNumber(value: i + 1),weekday: weekData[j] ,hour:comp?.hour ?? 10,minute: comp?.minute ?? 10,title: "It's time to wash your hands to stay safe!",body: "Swipe or tap to record your handwash!")
            }
        }
        getNewTime()
    }
    
    func getNewTime() {
        loadSchedulerValue()
        var newTime = Date()
        if !timeList.isEmpty {
            newTime = timeList[timeList.count - 1].time ?? Date()
        }
        print(newTime)
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 30, to: newTime)
        loadNotification(selectedDate: newTime)
        if notificationData.count == timeList.count {
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
}


