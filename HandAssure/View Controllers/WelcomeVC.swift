//
//  WelcomeVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 24/10/20.
//

import UIKit

class WelcomeVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtSleepingTime: UITextField!
    @IBOutlet weak var txtWakeupTime: UITextField!
    @IBOutlet weak var btnNext: DesignableButton!
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if userDefault.object(forKey: "wakeUpTime") != nil {
            picker.date = userDefault.object(forKey: "wakeUpTime") as! Date
        }
        picker.datePickerMode = .time
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        }
        return picker
    }()
    lazy var timePicker:UIDatePicker = {
        let picker = UIDatePicker()
        if userDefault.object(forKey: "sleepingTime") != nil {
            picker.date = userDefault.object(forKey: "sleepingTime") as! Date
        }
        picker.datePickerMode = .time
        
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        }
        return picker
    }()
    let userDefault = UserDefaults.standard
    var isFromSetting:Bool = false
    var time1: Date?
    var time2: Date?
    var param:[String:Any] = [:]
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        txtSleepingTime.delegate = self
        txtWakeupTime.delegate = self
        txtSleepingTime.addImageTo(txtField: txtSleepingTime, andImage: #imageLiteral(resourceName: "DropDownIcon"), isLeft: false)
        txtWakeupTime.addImageTo(txtField: txtWakeupTime, andImage: #imageLiteral(resourceName: "DropDownIcon"), isLeft: false)
        if isFromSetting {
            self.title = "Update Profile"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        }
        guard let t1 = userDefault.object(forKey: "wakeUpTime") as? Date else {
            return
        }
        guard let t2 = userDefault.object(forKey: "sleepingTime") as? Date else {
            return
        }
        time1 = t1
        time2 = t2
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFromSetting {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.btnNext.setTitle("Update", for: .normal)
        } else {
            self.navigationController?.isNavigationBarHidden =  true
            self.btnNext.setTitle("NEXT", for: .normal)
        }
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: Action For Next Button
    @IBAction func btnNextPressed(_ sender: UIButton) {
        if Validation.isBlank(for: txtName.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyName, alertType: .error)
            return
        } else if Validation.isBlank(for: txtAge.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyAge, alertType: .error)
            return
        } else if Validation.isBlank(for: txtWakeupTime.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyWakeUpTime, alertType: .error)
            return
        } else if Validation.isBlank(for: txtSleepingTime.text ?? "") {
            Common.showAlertMessage(message: Messages.emptySleepingTime, alertType: .error)
            return
        }
        userDefault.set(txtName.text, forKey: "userName")
        userDefault.set(txtAge.text, forKey: "userAge")
        userDefault.set(time1, forKey: "wakeUpTime")
        userDefault.set(time2, forKey: "sleepingTime")
        self.view.endEditing(true)
        param["wakeupTime"] = time1
        param["sleepTime"] = time2
        if isFromSetting {
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"SetGoalVC") as! SetGoalVC
            vc.param = param
            vc.isFromSetting = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"SetGoalVC") as! SetGoalVC
            vc.param = param
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: Action For Wakeup View Pressed
    @IBAction func viewWakeUp(_ sender: UIView) {
        txtWakeupTime.inputView = datePicker
        txtWakeupTime.becomeFirstResponder()
    }
    // MARK: Action For Sleeping View Pressed
    @IBAction func viewSleepingTime(_ sender: UIView) {
        txtSleepingTime.inputView = timePicker
        txtSleepingTime.becomeFirstResponder()
    }
    // MARK: - Format to save time in array
    func toStringDate(givenDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let strDate = formatter.string(from: givenDate)
        return strDate
    }
    // MARK: - Set Data To TextField
    func setData() {
        if isFromSetting {
            txtName.text = userDefault.string(forKey:"userName")
            txtAge.text = userDefault.string(forKey: "userAge")
            txtWakeupTime.text =  toStringDate(givenDate: userDefault.object(forKey: "wakeUpTime") as! Date)
            txtSleepingTime.text = toStringDate(givenDate: userDefault.object(forKey: "sleepingTime") as! Date)
        }
    }
}
//MARK:- UitextField Delegate Method
extension WelcomeVC :UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            txtWakeupTime.inputView = datePicker
            
        } else if textField.tag == 2 {
            txtSleepingTime.inputView = timePicker
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeStyle = DateFormatter.Style.none
            dateFormatter1.dateFormat = "h:mm a"
            let date = dateFormatter1.string(from: self.datePicker.date)
            time1 = self.datePicker.date
            txtWakeupTime.text = date
        } else if textField.tag == 2 {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeStyle = DateFormatter.Style.none
            dateFormatter1.dateFormat = "h:mm a"
            let date = dateFormatter1.string(from: self.timePicker.date)
            if self.timePicker.date < self.datePicker.date {
                let newDate = Calendar.current.date(byAdding: .day, value: 1, to: self.timePicker.date)
                time2 = newDate
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = DateFormatter.Style.none
            dateFormatter2.dateFormat = "h:mm a"
                let date2 = dateFormatter1.string(from: newDate ?? Date())
                txtSleepingTime.text = date2
            } else {
                time2 = self.timePicker.date
                txtSleepingTime.text = date
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

