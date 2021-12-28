//
//  ReportVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/10/20.
//

import UIKit
import Charts
import CoreData
class ReportVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var btnWeekly: DesignableButton!
    @IBOutlet weak var btnMonthly: DesignableButton!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblDateRange: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTimesOfWashes: UILabel!
    @IBOutlet weak var lblWeekGoals: UILabel!
    @IBOutlet weak var lblGoalStatus: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblScroll: UILabel!
    // MARK: - Properties
    var isWeekly = true
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    var arrThisWeek: [Date] = []
    var thisWeekData:[Int] = []
    var weekValueCount: [Int] = []
    var arrThisMonth: [Date] = []
    var thisMonthData:[Int] = []
    var monthValueCount: [Int] = []
    var currentMonth = Date()
    let dateFormat = "MMM dd"
    let arrWeekName = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
    var arrMonthDays: [String] = []
    var notificationHistory = [NotificationData]()
    var timeData = [Scheduler]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeek()
        getAllMonthDays()
        loadscheduler()
        setDataForPastPhysicalAlighment(isWeekly)
        self.title = "HAND WASH REPORTS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        DispatchQueue.main.async {
            self.roundView.roundCorners([.topRight, .topLeft], radius: 20.0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setValue()
        setDownLabel()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: ButtonWeekly Tap Action
    @IBAction func btnWeeklyAction(_ sender: UIButton) {
        tabSelected(true)
    }
    // MARK: ButtonMonthly Tap Action
    @IBAction func btnMonthlyAction(_ sender: UIButton) {
        tabSelected(false)
    }
    // MARK: BackButton Tap Action
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: LeftButton Tap Action
    @IBAction func BtnLeftAction(_ sender: UIButton) {
        if isWeekly {
            getWeekCount()
            prevWeekData(currentWeek: arrThisWeek)
            setValue()
            setDownLabel()
        } else {
            prevMonthData()
            getAllMonthDays()
            setValue()
            setDownLabel()
            collectionView.reloadData()
        }
    }
    // MARK: RightButton Tap Action
    @IBAction func btnRightAction(_ sender: UIButton) {
        if isWeekly {
            nextWeekData(currentWeek: arrThisWeek)
            getWeekCount()
            setValue()
            setDownLabel()
            collectionView.reloadData()
        } else {
            nextMonthData()
            getAllMonthDays()
            setValue()
            setDownLabel()
            collectionView.reloadData()
        }
    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadHistory(startDate:Date) -> Int  {
        let request : NSFetchRequest<NotificationData> = NotificationData.fetchRequest()
        let cal = Calendar.current
        let startOfDay = startDate
        let endOfDay = cal.date(byAdding: .day, value: 1, to: startDate)!
        request.predicate = NSPredicate(format: "received_date >= %@ AND received_date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "received_date", ascending: true)]
        do {
            notificationHistory = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
        let integer = notificationHistory.count
        collectionView.reloadData()
        return integer
    }
    // MARK: - Load Data From Core Data With Matching Date
    func loadCount(startDate:Date) -> Int  {
        let request : NSFetchRequest<NotificationData> = NotificationData.fetchRequest()
        let cal = Calendar.current
        let startOfDay = startDate
        let endOfDay = cal.date(byAdding: .day, value: 1, to: startDate)!
        request.predicate = NSPredicate(format: "received_date >= %@ AND received_date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "received_date", ascending: true)]
        do {
            notificationHistory = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
        let integer = notificationHistory.first?.goals_number ?? 0
        collectionView.reloadData()
        return Int(integer)
    }
    
    // MARK: - Load Data From Core Data
    func loadscheduler() {
        let request: NSFetchRequest<Scheduler> = Scheduler.fetchRequest()
        request.predicate = NSPredicate(format:"status == %@",NSNumber(value: true))
        do {
            timeData = try context.fetch(request)
        } catch {
            print("Error if any \(error)")
        }
    }
    // MARK: - Function Get Current Date
    func getCurrentWeek() {
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek ?? Date())!)
        }
        getWeekCount()
    }
    // MARK: - Function To set Label Value
    func setValue() {
        if isWeekly {
            lblDateRange.text = "\(arrThisWeek.first!.toDate(format: dateFormat)) - \(arrThisWeek.last!.toDate(format: dateFormat))"
        } else {
            lblDateRange.text = Date().toMonth(month: currentMonth)
        }
    }
    // MARK: - Set Data For Week Average
    func setDownLabel() {
        if isWeekly {
            let sum = thisWeekData.reduce(0, +)
            lblTimesOfWashes.text = "\(sum) Times / Week"
            let numb: Double = Double(sum) / Double(thisWeekData.count)
            let doubleValue = String(format: "%.2f", numb)
            if numb <= 0 {
                lblWeekGoals.text = "0.00 Times / Day"
            } else {
                lblWeekGoals.text = "\(doubleValue) Times / Day"
            }
            if  sum == thisWeekData.count * timeData.count {
                lblGoalStatus.text = "Completed"
            } else if Date() <= arrThisWeek.last ?? Date() && sum != thisWeekData.count * timeData.count {
                lblGoalStatus.text = "Pending"
            } else {
                lblGoalStatus.text = "Incompleted"
            }
        } else {
            let monthSum = thisMonthData.reduce(0, +)
            lblTimesOfWashes.text = "\(monthSum) Times / Month"
            let monthNumb: Double = Double(monthSum) / Double(thisMonthData.count)
            let doubleValue = String(format: "%.2f", monthNumb)
            print(doubleValue)
            if monthNumb <= 0 {
                lblWeekGoals.text = "0.00 Times / Day"
            } else {
                lblWeekGoals.text = "\(doubleValue) Times / Day"
            }
            if  monthSum == thisMonthData.count * timeData.count {
                lblGoalStatus.text = "Completed"
            } else if Date() <= arrThisMonth.last ?? Date() && monthSum != thisMonthData.count * timeData.count {
                lblGoalStatus.text = "Pending"
            } else {
                lblGoalStatus.text = "Incompleted"
            }
        }
    }
    // MARK: - Get Data For Week
    func getWeekCount() {
        thisWeekData.removeAll()
        weekValueCount.removeAll()
        for i in 0..<arrThisWeek.count {
            thisWeekData.append(loadHistory(startDate: arrThisWeek[i]))
            weekValueCount.append(loadCount(startDate: arrThisWeek[i]))
        }
        collectionView.reloadData()
    }
    func getMonthCount() {
        thisMonthData.removeAll()
        monthValueCount.removeAll()
        for i in 0..<arrThisMonth.count {
            thisMonthData.append(loadHistory(startDate: arrThisMonth[i]))
            monthValueCount.append(loadCount(startDate: arrThisMonth[i]))
        }
        collectionView.reloadData()
    }
    // MARK: - Function To Get Previous Week Data
    func prevWeekData(currentWeek:[Date]) {
        var arrPreviousWeek: [Date] = []
        for i in 1...7 {
            arrPreviousWeek.append(Calendar.current.date(byAdding: .day, value: -i, to: currentWeek.first!)!)
        }
        arrPreviousWeek.reverse()
        arrThisWeek = arrPreviousWeek
        getWeekCount()
        setValue()
    }
    // MARK: - Function To Get Previous Month Data
    func prevMonthData() {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)
        currentMonth = previousMonth ?? Date()
        setValue()
    }
    // MARK: - Function To Get Next Week Data
    func nextWeekData(currentWeek:[Date]) {
        var arrNextWeek: [Date] = []
        for i in 1...7 {
            arrNextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: currentWeek.last!)!)
        }
        arrThisWeek = arrNextWeek
        getWeekCount()
        setValue()
    }
    // MARK: - Function To Get Next Month Data
    func nextMonthData() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)
        currentMonth = nextMonth ?? Date()
        setValue()
        
    }
    // MARK: - First Day Of Month
    func firstDayOfTheMonth() -> Date {
    return Calendar.current.date(from:Calendar.current.dateComponents([.year,.month], from: currentMonth))!
    }
    // MARK: - Convert Month Array To Proper Format
    func toMonthDay(month: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: month)
    }
    // MARK: - Get All Days Of Month
    func getAllMonthDays() {
        arrMonthDays.removeAll()
        arrThisMonth.removeAll()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        var day = firstDayOfTheMonth()
        for _ in 1...range.count
        {
            arrMonthDays.append(toMonthDay(month: day))
            arrThisMonth.append(day)
            day.addDays(n: 1)
        }
        getMonthCount()
    }
    // MARK: - Tab Selection Function
    func tabSelected(_ isWeeklySelected: Bool) {
        if isWeeklySelected {
            setDataForPastPhysicalAlighment(true)
            btnWeekly.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            btnMonthly.backgroundColor = #colorLiteral(red: 0, green: 0.2509803922, blue: 0.768627451, alpha: 1)
            btnMonthly.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.73), for: .normal)
            btnWeekly.setTitleColor(#colorLiteral(red: 0.07450980392, green: 0.1058823529, blue: 0.6039215686, alpha: 1), for: .normal)
            isWeekly = true
            setValue()
            setDownLabel()
        } else {
            setDataForPastPhysicalAlighment(false)
            btnWeekly.backgroundColor = #colorLiteral(red: 0, green: 0.2509803922, blue: 0.768627451, alpha: 1)
            btnMonthly.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            btnMonthly.setTitleColor(#colorLiteral(red: 0.07450980392, green: 0.1058823529, blue: 0.6039215686, alpha: 1),for: .normal)
            btnWeekly.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.73), for: .normal)
            isWeekly = false
            setValue()
            setDownLabel()
        }
        collectionView.reloadData()
    }
}
// MARK: - Collection View DataSource
extension ReportVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isWeekly ? arrWeekName.count : arrMonthDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath) as! GraphCell
        if isWeekly {
            cell.lblName.text = arrWeekName[indexPath.row]
            cell.graphHeight.constant = CGFloat(thisWeekData[indexPath.row] * 16)
            if weekValueCount[indexPath.row] == thisWeekData[indexPath.row] {
                cell.graphView.backgroundColor = #colorLiteral(red: 0.5607843137, green: 0.7568627451, blue: 0.3607843137, alpha: 1)
            } else {
                cell.graphView.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.6352941176, blue: 0.9568627451, alpha: 1)
            }
        } else {
            cell.lblName.text = arrMonthDays[indexPath.row]
            cell.graphHeight.constant = CGFloat(thisMonthData[indexPath.row] * 16)
            if monthValueCount[indexPath.row] == thisMonthData[indexPath.row] {
                cell.graphView.backgroundColor = #colorLiteral(red: 0.5607843137, green: 0.7568627451, blue: 0.3607843137, alpha: 1)
            } else {
                cell.graphView.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.6352941176, blue: 0.9568627451, alpha: 1)
            }
        }
        return cell
    }
}

extension ReportVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isWeekly {
            return CGSize(width: 38, height: 400)
        } else {
            return CGSize(width: 54, height: 400)
        }
    }
}

extension ReportVC: UICollectionViewDelegate {
    
}

class GraphCell: UICollectionViewCell {
    
    @IBOutlet weak var graphHeight: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var graphView: DesignableButton!
}
extension Date {
    
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func toMonth(month: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: month)
    }

    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
// MARK: - Button Personal And Corporat Animation
extension ReportVC {
    func setDataForPastPhysicalAlighment(_ isWeekly: Bool) {
        switch isWeekly {
        case false:
               heightConstraint.priority = UILayoutPriority(rawValue: 997)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }) { finished in
                    self.lblScroll.isHidden = false
                }
        case true:
               heightConstraint.priority = UILayoutPriority(rawValue: 999)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                    self.lblScroll.isHidden = true
                }) { finished in
                    
            }
        default:
        break
        }
    }
}
