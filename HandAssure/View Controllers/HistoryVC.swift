//
//  HistoryVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 28/10/20.
//

import UIKit
import CoreData
class HistoryVC: UIViewController {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHistoryCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    var toolBar = UIToolbar()
    var notificationData = [NotificationData]()
    var selectedDate = Date()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        }
        picker.datePickerMode = .date
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerViewConnection()
        loadNotification()
        lblDate.text = toDate(time: selectedDate)
        self.title = "HAND WASH HISTORY"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @IBAction func dateViewPressed(_ sender: UIView) {
        self.view.addSubview(datePicker)
        self.view.addSubview(toolBar)
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:-Picker View Setup
    func PickerViewConnection() {
        datePicker.backgroundColor = UIColor.white
        datePicker.setValue(UIColor.black, forKey: "textColor")
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.contentMode = .center
        datePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDoneButtonTapped))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel, flexibleSpace, done], animated: false)
    }
    //MARK:- The Function For the Picker Done button
    @objc func onDoneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MMM-yy"
        let date = dateFormatter.string(from: self.datePicker.date)
        selectedDate = self.datePicker.date
        lblDate.text = date
        loadNotification()
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        lblDate.resignFirstResponder()
    }
    //MARK:- The Function For the Picker Cancel button
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
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
    // MARK: - Save To Core Data
     func saveNotification() {
         do {
             try context.save()
         } catch {
             print("Error Saving Context \(error)")
         }
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
        lblHistoryCount.text = "\(notificationData.count)"
        tableView.reloadData()
       print(notificationData)
     }
}
//MARK:-Table View DataSource Methods
extension HistoryVC:UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationData.count == 0 {
            backgroundView.isHidden = false
            } else {
            backgroundView.isHidden = true
            }
        return notificationData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WashHistoryCell") as! WashHistoryCell
        cell.lblTime.text = toTime(time: notificationData[indexPath.row].notification_time ?? Date())
        return cell
    }
}
//MARK:-Table View Delegates Methods
extension HistoryVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //code
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
// MARK: - Table View First Cell Class
class WashHistoryCell: UITableViewCell {    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
}
