//
//  HomeVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 27/10/20.
//

import UIKit
import SideMenu
import CoreData
class HomeVC: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("handleNotification"), object: nil)
        }
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var shadowView: DesignableView!
    @IBOutlet weak var innerView: DesignableView!
    @IBOutlet weak var lblMainCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    var param:[String:Any]!
    var selectedDate = Date()
    var notificationData = [NotificationData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fullTimeList = [Scheduler]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // loadscheduler()
        DispatchQueue.main.async {
            self.shadowView.layer.cornerRadius = self.shadowView.frame.height / 2
            self.innerView.layer.cornerRadius = self.innerView.frame.height / 2
            self.dataView.layer.cornerRadius = self.dataView.frame.height / 2
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("handleNotification"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadscheduler()
        loadNotification()
        lblMainCount.text = "\(notificationData.count)/\(fullTimeList.count)"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @objc func handleNotification(_ notification: NSNotification) {
        loadNotification()
        lblMainCount.text = "\(notificationData.count)/\(fullTimeList.count)"
    }
    
    @IBAction func btnViewHistoryPressed(_ sender: UIButton) {
        let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"HistoryVC") as! HistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSideMenu(_ sender: UIBarButtonItem) {
        openSideMenu()
    }
    @IBAction func btnReportHistory(_ sender: UIBarButtonItem) {
        let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"ReportVC") as! ReportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnNotification(_ sender: UIBarButtonItem) {
        let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"ReminderVC") as! ReminderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnHomeTips(_ sender: UIBarButtonItem) {
        let vc = StoryBoard.Main.instantiateViewController(withIdentifier: "WashingTipsVC") as! WashingTipsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: Side Menu Function
    func openSideMenu() {
        let viewController = StoryBoard.Main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: viewController)
        menu.presentationStyle = .menuSlideIn
        menu.statusBarEndAlpha = 0
        menu.leftSide = true
        // menu.settings.blurEffectStyle = .dark
        menu.presentationStyle.presentingEndAlpha = 0.5
        menu.settings.enableTapToDismissGesture = true
        menu.menuWidth = UIScreen.main.bounds.size.width * 0.75
        present(menu, animated: true, completion: nil)
    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadNotification() {
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
        tableView.reloadData()
        print(notificationData)
    }
    // MARK: - Load Data From Core Data
    func loadscheduler() {
        let request: NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        request.predicate = NSPredicate(format:"status == %@",NSNumber(value: true))
        do {
            fullTimeList = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - date Convert
    func toTime(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: time)
    }
    // MARK: - date Convert for date label
    func toDate(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MMM-yy"
        let date = dateFormatter.string(from: time)
        return date
    }
}
//MARK:- TableView DataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (notificationData.count) > 0 {
            if  (notificationData.count) >= 2 {
                tableViewHeight.constant = 190
                backgroundView.isHidden = true
                return 2
            } else {
                tableViewHeight.constant = 90
                backgroundView.isHidden = true
                return notificationData.count
            }
        } else {
            tableViewHeight.constant = 89
            backgroundView.isHidden = false
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        cell.lblTime.text = toTime(time: notificationData[indexPath.row].notification_time ?? Date())
        return cell
    }
}
//MARK:- TableView DataSource
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
//MARK:- TableView cell class
class HistoryTableCell: UITableViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
}

